import { EditorView, minimalSetup } from 'codemirror';
import { CSSResult, LitElement, css, html } from 'lit';
import { customElement } from 'lit/decorators.js';
import { Ref, ref, createRef } from 'lit/directives/ref.js';
import { highlightActiveLineGutter, lineNumbers } from '@codemirror/view'
import { EditorState } from '@codemirror/state'
import { javascript } from '@codemirror/lang-javascript'


@customElement('editor-dialog')
export class EditorDialog extends LitElement {
    static override styles: CSSResult = css`
    :host {
        z-index: 999;
        position: absolute;
        top: 0;
        left: 0;
        width: 100dvw;
        height: 100dvh;
        background-color: rgba(0, 0, 0, 0.5);
        backdrop-filter: blur(2px);
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
    }

    :host > main {
        max-width: 760px;
        width: calc(100% - 40px);
        height: calc(100% - 40px);
        display: flex;
        flex-direction: column;
        background-color: var(--background-day);
    }

    :host > main > header {
        width: 100%;
        flex: 0 0 auto;
        display: flex;
        flex-direction: row;
        justify-content: space-between;
        align-items: center;
    }

    :host > main > div {
        width: 100%;
        flex: 1 1 auto;
    }
    `;


    private _editorRef: Ref<HTMLElement> = createRef();
    private _editor: EditorView = new EditorView();
    private _initialContent: string = '';


    // Hide the constructor as the dialog will be shown via the open function.
    private constructor(initialContent: string) {
        super();
        this._initialContent = initialContent;
    };


    static async open(content: string): Promise<string> {
        const dialog = new EditorDialog(content);
        document.body.appendChild(dialog);

        return new Promise((resolve) => {
            dialog.addEventListener('close', (event: Event) => {
                resolve((event as CustomEvent).detail);
                dialog.remove();
            }, { once: true });
        });
    };


    private _close() {
        this.dispatchEvent(new CustomEvent('close', { detail: this._editor.state.doc.toString() }));
    };


    firstUpdated() {
        const fixedHeightEditor = EditorView.theme({
            "&": {height: "100%"},
            ".cm-scroller": {overflow: "auto"}
        });

        this._editor = new EditorView({
            doc: this._initialContent,
            extensions: [
                fixedHeightEditor,
                highlightActiveLineGutter(),
                javascript(),
                lineNumbers(),
                minimalSetup,
            ],
            parent: this._editorRef.value!,
        });
    }


    override render() {
        return html`
            <main>
                <header>
                    <h1>Editor</h1>
                    <button @click=${() => this._close()}>Close</button>
                </header>
                <div ${ref(this._editorRef)} id="editor"></div>
            </main>
        `;
    };
};
