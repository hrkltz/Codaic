export class TesseraDto {
    public inputPortArray: Array<TesseraPort | null> = [];
    public outputPortArray: Array<TesseraPort | null> = [];
    public tesseraId: string = '';
    public tesseraSettingsJson: string = '';
    public tesseraType: string = '';
    public tesseraVisual: TesseraVisual = new TesseraVisual(0, 0);
};


export class TesseraPort {
    portIndex: Number = 0;
    tesseraId: string = '';


    constructor(tesseraId: string, portIndex: Number) {
        this.portIndex = portIndex;
        this.tesseraId = tesseraId;
    }
}


export class TesseraVisual {
    x: number = 0;
    y: number = 0;


    constructor(x: number, y: number) {
        this.x = x;
        this.y = y;
    }
}