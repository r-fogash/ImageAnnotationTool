import XCTest

extension XCTestCase {
    
    func createAnnotation() -> AnnotationModel {
        let mlCoordinates = AppleMLCoordinates(x: randomInt(max:100), y: randomInt(max:100), width: randomInt(max:100), height: randomInt(max:100))
        return AnnotationModel(label: NSUUID().uuidString, imageURL: createRandomURL(), boundingBox: mlCoordinates)
    }
    
    func createImageModel() -> ImageModel {
        return ImageModel(imageURL: createRandomURL(), label: nil)
    }
    
    func createImageModel(isTagged: Bool) -> ImageModel {
        return ImageModel(imageURL: createRandomURL(), label: isTagged ? "A" : nil)
    }
    
    func createRandomURL() -> URL {
        URL(string: "https://abc.com/\(UUID().uuidString)")!
    }
    
    func createRandomAnnotation() -> AnnotationModel {
        return AnnotationModel(label: UUID().uuidString, imageURL: createRandomURL(), boundingBox: AppleMLCoordinates(x: randomInt(max:100), y: randomInt(max:100), width: randomInt(max:100), height: randomInt(max:100)))
    }
    
    func randomFloat(max: UInt32) -> CGFloat {
        return CGFloat(arc4random() % max)
    }
    
    func randomInt(max: UInt32) -> Int {
        return Int(arc4random() % max)
    }
    
}
