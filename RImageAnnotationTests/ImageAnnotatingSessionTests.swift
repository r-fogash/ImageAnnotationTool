import XCTest
@testable import ImageMarkTool

class ImageAnnotatingSessionTests: XCTestCase {

    var session: ImageAnnotatingSession!
    
    // Observer
    // Idea: use just one event / method for labels
    var numberOfSessionDidAddAnnotationCalls = 0
    var numberOfSessionDidRemoveAnnotationCalls = 0
    var numberOfSessionDidAddLabelCalls = 0
    var numberOfSessionDidRemoveLabelCalls = 0
    
    override func setUpWithError() throws {
        session = ImageAnnotatingSession()
    }
    
}

// MARK: - Labels

extension ImageAnnotatingSessionTests {
    
    func test_labelListEmpty_onCreate() {
        XCTAssertEqual([], session.labelList)
    }
    
    func test_callLabelObserver_whenAddLabel() {
        let label = NSUUID().uuidString
        session.add(observer: self)
        session.add(label: label)
        
        XCTAssertEqual(1, numberOfSessionDidAddLabelCalls)
        
        session.remove(label: label)
        XCTAssertEqual(1, numberOfSessionDidRemoveLabelCalls)
    }
    
    func test_doNotCallLabelObserver_whenRemoveNotExistingLabel() {
        let label = NSUUID().uuidString
        
        session.add(observer: self)
        session.remove(label: label)
        
        XCTAssertEqual(0, numberOfSessionDidAddLabelCalls)
        XCTAssertEqual(0, numberOfSessionDidRemoveLabelCalls)
    }
    
    func test_canRemoveObserver() {
        let label = NSUUID().uuidString
        
        session.add(observer: self)
        session.remove(observer: self)
        session.add(label: label)
        
        XCTAssertEqual(0, numberOfSessionDidAddLabelCalls)
    }
    
    func test_keepLabel_whenAddLabel() {
        let label = NSUUID().uuidString
        
        session.add(label: label)
        
        XCTAssertTrue(session.labelList.contains(label))
    }
    
    func test_removeLabel_whenCallRemoveLabel() {
        let label = NSUUID().uuidString
        
        session.add(label: label)
        session.remove(label: label)
        
        XCTAssertEqual([], session.labelList)
    }
    
    func test_isLabelListEmpty() {
        let label = NSUUID().uuidString
        
        session.add(label: label)
        XCTAssertFalse(session.isLabelListEmpty())
        
        session.remove(label: label)
        XCTAssertTrue(session.isLabelListEmpty())
    }
}

// MARK: -Annotations

extension ImageAnnotatingSessionTests {
    
    func test_annotationListEmpty_onCreate() {
        XCTAssertEqual([], session.annotationList)
    }
    
    func test_keepAnnotation_whenAddAnnotation() {
        let annotation = createAnnotation()
        
        session.add(annotation: annotation)
        
        XCTAssertEqual([annotation], session.annotationList)
    }
    
    func test_removeAnnotation_whenCallRemoveAnnotation() {
        let annotation = createAnnotation()
        
        session.add(annotation: annotation)
        
        XCTAssertEqual([annotation], session.annotationList)
    }
    
    func test_notifyObservers_whenAddAndRemoveAnnotation() {
        let annotation = createAnnotation()
        session.add(observer: self)
        session.add(annotation: annotation)
        
        XCTAssertEqual(1, numberOfSessionDidAddAnnotationCalls)
        
        session.removeAnnotation(imageURL: annotation.imageURL)
        XCTAssertEqual(1, numberOfSessionDidRemoveAnnotationCalls)
    }
    
    func test_doNotCallObserver_whenRemovedAnnotationNotInList() {
        session.add(observer: self)
        session.add(annotation: createAnnotation())
        session.removeAnnotation(imageURL: createAnnotation().imageURL)
        
        XCTAssertEqual(0, numberOfSessionDidRemoveAnnotationCalls)
    }
    
    func test_clearAnnotation_removeAllAnnotation() {
        session.add(annotation: createAnnotation())
        session.add(annotation: createAnnotation())
        
        session.clearAnnotations()
        
        XCTAssertEqual([], session.annotationList)
    }
    
}

extension ImageAnnotatingSessionTests: SessionObserver {
    
    func sessionDidAdd(annotation: AnnotationModel) {
        numberOfSessionDidAddAnnotationCalls += 1
    }
    
    func sessionDidRemove(annotation: AnnotationModel) {
        numberOfSessionDidRemoveAnnotationCalls += 1
    }
    
    func sessionDidAdd(label: String) {
        numberOfSessionDidAddLabelCalls += 1
    }
    
    func sessionDidRemove(label: String) {
        numberOfSessionDidRemoveLabelCalls += 1
    }
    
}
