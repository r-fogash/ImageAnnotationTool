import Foundation

class ApplySelectionToImage {
    
    private let session: ImageAnnotatingSessionProtocol
    
    init(imageAnnotatingSession: ImageAnnotatingSessionProtocol) {
        session = imageAnnotatingSession
    }
    
}

extension ApplySelectionToImage: ApplySelectionToImageProtocol {
    
    func applySelection(inImageCoordinates coordinates: NSRect, to imageURL: URL, label: String) {
        let mlCoordinate = CoordinateTransform.appleMLCoordinatesFrom(appKitFrame: coordinates)
        let annotation = AnnotationModel(label: label, imageURL: imageURL, boundingBox: mlCoordinate)
        
        session.removeAnnotation(imageURL: imageURL)
        session.add(annotation: annotation)
    }
    
}
