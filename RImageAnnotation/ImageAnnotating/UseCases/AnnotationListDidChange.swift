import Foundation

class AnnotationListDidChange: AnnotationListDidChangeProtocol {
    
    private let session: ImageAnnotatingSessionProtocol
    private let imageModelBuilder: ImageModelBuilder
    
    public weak var output: AnnotationListDidChangeOutput!
    
    init(imageAnnotatingSession: ImageAnnotatingSessionProtocol, imageModelBuilder: ImageModelBuilder) {
        session = imageAnnotatingSession
        self.imageModelBuilder = imageModelBuilder
        session.add(observer: self)
    }
    
    deinit {
        session.remove(observer: self)
    }
    
}

extension AnnotationListDidChange: SessionObserver {
    
    func sessionDidAdd(label: String) { }
    
    func sessionDidRemove(label: String) { }
    
    func sessionDidAdd(annotation: AnnotationModel) {
        output.annotationDidChange(forImage: imageModelBuilder.create(imageURLs: [annotation.imageURL]).first!)
    }
    
    func sessionDidRemove(annotation: AnnotationModel) {
        output.annotationDidChange(forImage: imageModelBuilder.create(imageURLs: [annotation.imageURL]).first!)
    }
    
}
