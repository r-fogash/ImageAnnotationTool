import Cocoa

class LabelLlistTextCell: NSTableCellView {
    
    func setText(_ text: String) {
        textField?.stringValue = text
    }
    
}
