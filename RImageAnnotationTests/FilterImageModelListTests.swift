import XCTest

class FilterImageModelListTests: XCTestCase {

    let filterBuilder = ImageModelListFilterBuilder()
    var list: [ImageModelProtocol]!
    var filteredImageModelList: [ImageModelProtocol]!
    
    override func setUpWithError() throws {
        list = [createImageModel(isTagged: false), createImageModel(isTagged: true), createImageModel(isTagged: false)]
    }
    
    func test_filterAll() {
        let filter = filterBuilder.createAllImageFilter(output: self)
        filter.filter(imageModelList: [])
        XCTAssertEqual(0, filteredImageModelList.count)
        
        filter.filter(imageModelList: list)
        XCTAssertEqual(list.map{ $0.imageURL }, filteredImageModelList.map{$0.imageURL})
    }
    
    func test_filterMarked() {
        let filter = filterBuilder.createMarkedImageFilter(output: self)
        filter.filter(imageModelList:[])
        XCTAssertEqual(0, filteredImageModelList.count)
        
        filter.filter(imageModelList: list)
        XCTAssertEqual([list[1]].map{$0.imageURL}, filteredImageModelList.map{$0.imageURL})
    }
    
    func test_filterNotMarked() {
        let filter = filterBuilder.createNotMarkedImageFilter(output: self)
        filter.filter(imageModelList:[])
        XCTAssertEqual(0, filteredImageModelList.count)
        
        filter.filter(imageModelList: list)
        XCTAssertEqual([list[0], list[2]].map{$0.imageURL}, filteredImageModelList.map{$0.imageURL})
    }

}

extension FilterImageModelListTests: ImageModelListFilterOutput {
    
    func didFilter(imageModelList: [ImageModelProtocol]) {
        filteredImageModelList = imageModelList
    }
    
}
