import Foundation

class WriteAnnotationToFile {
    
    private let serialiser: AnnotationListSerialisationProtocol
    private let session: ImageAnnotatingSessionProtocol
    
    init(serialiser: AnnotationListSerialisationProtocol, imageAnnotatingSession: ImageAnnotatingSessionProtocol) {
        self.serialiser = serialiser
        self.session = imageAnnotatingSession
    }
    
}

extension WriteAnnotationToFile: DataWritterProtocol {
    
    func writeAnnotations(to fileURL: URL, completion: @escaping FinishBlock) {
        let data = serialiser.serialize(annotationList: session.annotationList)
        
        var error: Error?
        
        do { try data.write(to: fileURL) }
        catch let e { error = e }
        
        completion(error == nil, error)
    }
    
}
