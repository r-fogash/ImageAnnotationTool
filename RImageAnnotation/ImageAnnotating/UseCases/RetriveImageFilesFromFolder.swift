import Foundation


class RetriveImageFilesFromFolder {
    
}

extension RetriveImageFilesFromFolder: RetriveImageFilesFromFolderProtocol {

    public func imageFiles(folder: URL) -> [URL] {
        guard let enumerator = FileManager().enumerator(atPath: folder.path) else {
            return []
        }
        
        var imageURLs = [URL]()
        
        while let fileName = enumerator.nextObject() as? String {
            let fileURL = folder.appendingPathComponent(fileName)
            
            if allowedImageExtensions().contains(fileURL.pathExtension.uppercased()) {
                imageURLs.append(fileURL)
            }
        }
        return imageURLs
    }
    
}

extension RetriveImageFilesFromFolder {
    
    private func allowedImageExtensions() -> Set<String> {
        return ["PNG", "JPG", "JPEG"]
    }
    
}
