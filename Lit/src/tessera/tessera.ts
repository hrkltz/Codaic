import { CSSResult, LitElement, css, html } from 'lit';
import { customElement } from 'lit/decorators.js';
import { EditorDialog } from '../dialog/editor_dialog';


@customElement('cdc-tessera')
export class Tessera extends LitElement {
    static override styles: CSSResult = css`
        cdc-tessera {
            display: flex;
            flex-direction: row;
            width: 100%;
            height: 100%;
            box-sizing: border-box;
        }

        cdc-tessera > div.input-container,
        cdc-tessera > div.output-container {
            height: 100%;
            box-sizing: border-box;
            flex: 0 0 20px;
        }

        cdc-tessera > tessera-core-component {
            height: 100%;
            flex: 1 1 auto;
            background-color: #fff;
            box-sizing: border-box;
            border: 1px solid grey;
        }

        cdc-tessera > div.input-container > tessera-input-port-component,
        cdc-tessera > div.output-container > tessera-output-port-component {
            height: 20px;
            width: 100%;
            box-sizing: border-box;
        }
    `;


    public tesseraId: string = '';
    public tesseraType: string = '';
    // These two are just needed as counter for Tessera.
    public inputPortArray: Array<null> = [];
    public outputPortArray: Array<null> = [];
    public tesseraSettingsJson: string = '';
    public get width(): string {
        return '80px';
    }
    public get height(): string {
        return '60px';
    }


    constructor(tesseraId: string, tesseraType: string) {
        super();
        this.tesseraId = tesseraId;
        this.tesseraType = tesseraType;

        switch (this.tesseraType) {
            case 'ScriptStartTessera':
                this.outputPortArray = [null];
                this.tesseraSettingsJson = JSON.stringify({
                    code: 'console.log("Hello, World!")',
                });
                break;
            case 'ScriptTessera':
                this.inputPortArray = [null];
                this.outputPortArray = [null];
                this.tesseraSettingsJson = JSON.stringify({
                    code: 'console.log("Hello, World!")',
                });
                break;
            case 'LogTessera':
                this.inputPortArray = [null];
                this.outputPortArray = [null];
                break;
            case 'LightTessera':
                this.outputPortArray = [null];
                break;
        };
    }

    
    public codaicKeyDown(event: KeyboardEvent) {
        switch (event.key) {
            case 'e':
                switch (this.tesseraType) {
                    case 'ScriptStartTessera':
                    case 'ScriptTessera':
                        EditorDialog.open(JSON.parse(this.tesseraSettingsJson).code).then((result) => {
                            this.tesseraSettingsJson = JSON.stringify({
                                code: result,
                            });
                        });
                        break;
                }
                break;
        }
    }


    override render() {
        return html`
            <div class="input-container">
                ${this.inputPortArray.map((_, index) =>
                    html`<tessera-input-port-component id="${this.tesseraId}.${index}">${index}</tessera-input-port-component>`
                )}
            </div>
            <tessera-core-component></tessera-core-component>
            <div class="output-container">
                ${this.outputPortArray.map((_, index) =>
                    html`<tessera-output-port-component id="${this.tesseraId}.${index}">${index}</tessera-output-port-component>`
                )}
            </div>
        `;
    };


    // Disable shadow DOM for this element.
    protected createRenderRoot() {
        return this;
    };
};
