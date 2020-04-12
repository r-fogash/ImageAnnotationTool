import XCTest
@testable import ImageMarkTool

class FetchSelectionForImageTests: XCTestCase {

    var session: ImageAnnotatingSession!
    var fetchSelection: FetchSelectionForImage!
    
    override func setUpWithError() throws {
        session = ImageAnnotatingSession()
        fetchSelection = FetchSelectionForImage(imageAnnotatingSession: session)
    }
    
    func test_returnNil_whenNoSelection() {
        XCTAssertNil(fetchSelection.selectionRectInImageCoordinatesFor(imageURL: createRandomURL()))
    }
    
    func test_returnSelection() {
        session.add(annotation: createRandomAnnotation())
        let annotation = createRandomAnnotation()
        session.add(annotation: annotation)
        
        XCTAssertEqual(CoordinateTransform.appKitRectangleFrom(mlRectangle: annotation.coordinates), fetchSelection.selectionRectInImageCoordinatesFor(imageURL: annotation.imageURL))
    }

}
