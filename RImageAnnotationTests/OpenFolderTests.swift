import XCTest
@testable import ImageMarkTool

class OpenFolderTests: XCTestCase {
    
    var session: ImageAnnotatingSessionProtocol!
    var retriveImagesFromFolderStub: RetriveImagesFromFolderStub!
    var imageModelBuilder: ImageModelBuilder!
    var openFolder: OpenFolder!

    override func setUpWithError() throws {
        
        retriveImagesFromFolderStub = RetriveImagesFromFolderStub()
        session = ImageAnnotatingSession()
        openFolder = OpenFolder(imageAnnotatingSession: session, retriveImagesInFolder: retriveImagesFromFolderStub, imageModelBuilder: ImageModelBuilder(imageAnnotatingSession: session))
        
    }
    
    func test_emptyList_whenOpenEmptyFolder() {
        let modelList = openFolder.openFolder(url: createRandomURL())
        XCTAssertTrue(modelList.isEmpty)
    }
    
    func test_returnAllImages_whenOpenFolder() {
        let imageURLs = [createRandomURL(), createRandomURL()]
        retriveImagesFromFolderStub.urls = imageURLs
        
        let modelList = openFolder.openFolder(url: createRandomURL())
        XCTAssertEqual(imageURLs, modelList.map{ $0.imageURL })
    }
    
    func test_clearAnnotation_whenOpenFolder() {
        session.add(annotation: AnnotationModel(label: "A", imageURL: createRandomURL(), boundingBox: AppleMLCoordinates(x: 0, y: 0, width: 0, height: 0)))
        XCTAssertFalse(session.annotationList.isEmpty)
        
        let _ = openFolder.openFolder(url: createRandomURL())
        XCTAssertTrue(session.annotationList.isEmpty)
    }

}

class RetriveImagesFromFolderStub: RetriveImageFilesFromFolderProtocol {
    
    public var urls = [URL]()
    
    var numberOfIMageFilesCalls = 0
    
    func imageFiles(folder: URL) -> [URL] {
        numberOfIMageFilesCalls += 1
        return urls
    }
    
}
