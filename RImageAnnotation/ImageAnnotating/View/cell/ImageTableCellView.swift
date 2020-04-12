import Cocoa

class ImageTableCellView: NSTableCellView {

    @IBOutlet var previewImageView: NSImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        previewImageView.imageScaling = .scaleProportionallyUpOrDown
    }
    
    public func configure(imageURL: URL) {
        previewImageView.image = NSImage(contentsOfFile: imageURL.path)
    }
}
