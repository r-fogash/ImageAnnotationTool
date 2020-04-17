import XCTest
@testable import RImageAnnotation

class ImageInfoBuilderTests: XCTestCase {

    var session: ImageAnnotatingSession!
    var imageModelBuilder: ImageModelBuilder!
    
    override func setUpWithError() throws {
        session = ImageAnnotatingSession()
        imageModelBuilder = ImageModelBuilder(imageAnnotatingSession: session)
    }
    
    func test_createImageInfo_isNotProcesses_ifNoAnnotationInSession() {
        session.add(annotation: createAnnotation())
        let annotation = createAnnotation()
        let imageModel = imageModelBuilder.create(imageURLs: [annotation.imageURL]).first!
        
        XCTAssertNil(imageModel.label)
    }
    
    func test_createImageInfo_isProcessed_whenAnnotationAddedToSession() {
        let annotation = createAnnotation()
        session.add(annotation: annotation)
        
        let imageModel = imageModelBuilder.create(imageURLs: [annotation.imageURL]).first!
        
        XCTAssertNotNil(imageModel.label)
    }

}
