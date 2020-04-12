import Foundation

class OpenFolder {
    
    private let session: ImageAnnotatingSessionProtocol
    private let imagesInFolder: RetriveImageFilesFromFolderProtocol!
    private let imageModelBuilder: ImageModelBuilder!
    
    init(imageAnnotatingSession: ImageAnnotatingSessionProtocol, retriveImagesInFolder: RetriveImageFilesFromFolderProtocol, imageModelBuilder: ImageModelBuilder) {
        session = imageAnnotatingSession
        imagesInFolder = retriveImagesInFolder
        self.imageModelBuilder = imageModelBuilder
    }
    
}

extension OpenFolder: OpenFolderProtocol {
    
    func openFolder(url: URL) -> [ImageModelProtocol] {
        session.clearAnnotations()
        let imageURLs = imagesInFolder.imageFiles(folder: url)
        return self.imageModelBuilder.create(imageURLs: imageURLs)
    }
    
}
