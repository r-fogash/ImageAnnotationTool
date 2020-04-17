import AppKit

protocol CoordinateTransformProtocol {
    
    func convertToContainerCoordinates(selectionInImageCoordinates: NSRect, containerFrame: NSRect, image: URL) -> NSRect?
    func convertToImageCoordinates(selectionInContainerCoordinates: NSRect, containerFrame: NSRect, image: URL) -> NSRect?
    static func appKitRectangleFrom(mlRectangle: AppleMLCoordinates) -> NSRect
    static func appleMLCoordinatesFrom(appKitFrame: NSRect) -> AppleMLCoordinates
}

class CoordinateTransform: CoordinateTransformProtocol {
    
    func convertToContainerCoordinates(selectionInImageCoordinates: NSRect, containerFrame: NSRect, image: URL) -> NSRect? {
        let scale = self.imageScale(url: image, containerFrame: containerFrame)
        let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)

        guard let renderedImageFrame = self.renderedImageFrame(url: image, containerFrame: containerFrame) else {
            return nil
        }
        let offsetX = containerFrame.minX + renderedImageFrame.minX
        let offsetY = containerFrame.minY + renderedImageFrame.minY
        let translateTransform = CGAffineTransform(translationX: offsetX, y: offsetY)

        return selectionInImageCoordinates.applying(scaleTransform).applying(translateTransform)
    }
    
    func convertToImageCoordinates(selectionInContainerCoordinates: NSRect, containerFrame: NSRect, image: URL) -> NSRect? {
        guard let renderedImageFrame = renderedImageFrame(url: image, containerFrame: containerFrame) else {
            return nil
        }
        let translateTransform = CGAffineTransform(translationX: -(renderedImageFrame.minX + containerFrame.minX), y: -(renderedImageFrame.minY + containerFrame.minY))
        let scaleFactor = 1.0/imageScale(url: image, containerFrame: containerFrame)
        let scaleTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        
        return selectionInContainerCoordinates.applying(translateTransform).applying(scaleTransform)
    }
    
    static func appKitRectangleFrom(mlRectangle: AppleMLCoordinates) -> NSRect {
        return NSRect(x: mlRectangle.x - mlRectangle.width / 2,
                      y: mlRectangle.y - mlRectangle.height / 2,
                      width: mlRectangle.width,
                      height: mlRectangle.height)
    }
    
    static func appleMLCoordinatesFrom(appKitFrame: NSRect) -> AppleMLCoordinates {
        var coordinates = AppleMLCoordinates()
        coordinates.x = Int(appKitFrame.midX)
        coordinates.width = Int(appKitFrame.width)
        coordinates.y = Int(appKitFrame.midY)
        coordinates.height = Int(appKitFrame.height)
        return coordinates
    }
    
}

extension CoordinateTransform {
    
    private func renderedImageFrame(url: URL, containerFrame: NSRect) -> CGRect? {
        guard let imageRep = NSImageRep(contentsOf: url) else { return nil }

        let s = imageScale(url: url, containerFrame: containerFrame)
        
        let scaleTransform = CGAffineTransform(scaleX: s, y: s)
        let scalledSelectionFrame = NSRect(origin: CGPoint.zero, size: imageRep.size).applying(scaleTransform)
        
        let originX = (containerFrame.width - scalledSelectionFrame.width) / 2.0
        let originY = (containerFrame.height - scalledSelectionFrame.height) / 2.0
        
        return CGRect(origin: CGPoint(x: originX, y: originY), size: scalledSelectionFrame.size)
    }
    
    private func imageScale(url: URL, containerFrame: NSRect) -> CGFloat {
       guard let imageRep = NSImageRep(contentsOf: url) else {
           return -1
       }
       return fmin(containerFrame.width / CGFloat(imageRep.pixelsWide), containerFrame.height / CGFloat(imageRep.pixelsHigh))
   }
    
}
