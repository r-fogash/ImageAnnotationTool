import Foundation

class AnnotationListJSONSerialisation: AnnotationListSerialisationProtocol {
    
    func serialize(annotationList: [AnnotationModel]) -> Data {
        return try! JSONEncoder().encode(annotationList)
    }
}
