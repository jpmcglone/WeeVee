import Foundation
import ObjectMapper

class Profile: Mappable {
    var text: String?
    var company: String?
    var profileUrl: NSURL?
    var description: String?
    var shortDescription: String?
    
    init() {
        
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        text <- map["text"]
        company <- map["company"]
        profileUrl <- (map["profile_url"], URLTransform())
        description <- map["description"]
    }
}