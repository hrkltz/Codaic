import { AddTesseraDialog } from '../dialog/add_tessera_dialog';
import { CSSResultGroup, LitElement, TemplateResult, css, html } from 'lit';
import { customElement, query, state } from 'lit/decorators.js';
import { IndexedDBUtil } from '../util/indexeddb_util';
import { TesseraCoreComponent } from './tessera_core_component';
import { TesseraInputPortComponent } from './tessera_input_port_component';
import { TesseraOutputPortComponent } from './tessera_output_port_component';
import { Tessera } from '../tessera/tessera';
import { TesseraDto, TesseraPort, TesseraVisual } from '../tessera/tessera_dto';
import { v4 as uuidv4 } from 'uuid';


@customElement('editor-component')
export class EditorComponent extends LitElement {
    static override styles: CSSResultGroup = [
        css`
            :host,
            svg {
                width: 100%;
                height: 100%;
                box-sizing: border-box;
            }

            info-component {
                position: absolute;
                bottom: 0;
                right: 0;
                z-index: 10;
            }
        `,
        // Tessera component styles. (Note: The styles are not encapsulated in the shadow DOM as we don't use shadow DOM.)
        TesseraOutputPortComponent.styles,
        TesseraInputPortComponent.styles,
        TesseraCoreComponent.styles,
        // Tessera styles. (Note: The styles are not encapsulated in the shadow DOM as we don't use shadow DOM.)
        Tessera.styles,
    ];

    
    @query('g#transformer', true) _transformer!: SVGElement;
    @query('svg', true) _svg!: SVGElement;
    @state() private _clickedElement: { element: Element | null, parentElement: Element | null } = { element: null, parentElement: null };
    @state() private _hoveredElement: { element: Element | null, parentElement: Element | null } = { element: null, parentElement: null };
    private _ghostConnection: SVGLineElement | null = null;
    private _mousePositionX: number = 0;
    private _mousePositionY: number = 0;
    private _offsetX: number = 0;
    private _offsetY: number = 0;
    private _previousMouseEvent: MouseEvent | null = null;
    private _zoom: number = 1.0;

    // Note: Don't add a new line or empty character between <g..> and </g> tags, as it will be rendered as a text.
    override render(): TemplateResult {
        return html`
            <svg id="svg">
                <g id="transformer" transform="translate(${this._offsetX},${this._offsetY}) scale(${this._zoom})"></g>
            </svg>
            <info-component selectedElementTagName=${this._hoveredElement.element ? this._hoveredElement.element.tagName : ''}></info-component>
        `;
    };

    //@property({ attribute: "contenteditable", type: Boolean})
    //contenteditable: Boolean = true;
    
    connectedCallback(): void {
        super.connectedCallback();
        // It's important to bind the eventhandler to the window object, to avoid the need of focusing.
        window.addEventListener('contextmenu', (event) => { event.preventDefault(); });
        window.addEventListener('keydown', this._windowKeyDown.bind(this));
        window.addEventListener('mousemove', this._windowMouseMove.bind(this));
    };


    public onwheel: ((this: GlobalEventHandlers, ev: WheelEvent) => any) = (event: WheelEvent) => {
        // Prevent scrolling
        event.preventDefault();
        let tmpZoom = this._zoom + event.deltaY*0.001;

        // Limit the zoom level.
        if (tmpZoom <= 0.5) {
            this._zoom = 0.5;
        } else if (tmpZoom >= 1.5) {
            this._zoom = 1.5;
        } else {
            this._zoom = tmpZoom;
        };

        this.requestUpdate();
    };


    public onmousedown: ((this: GlobalEventHandlers, ev: MouseEvent) => any) = (event: MouseEvent) => {
        switch (event.button) {
            case 0:
                this._clickedElement = this._getElementTreeBelowCursor(event.clientX, event.clientY);
                this._previousMouseEvent = event;
                break;
        };
    };


    public onmousemove: ((this: GlobalEventHandlers, ev: MouseEvent) => any) = (event: MouseEvent) => {
        switch (event.buttons) {
            case 1:
                switch (this._clickedElement.element!.tagName) {
                    case 'EDITOR-COMPONENT':
                        this._transformRelative(event.clientX  - this._previousMouseEvent!.clientX, event.clientY - this._previousMouseEvent!.clientY);
                        break;
                    case 'CDC-TESSERA':
                        this._moveTesseraRelative(this._clickedElement.element! as any, event.clientX  - this._previousMouseEvent!.clientX, event.clientY - this._previousMouseEvent!.clientY);
                        break;
                    case 'TESSERA-OUTPUT-PORT-COMPONENT':
                        this._drawGhostConnection(this._clickedElement.element! as TesseraOutputPortComponent, event.clientX, event.clientY);
                        break;
                };

                this._previousMouseEvent = event;
                break;
        };
    };


