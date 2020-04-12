import Foundation

class FetchSelectionForImage {
    
    private let session: ImageAnnotatingSessionProtocol
    
    init(imageAnnotatingSession: ImageAnnotatingSessionProtocol) {
        session = imageAnnotatingSession
    }
    
}

extension FetchSelectionForImage: FetchSelectionForImageProtocol {
    
    func selectionRectInImageCoordinatesFor(imageURL: URL) -> NSRect? {
        let annotation = session.annotationList.first{ $0.imageURL == imageURL }
        var selectionRect: NSRect?
        if let mlCoordinates = annotation?.coordinates {
            selectionRect = CoordinateTransform.appKitRectangleFrom(mlRectangle: mlCoordinates)
        }
        return selectionRect
    }
    
}
