import XCTest
@testable import RImageAnnotation

class RetriveImageFilesFromFolderTests: XCTestCase {

    var emptyFolderURL: URL!
    var imageFolderURL: URL!
    var imagesInFolder: [URL]!
    
    override func setUpWithError() throws {
        emptyFolderURL = tmpDirectoryURL().appendingPathComponent("EmptyFolder")
        try createFolder(url: emptyFolderURL)
        
        imageFolderURL = tmpDirectoryURL().appendingPathComponent("ImageFolder")
        try createFolder(url: imageFolderURL)
        imagesInFolder = try copy(files: imageURLs(), to: imageFolderURL)
        let _ = try copy(files: otherFileURLs(), to: imageFolderURL)
    }

    override func tearDownWithError() throws {
        try deleteFolder(url: emptyFolderURL)
        try deleteFolder(url: imageFolderURL)
    }

    func test_noImageFilesInEmptyFolder() throws {
        let imageListFromFolder = RetriveImageFilesFromFolder()
        let imageFileList = imageListFromFolder.imageFiles(folder: emptyFolderURL)
        
        XCTAssertEqual([], imageFileList)
    }
    
    func test_retriveOnly_PNG_or_JPG_ImageFilesInFolder() throws {
        let imageListFromFolder = RetriveImageFilesFromFolder()
        let imageFileList = imageListFromFolder.imageFiles(folder: imageFolderURL)

        XCTAssertEqual(2, imageFileList.count)
    }
    
    func test_returnEmptyList_whenAddressInvalid() {
        let imageListFromFolder = RetriveImageFilesFromFolder()
        XCTAssertEqual([], imageListFromFolder.imageFiles(folder: createRandomURL()))
    }

}

extension RetriveImageFilesFromFolderTests {
    
    func createFolder(url: URL) throws {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
    }
    
    func deleteFolder(url: URL) throws {
        try FileManager.default.removeItem(at: url)
    }
    
    func tmpDirectoryURL() -> URL {
        return URL(fileURLWithPath: NSTemporaryDirectory())
    }
    
    func imageURLs() -> [URL] {
        let bundle = Bundle(for: type(of: self))
        return [
            bundle.url(forResource: "ccat.png", withExtension: nil)!,
            bundle.url(forResource: "s.jpg", withExtension: nil)!
        ]
    }
    
    func otherFileURLs() -> [URL] {
        let bundle = Bundle(for: type(of: self))
        return [
            bundle.url(forResource: "people.txt", withExtension: nil)!
        ]
    }
    
    func copy(files: [URL], to: URL) throws -> [URL] {
        return try files.map {
            let fileName = $0.lastPathComponent
            let newFileURL = to.appendingPathComponent(fileName)
            try FileManager.default.copyItem(at: $0, to: newFileURL)
            return newFileURL
        }
    }
    
}
