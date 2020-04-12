import Cocoa

class ImageTitleTableCellView: NSTableCellView {
    
    @IBOutlet weak var label: NSTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if layer == nil {
            layer = CALayer()
        }
    }
    
    func configure(imageModel: ImageModelProtocol) {
        textField?.stringValue = imageModel.imageURL.lastPathComponent
        textField?.toolTip = imageModel.imageURL.absoluteString
        
        layer?.backgroundColor = imageModel.label != nil ? NSColor.green.cgColor : NSColor.red.cgColor
        
        label.stringValue = imageModel.label ?? "?"
    }
    
}
