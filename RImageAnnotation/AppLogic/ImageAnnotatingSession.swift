import Cocoa


protocol SessionObserver: class {
    
    func sessionDidAdd(label: String)
    func sessionDidRemove(label: String)
    func sessionDidAdd(annotation: AnnotationModel)
    func sessionDidRemove(annotation: AnnotationModel)
}


protocol ImageAnnotatingSessionProtocol {
    
    var annotationList: [AnnotationModel] {get}
    var labelList: Array<String> {get}
    
    func add(label: String)
    func remove(label: String)
    func add(observer: SessionObserver)
    func remove(observer: SessionObserver!)
    func clearAnnotations()
    func isLabelListEmpty() -> Bool
    func removeAnnotation(imageURL: URL)
    func add(annotation: AnnotationModel)
    
}

class ImageAnnotatingSession: ImageAnnotatingSessionProtocol {
    
    private class WeakSessionObserver {
        weak private(set) var object: SessionObserver?
        init(_ observer: SessionObserver) {
            object = observer
        }
    }
    
    private var observerList = [WeakSessionObserver]()
    
    public var labelList = [String]()
    public var annotationList = [AnnotationModel]()
    
    func add(label: String) {
        labelList.append(label)
        observerList.forEach { $0.object?.sessionDidAdd(label: label) }
    }
    
    func remove(label: String) {
        guard labelList.contains(label) else {
            return
        }
        labelList.removeAll { $0 == label }
        observerList.forEach { $0.object?.sessionDidRemove(label: label) }
    }

//MARK: - Work with observers

    public func add(observer: SessionObserver) {
        observerList.append(WeakSessionObserver(observer))
    }
    
    public func remove(observer: SessionObserver!) {
        observerList.removeAll { $0.object === observer }
    }
    
    func clearAnnotations() {
        annotationList.removeAll()
    }
    
    func isLabelListEmpty() -> Bool {
        return labelList.isEmpty
    }
    
    func removeAnnotation(imageURL: URL) {
        if let index = (annotationList.firstIndex { $0.imageURL == imageURL })
        {
            let annotation = annotationList[index]
            annotationList.remove(at: index)
            observerList.forEach{ $0.object?.sessionDidRemove(annotation: annotation) }
        }
    }
    
    func add(annotation: AnnotationModel) {
        annotationList.append(annotation)
        observerList.forEach{ $0.object?.sessionDidAdd(annotation: annotation) }
    }
}
