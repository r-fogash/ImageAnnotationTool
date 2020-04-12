import XCTest
@testable import ImageMarkTool

class AddLabelTests: XCTestCase {

    var session: ImageAnnotatingSession!
    var addLabel: AddLabel!
    
    override func setUpWithError() throws {
        session = ImageAnnotatingSession()
        addLabel = AddLabel(imageAnnotatingSession: session)
    }
    
    func test_addLabelToSession_whenCallAddLabel() {
        addLabel.add(label: "A")
        XCTAssertEqual(["A"], session.labelList)
    }

}
