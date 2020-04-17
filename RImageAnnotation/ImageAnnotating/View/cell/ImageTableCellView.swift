import Cocoa

class ImageTableCellView: NSTableCellView {

    @IBOutlet var previewImageView: NSImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        previewImageView.imageScaling = .scaleProportionallyUpOrDown
        if layer == nil {
            layer = CALayer()
        }
    }
    
    public func configure(imageModel: ImageModelProtocol) {
        previewImageView.image = NSImage(contentsOfFile: imageModel.imageURL.path)
        layer?.backgroundColor = (imageModel.label != nil ? NSColor(named: "processedColor") : NSColor(named: "notProcessedColor"))!.cgColor
    }
}
