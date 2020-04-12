import Cocoa

struct AnnotationModel: Codable, Equatable {

    var label: String!
    var type: String!
    var coordinates: AppleMLCoordinates!
    var imageURL: URL!
    
    init(label: String, imageURL: URL, boundingBox: AppleMLCoordinates) {
        self.label = label
        self.type = "rectangle"
        self.coordinates = boundingBox
        self.imageURL = imageURL
    }
    
}
