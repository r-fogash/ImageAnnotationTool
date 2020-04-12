import XCTest
@testable import ImageMarkTool

class RemoveLabelTests: XCTestCase {

    var session: ImageAnnotatingSession!
    var removeLabel: RemoveLabel!
    
    override func setUpWithError() throws {
        session = ImageAnnotatingSession()
        removeLabel = RemoveLabel(imageAnnotatingSession: session)
    }

    func test_labelListNotChange_whenRemoveLabelNotInList() {
        removeLabel.remove(label: "A")
        XCTAssertEqual([], session.labelList)
        
        let list = ["a", "B"]
        list.forEach( session.add(label:) )
        removeLabel.remove(label: "C")
        
        XCTAssertEqual(list, session.labelList)
    }
    
    func test_removeLabelFromList_whenCallRemoveLabel() {
        let list = ["a", "B"]
        list.forEach( session.add(label:) )
        
        removeLabel.remove(label: list.first!)
        
        XCTAssertEqual(Array<String>(list.dropFirst()), session.labelList)
    }

}
