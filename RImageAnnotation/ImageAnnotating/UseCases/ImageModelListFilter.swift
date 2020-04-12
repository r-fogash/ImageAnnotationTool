import Foundation

class ImageModelListFilterAll: ImageModelListFilterProtocol {
    
    weak var output: ImageModelListFilterOutput!
    
    func filter(imageModelList: [ImageModelProtocol]) {
        output.didFilter(imageModelList: imageModelList)
    }
    
}

class ImageModelListFilterMarked: ImageModelListFilterProtocol {
    
    weak var output: ImageModelListFilterOutput!
    
    func filter(imageModelList: [ImageModelProtocol]) {
        output.didFilter(imageModelList: imageModelList.filter{ $0.label != nil })
    }
    
}

class ImageModelListFilterNotmarked: ImageModelListFilterProtocol {
    
    weak var output: ImageModelListFilterOutput!
    
    func filter(imageModelList: [ImageModelProtocol]) {
        output.didFilter(imageModelList: imageModelList.filter{ $0.label == nil })
    }
    
}

class ImageModelListFilterBuilder: ImageModelListFilterBuilderProtocol {
    
    func createAllImageFilter(output: ImageModelListFilterOutput) -> ImageModelListFilterProtocol {
        let filter = ImageModelListFilterAll()
        filter.output = output
        return filter
    }
    
    func createMarkedImageFilter(output: ImageModelListFilterOutput) -> ImageModelListFilterProtocol {
        let filter = ImageModelListFilterMarked()
        filter.output = output
        return filter
    }
    
    func createNotMarkedImageFilter(output: ImageModelListFilterOutput) -> ImageModelListFilterProtocol {
        let filter = ImageModelListFilterNotmarked()
        filter.output = output
        return filter
    }
    
}
