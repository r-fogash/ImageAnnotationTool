import XCTest
@testable import RImageAnnotation

class ApplySelectionToImageTests: XCTestCase {

    var applySelectionToImage: ApplySelectionToImage!
    var session: ImageAnnotatingSession!
    
    override func setUpWithError() throws {
        session = ImageAnnotatingSession()
        applySelectionToImage = ApplySelectionToImage(imageAnnotatingSession: session)
    }

    func test_applySelection() {
        let coordinates = NSRect.zero
        let url = createRandomURL()
        let label = UUID().uuidString
        
        applySelectionToImage.applySelection(inImageCoordinates: coordinates, to: url, label: label)
        XCTAssertEqual(1, session.annotationList.count)
        XCTAssertEqual(url, session.annotationList.first!.imageURL)
        XCTAssertEqual(label, session.annotationList.first!.label)
    }
    
    func test_replaceOldAnnotation_whenAddAnnotation() {
        let coordinates = NSRect.zero
        let url = createRandomURL()
        var label = UUID().uuidString
        
        applySelectionToImage.applySelection(inImageCoordinates: coordinates, to: url, label: label)
        
        label = UUID().uuidString
        applySelectionToImage.applySelection(inImageCoordinates: coordinates, to: url, label: label)
        XCTAssertEqual(label, session.annotationList.first!.label)
    }

}
