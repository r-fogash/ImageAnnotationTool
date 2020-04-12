import XCTest
@testable import ImageMarkTool

class AnnotationListDidChangeTests: XCTestCase {

    var session: ImageAnnotatingSession!
    var numberOfAnnotationDidChangeCalls = 0
    var imageModel: ImageModelProtocol?
    
    override func setUpWithError() throws {
        session = ImageAnnotatingSession()
    }

    func test_addSelfAsObserver_onCreate() {
        let sessionSpy = ImageAnnotatingSessionSpy()
        var annotationList: AnnotationListDidChange? = AnnotationListDidChange(imageAnnotatingSession: sessionSpy, imageModelBuilder: ImageModelBuilder(imageAnnotatingSession: sessionSpy))
        
        XCTAssertEqual(1, sessionSpy.numberOfAddObserverCalls)
        
        annotationList = nil
        XCTAssertEqual(1, sessionSpy.numberOfRemoveObserverCalls)
    }
    
    func test_callOutput_whenAddOrRemoveAnnotation() {
        let sessionSpy = ImageAnnotatingSessionSpy()
        let annotationList = AnnotationListDidChange(imageAnnotatingSession: sessionSpy, imageModelBuilder: ImageModelBuilder(imageAnnotatingSession: sessionSpy))
        annotationList.output = self
        let annotation = createRandomAnnotation()
        
        annotationList.sessionDidAdd(annotation: annotation)
        XCTAssertEqual(1, numberOfAnnotationDidChangeCalls)
        
        annotationList.sessionDidRemove(annotation: annotation)
        XCTAssertEqual(2, numberOfAnnotationDidChangeCalls)
    }

}

extension AnnotationListDidChangeTests: AnnotationListDidChangeOutput {
    
    func annotationDidChange(forImage: ImageModelProtocol) {
        numberOfAnnotationDidChangeCalls += 1
        imageModel = forImage
    }
    
}

class ImageAnnotatingSessionSpy: ImageAnnotatingSessionProtocol {
    
    public var numberOfAddObserverCalls = 0
    public var numberOfRemoveObserverCalls = 0
    public var numberOfClearAnnotationCalls = 0
    public var numberOfRemoveAnnotationImageURLCalls = 0
    
    var annotationList: [AnnotationModel] = []
    var labelList = Array<String>()
    
    func add(label: String) {
        
    }
    
    func remove(label: String) {
        
    }
    
    func add(observer: SessionObserver) {
        numberOfAddObserverCalls += 1
    }
    
    func remove(observer: SessionObserver!) {
        numberOfRemoveObserverCalls += 1
    }
    
    func clearAnnotations() {
        numberOfClearAnnotationCalls += 1
    }
    
    func isLabelListEmpty() -> Bool {
        return false
    }
    
    func removeAnnotation(imageURL: URL) {
        numberOfRemoveAnnotationImageURLCalls += 1
    }
    
    func add(annotation: AnnotationModel) {
        
    }
    
}
