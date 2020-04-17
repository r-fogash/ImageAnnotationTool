import XCTest
@testable import RImageAnnotation

class ClearSelectionTests: XCTestCase {

    var session: ImageAnnotatingSession!
    var clearSelection: ClearSelection!
    
    override func setUpWithError() throws {
        session = ImageAnnotatingSession()
        clearSelection = ClearSelection(imageAnnotatingSession: session)
    }

    func test_clearSelection_removeAnnotation() {
        let annotation = createRandomAnnotation()
        session.add(annotation: annotation)
        
        clearSelection.clearSelection(imageURL: annotation.imageURL)
        XCTAssertEqual([], session.annotationList)
    }
    
    func test_clearSelection_removeTheRightAnnotation() {
        session.add(annotation: createRandomAnnotation())
        let annotation = createRandomAnnotation()
        
        clearSelection.clearSelection(imageURL: annotation.imageURL)
        XCTAssertEqual(1, session.annotationList.count)
    }

}