    public onmouseup: ((this: GlobalEventHandlers, ev: MouseEvent) => any) = (event: MouseEvent) => {
        switch (event.button) {
            case 0:
                switch (this._clickedElement.element!.tagName) {
                    case 'TESSERA-OUTPUT-PORT-COMPONENT':
                        this._hoveredElement = this._getElementTreeBelowCursor(this._mousePositionX, this._mousePositionY);
                        this._clearGhostConnection();
                        
                        // this._hoveredElement.element is the line element!
                        if (this._hoveredElement.element!.tagName === 'TESSERA-INPUT-PORT-COMPONENT') {
                            this._createConnection(this._clickedElement.element! as TesseraOutputPortComponent, this._hoveredElement.element! as TesseraInputPortComponent);
                        };

                        break;
                };

                this._clickedElement = { element: null, parentElement: null };
                this._previousMouseEvent = null;
                break;
        };
    };


    private _windowMouseMove: ((this: GlobalEventHandlers, ev: MouseEvent) => any) = (event: MouseEvent) => {
        this._mousePositionX = event.clientX;
        this._mousePositionY = event.clientY;
    }


    private _windowKeyDown: ((this: GlobalEventHandlers, ev: KeyboardEvent) => any) = (event: KeyboardEvent) => {
        this._hoveredElement = this._getElementTreeBelowCursor(this._mousePositionX, this._mousePositionY);
        if (this._hoveredElement.element === null) return;

        switch (this._hoveredElement.element!.tagName) {
            case 'EDITOR-COMPONENT':
                switch (event.key) {
                    case 'ArrowUp':
                        this._transformRelative(0, 25);
                        break;
                    case 'ArrowDown':
                        this._transformRelative(0, -25);
                        break;
                    case 'ArrowLeft':
                        this._transformRelative(25, 0);
                        break;
                    case 'ArrowRight':
                        this._transformRelative(-25, 0);
                        break;
                    case 'Home':
                    case ' ':
                        this._resetView();
                        break;
                    case 'a':
                        this._addTessera(this._mousePositionX, this._mousePositionY);
                        break;
                    case 's':
                        this._saveProject();
                        break;
                    //case 'l':
                    //    this._loadProject();
                    //    break;
                };
                break;
            case 'CDC-TESSERA':
                switch (event.key) {
                    case 'd':
                        this._deleteTessera(this._hoveredElement.element as any);
                        break;
                    default:
                        (this._hoveredElement.element! as Tessera).codaicKeyDown(event);
                    break;
                };
                break;
        };
    };


    private _calculateXAbsolute(x: number): number {
        const svgRect = this._svg.getBoundingClientRect()!;

        return (x - svgRect.left - this._offsetX)/this._zoom;
    };


    private _calculateYAbsolute(y: number): number {
        const svgRect = this._svg.getBoundingClientRect()!;
        
        return (y - svgRect.top - this._offsetY)/this._zoom;
    };


    private _resetView() {
        this._offsetX = 0;
        this._offsetY = 0;
        this._zoom = 1.0;
        this.requestUpdate();
    };


    private _transformRelative(dX: number, dY: number) {
        this._offsetX += dX/this._zoom;
        this._offsetY += dY/this._zoom;
        this.requestUpdate();
    };


