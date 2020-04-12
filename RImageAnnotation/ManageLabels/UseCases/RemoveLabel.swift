import Foundation

class RemoveLabel {
    
    private let session: ImageAnnotatingSessionProtocol
    
    init(imageAnnotatingSession: ImageAnnotatingSessionProtocol) {
        session = imageAnnotatingSession
    }
    
}

extension RemoveLabel: RemoveLabelProtocol {
    
    func remove(label: String) {
        session.remove(label: label)
    }
    
}
