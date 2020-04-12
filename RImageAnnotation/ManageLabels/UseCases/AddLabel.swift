import Foundation

class AddLabel {
    
    private let session: ImageAnnotatingSessionProtocol
    
    init(imageAnnotatingSession: ImageAnnotatingSessionProtocol) {
        session = imageAnnotatingSession
    }
    
}

extension AddLabel: AddLabelProtocol {
    
    func add(label: String) {
        session.add(label: label)
    }
    
}