    private async _addTessera(x: number, y: number) {
        const result = await AddTesseraDialog.open();
        let cX: number = this._calculateXAbsolute(x);
        let cY: number = this._calculateYAbsolute(y);

        if (result === null) return;

        // Create a new tessera component and append it to the transformer.
        const tessera = new Tessera(uuidv4(), result);
        let foreignObject = document.createElementNS('http://www.w3.org/2000/svg', 'foreignObject');
        foreignObject.style.boxSizing = 'border-box';
        foreignObject.setAttribute('x', String(cX-55));
        foreignObject.setAttribute('y', String(cY-55));
        foreignObject.setAttribute('width', tessera.width);
        foreignObject.setAttribute('height', tessera.height);
        foreignObject.appendChild(tessera);
        this._transformer.appendChild(foreignObject);
        return;
    };

    
    private _moveTesseraRelative(tessera: any, dX: number, dY: number) {
        // Move the tessera component.
        const foreignObject = tessera.parentElement;
        const x = Number(foreignObject!.getAttribute('x'));
        const y = Number(foreignObject!.getAttribute('y'));
        foreignObject!.setAttribute('x', `${x + dX/this._zoom}`);
        foreignObject!.setAttribute('y', `${y + dY/this._zoom}`);
        // Move all connected lines.
        // OPTIMIZE: Do this just once during the mousedown event.
        const connectedLineArray = [].filter.call(this.shadowRoot!.querySelectorAll('line'), (e: SVGLineElement) => e.id.includes(tessera.tesseraId)) as SVGLineElement[];

        for (let i = 0; i < connectedLineArray.length; i++) {
            const line = connectedLineArray[i];

            if (line.id.startsWith(tessera.tesseraId)) {
                const x1 = Number(line.getAttribute('x1'));
                const y1 = Number(line.getAttribute('y1'));
                line.setAttribute('x1', `${x1 + dX/this._zoom}`);
                line.setAttribute('y1', `${y1 + dY/this._zoom}`);
            } else {
                const x2 = Number(line.getAttribute('x2'));
                const y2 = Number(line.getAttribute('y2'));
                line.setAttribute('x2', `${x2 + dX/this._zoom}`);
                line.setAttribute('y2', `${y2 + dY/this._zoom}`);
            };
        };
    };


    private _drawGhostConnection(tesseraOutputPortComponent: TesseraOutputPortComponent, x: number, y: number) {
        if (this._ghostConnection === null) {
            this._ghostConnection = document.createElementNS('http://www.w3.org/2000/svg', 'line');
            this._ghostConnection.style.stroke = 'black';
            this._ghostConnection.style.strokeWidth = '2';
            this._ghostConnection.setAttribute('x1', String(this._calculateXAbsolute(tesseraOutputPortComponent.cX)));
            this._ghostConnection.setAttribute('y1', String(this._calculateYAbsolute(tesseraOutputPortComponent.cY)));
            this._transformer.appendChild(this._ghostConnection);
        };

        this._ghostConnection.setAttribute('x2', String(this._calculateXAbsolute(x)));
        this._ghostConnection.setAttribute('y2', String(this._calculateYAbsolute(y)));
    };


    private _createConnection(tesseraOutputPortComponent: TesseraOutputPortComponent, tesseraInputPortComponent: TesseraInputPortComponent) {
        // Don't connect if both ports are part of the same tessera.
        if (tesseraOutputPortComponent.id.split('.')[0] === tesseraInputPortComponent.id.split('.')[0]) {
            return;
        };

        // TODO: Don't connect if the input port is already connected.
        const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
        line.style.stroke = 'blue';
        line.style.strokeWidth = '2';
        line.id = `${tesseraOutputPortComponent.id}:${tesseraInputPortComponent.id}`;
        line.setAttribute('x1', String(this._calculateXAbsolute(tesseraOutputPortComponent.cX)));
        line.setAttribute('y1', String(this._calculateYAbsolute(tesseraOutputPortComponent.cY)));
        line.setAttribute('x2', String(this._calculateXAbsolute(tesseraInputPortComponent.cX)));
        line.setAttribute('y2', String(this._calculateYAbsolute(tesseraInputPortComponent.cY)));
        this._transformer.appendChild(line);
    };


    private _clearGhostConnection() {
        this._transformer.removeChild(this._ghostConnection!);
        this._ghostConnection = null;
    };


    // TODO: Replace any with a general Tessera element.
    private _deleteTessera(tessera: any) {
        const foreignObject = tessera.parentElement;
        //// ShadowRoot again. :/ Let's dissable it.
        const connectedLineArray = [].filter.call(this.shadowRoot!.querySelectorAll('line'), (e: SVGLineElement) => e.id.includes(tessera.id));

        for (let i = 0; i < connectedLineArray.length; i++) {
            this._transformer.removeChild(connectedLineArray[i]);
        };

        this._transformer.removeChild(foreignObject!);
    };


    private _getElementTreeBelowCursor(x: number, y: number): { element: Element | null, parentElement: Element | null } {
        let myTree: Element[] = [];
        myTree.push(...this.shadowRoot!.elementsFromPoint(x, y).reverse());
        myTree = myTree.filter((e) => e.tagName.endsWith('DIALOG') ||e.tagName === 'EDITOR-COMPONENT' || e.tagName === 'CDC-TESSERA' || e.tagName === 'TESSERA-INPUT-PORT-COMPONENT' || e.tagName === 'TESSERA-OUTPUT-PORT-COMPONENT');
        return { element: myTree.pop()?? null, parentElement: myTree.pop()?? null };
    };


