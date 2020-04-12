import Cocoa

public struct AppleMLCoordinates: Codable, Equatable {

    var x: Int! /* center.x of the selected rectangle */
    var y: Int! /* center.y of the selected rectangle */
    var width: Int!
    var height: Int!
    
}
