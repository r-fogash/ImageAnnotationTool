import Foundation

class LabelListDidChange: LabelListDidChangeProtocol {
    
    private let session: ImageAnnotatingSessionProtocol
    public weak var output: LabelListDidChangeOutput!
    
    init(imageAnnotatingSession: ImageAnnotatingSessionProtocol) {
        session = imageAnnotatingSession
        session.add(observer: self)
    }
    
    deinit {
        session.remove(observer: self)
    }
    
}

extension LabelListDidChange: SessionObserver {
    
    func sessionDidAdd(label: String) {
        output.labelListDidChange(newList: session.labelList)
    }
    
    func sessionDidRemove(label: String) {
        output.labelListDidChange(newList: session.labelList)
    }
    
    func sessionDidAdd(annotation: AnnotationModel) { }
    
    func sessionDidRemove(annotation: AnnotationModel) { }
    
}
