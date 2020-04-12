import XCTest

class LabelListTests: XCTestCase {

    var session: ImageAnnotatingSession!
    var labelList: LabelList!
    
    override func setUpWithError() throws {
        session = ImageAnnotatingSession()
        labelList = LabelList(imageAnnotatingSession: session)
    }
    
    func test_returnEmptyList_whenSessionIsEmpty() {
        XCTAssertEqual([], labelList.labelList())
    }
    
    func test_fetchList_whenCallLabelList() {
        let list = ["A", "b", "X"]
        list.forEach( session.add(label:) )
        
        XCTAssertEqual(list, labelList.labelList())
    }

}
