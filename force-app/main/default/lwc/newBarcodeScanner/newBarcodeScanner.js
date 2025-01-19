import { LightningElement, track, api } from 'lwc';

export default class NewBarcodeScanner extends LightningElement {
    @track barcodeList = []; 

    @api
    get barcodeCollection() {
        return this.barcodeList.join(','); 
    }

    get barcodeCount() {
        return this.barcodeList.length; 
    }

    get lastScannedSerial(){
        return this.barcodeList.slice(-1);
    }

    handleClick(event){
        alert(this.barcodeList.join('\n'));
    }

    handleBarcodeInput(event) {
        
        if (event.key === 'Enter') {
            let scannedValue = event.target.value.trim();
            
            
            if (scannedValue.length === 8 && !this.barcodeList.includes(scannedValue)) {
                this.barcodeList = [...this.barcodeList, scannedValue];
                console.log('Added to barcodeList:', this.barcodeList);
            }


            
            event.target.value = '';
            this.template.querySelector('[data-barcode-input]').focus();
        }
    }

    renderedCallback() {
        const inputField = this.template.querySelector('[data-barcode-input]');
        if (inputField) {
            inputField.focus();
        }
    }
}