    private _elementsFromPoint(x: number, y: number): Element[] {
        let elementArray = [];
        const shadowRootElementArray = this.shadowRoot!.elementsFromPoint(x, y)!;
        const tessera = shadowRootElementArray.find((e) => e.tagName === 'CDC-TESSERA');
        
        if (tessera) {
            elementArray.push(tessera);
        
            let tesseraPartComponent = shadowRootElementArray.find((e) => e.tagName === 'TESSERA-INPUT-PORT-COMPONENT' || e.tagName === 'TESSERA-CORE-COMPONENT' || e.tagName === 'TESSERA-OUTPUT-PORT-COMPONENT');
            
            if (tesseraPartComponent) {
                elementArray.push(tesseraPartComponent);
            };
        };

        return elementArray;
    };


    private _saveProject(): void {
        // Serialize the graph.
        const childTesseraArray = this._transformer.childNodes;
        const foreignObjectArray = [].filter.call(childTesseraArray, (e: SVGForeignObjectElement) => e.tagName === 'foreignObject') as SVGForeignObjectElement[];
        const lineArray = [].filter.call(childTesseraArray, (e: SVGLineElement) => e.tagName === 'line') as SVGLineElement[];
        const projectObject: Array<TesseraDto> = [];
        // Create an array of tesseras.
        foreignObjectArray.forEach(foreignObject => {
            const tessera = foreignObject.childNodes[0] as Tessera;
            const tesseraDto = new TesseraDto();
            tesseraDto.tesseraId = tessera.tesseraId;
            tesseraDto.tesseraType = tessera.tesseraType;
            tesseraDto.tesseraSettingsJson = tessera.tesseraSettingsJson;
            tesseraDto.tesseraVisual = new TesseraVisual(Number.parseInt(foreignObject.getAttribute('x')!), Number.parseInt(foreignObject.getAttribute('y')!));
            projectObject.push(tesseraDto);
        });
        // Store the connections.
        lineArray.forEach(line => {
            const splittedLineId = line.id.split(':');
            const splittedLineId0 = splittedLineId[0].split('.');
            const splittedLineId1 = splittedLineId[1].split('.');
            ([].find.call(projectObject, (e: TesseraDto) => splittedLineId0[0].startsWith(e.tesseraId))! as TesseraDto)
                .outputPortArray[Number(splittedLineId0[1])] = new TesseraPort(splittedLineId1[0], Number(splittedLineId1[1]));
            ([].find.call(projectObject, (e: TesseraDto) => splittedLineId1[0].startsWith(e.tesseraId))! as TesseraDto)
                .inputPortArray[Number(splittedLineId1[1])] = new TesseraPort(splittedLineId0[0], Number(splittedLineId0[1]));
        });

        // Save the serialized graph to IndexedDB.
        IndexedDBUtil.openDatabase('editor', 1, (db) => {
            db.createObjectStore('editor');
        }).then((db) => {
            IndexedDBUtil.openObjectStore(db, 'editor', 'readwrite').then((objectStore) => {
                IndexedDBUtil.putRecord(objectStore, 'test', projectObject).then(() => {
                    console.log(projectObject);
                });
            });
        });
    };


