import Foundation
import ObjectMapper

class Basket: Mappable {
    var messages: [Message]?
    var options: [Option]?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        messages <- map["messages"]
        options <- map["options"]
    }
}
