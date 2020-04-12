import Foundation

class ImageModel: ImageModelProtocol {
    
    private(set) var imageURL: URL
    private(set) var label: String?
    
    init(imageURL: URL, label: String?) {
        self.imageURL = imageURL
        self.label = label
    }
    
}