    /*private _loadProject(): void {
        // Load the serialized graph from IndexedDB.
        IndexedDBUtil.openDatabase('editor', 1, (db) => {
            db.createObjectStore('editor');
        }).then((db) => {
            IndexedDBUtil.openObjectStore(db, 'editor', 'readwrite').then((objectStore) => {
                IndexedDBUtil.getRecord(objectStore, 'test').then((projectObject: Array<TesseraObject>) => {
                    // Deserialize the graph.
                    projectObject.forEach(tesseraObject => {
                        // Create a new tessera component and append it to the transformer.
                        switch (tesseraObject.tesseraType) {
                            //case 'merge-tessera': {
                            //    const mergeTessera = new MergeTessera();
                            //    mergeTessera.id = tesseraObject.tesseraId;
                            //    mergeTessera.x = tesseraObject.tesseraVisual.x;
                            //    mergeTessera.y = tesseraObject.tesseraVisual.y;
                            //    let foreignObject = document.createElementNS('http://www.w3.org/2000/svg', 'foreignObject');
                            //    foreignObject.style.boxSizing = 'border-box';
                            //    foreignObject.setAttribute('x', String(tesseraObject.tesseraVisual.x));
                            //    foreignObject.setAttribute('y', String(tesseraObject.tesseraVisual.y));
                            //    foreignObject.setAttribute('width', mergeTessera.width);
                            //    foreignObject.setAttribute('height', mergeTessera.height);
                            //    foreignObject.appendChild(mergeTessera);
                            //    this._transformer.appendChild(foreignObject);
                            //} break;
                            case 'script-start-tessera': {
                                const scriptStartTessera = new ScriptStartTessera();
                                scriptStartTessera.id = tesseraObject.tesseraId;
                                scriptStartTessera.x = tesseraObject.tesseraVisual.x;
                                scriptStartTessera.y = tesseraObject.tesseraVisual.y;
                                let foreignObject = document.createElementNS('http://www.w3.org/2000/svg', 'foreignObject');
                                foreignObject.style.boxSizing = 'border-box';
                                foreignObject.setAttribute('x', String(tesseraObject.tesseraVisual.x));
                                foreignObject.setAttribute('y', String(tesseraObject.tesseraVisual.y));
                                foreignObject.setAttribute('width', scriptStartTessera.width);
                                foreignObject.setAttribute('height', scriptStartTessera.height);
                                foreignObject.appendChild(scriptStartTessera);
                                this._transformer.appendChild(foreignObject);
                            } break;
                            case 'script-tessera': {
                                const scriptTessera = new ScriptTessera();
                                scriptTessera.id = tesseraObject.tesseraId;
                                scriptTessera.x = tesseraObject.tesseraVisual.x;
                                scriptTessera.y = tesseraObject.tesseraVisual.y;
                                let foreignObject = document.createElementNS('http://www.w3.org/2000/svg', 'foreignObject');
                                foreignObject.style.boxSizing = 'border-box';
                                foreignObject.setAttribute('x', String(tesseraObject.tesseraVisual.x));
                                foreignObject.setAttribute('y', String(tesseraObject.tesseraVisual.y));
                                foreignObject.setAttribute('width', scriptTessera.width);
                                foreignObject.setAttribute('height', scriptTessera.height);
                                foreignObject.appendChild(scriptTessera);
                                this._transformer.appendChild(foreignObject);
                            } break;
                            case 'log-tessera': {
                                const logTessera = new LogTessera();
                                logTessera.id = tesseraObject.tesseraId;
                                logTessera.x = tesseraObject.tesseraVisual.x;
                                logTessera.y = tesseraObject.tesseraVisual.y;
                                let foreignObject = document.createElementNS('http://www.w3.org/2000/svg', 'foreignObject');
                                foreignObject.style.boxSizing = 'border-box';
                                foreignObject.setAttribute('x', String(tesseraObject.tesseraVisual.x));
                                foreignObject.setAttribute('y', String(tesseraObject.tesseraVisual.y));
                                foreignObject.setAttribute('width', logTessera.width);
                                foreignObject.setAttribute('height', logTessera.height);
                                foreignObject.appendChild(logTessera);
                                this._transformer.appendChild(foreignObject);
                            } break;
                            case 'light-tessera': {
                                const lightTessera = new LightTessera();
                                lightTessera.id = tesseraObject.tesseraId;
                                lightTessera.x = tesseraObject.tesseraVisual.x;
                                lightTessera.y = tesseraObject.tesseraVisual.y;
                                let foreignObject = document.createElementNS('http://www.w3.org/2000/svg', 'foreignObject');
                                foreignObject.style.boxSizing = 'border-box';
                                foreignObject.setAttribute('x', String(tesseraObject.tesseraVisual.x));
                                foreignObject.setAttribute('y', String(tesseraObject.tesseraVisual.y));
                                foreignObject.setAttribute('width', lightTessera.width);
                                foreignObject.setAttribute('height', lightTessera.height);
                                foreignObject.appendChild(lightTessera);
                                this._transformer.appendChild(foreignObject);
                            } break;
                        };

                        // Create the connections.
                        //tesseraObject.outputPortArray.forEach((outputPortArray, outputPortIndex) => {
                        //    outputPortArray.forEach(outputPortId => {
                        //        const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
                        //        line.style.stroke = 'blue';
                        //        line.style.strokeWidth = '2';
                        //        line.id = `${tesseraObject.id}.${outputPortIndex}:${outputPortId}`;
                        //        line.setAttribute('x1', String((this._transformer.querySelector(`#${outputPortId}`) as TesseraOutputPortComponent).cX));
                        //        line.setAttribute('y1', String((this._transformer.querySelector(`#${outputPortId}`) as TesseraOutputPortComponent).cY));
                        //        line.setAttribute('x2', String((this._transformer.querySelector(`#${inputPortId}`) as TesseraInputPortComponent).cX));
                        //        line.setAttribute('y2', String((this._transformer.querySelector(`#${inputPortId}`) as TesseraInputPortComponent).cY));
                        //        this._transformer.appendChild(line);
                        //    });
                        //});
                    });
                });
            });
        });
    };*/
};
