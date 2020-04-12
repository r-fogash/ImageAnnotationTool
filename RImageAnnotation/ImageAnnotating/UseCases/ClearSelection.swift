import Foundation


class ClearSelection {
    
    private let session: ImageAnnotatingSessionProtocol
    
    init(imageAnnotatingSession: ImageAnnotatingSessionProtocol) {
        session = imageAnnotatingSession
    }
    
}

extension ClearSelection: ClearSelectionProtocol {
    
    func clearSelection(imageURL: URL) {
        session.removeAnnotation(imageURL: imageURL)
    }
    
}
