import Foundation

class LabelList {
    
    private let session: ImageAnnotatingSessionProtocol!
    
    init(imageAnnotatingSession: ImageAnnotatingSessionProtocol) {
        session = imageAnnotatingSession
    }
}

extension LabelList: LabelListProtocol {
    
    func labelList() -> [String] {
        return session.labelList
    }
    
}
