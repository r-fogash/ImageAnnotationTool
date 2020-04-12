import Foundation

class ImageModelBuilder {
    
    private let session: ImageAnnotatingSessionProtocol
    
    init(imageAnnotatingSession: ImageAnnotatingSessionProtocol) {
        session = imageAnnotatingSession
    }
    
    public func create(imageURLs: [URL]) -> [ImageModelProtocol] {
        return imageURLs.map { url in
            let label = self.session.annotationList.filter{ $0.imageURL == url }.first?.label
            return ImageModel(imageURL: url, label: label)
        }
        
        
    }
    
}
