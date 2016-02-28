import Foundation
import ObjectMapper

class Location: Mappable {
    var latitude: Double?
    var longitude: Double?
    var address: String?
    var text: String?
    
    init() {
        
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        latitude <- map["latitude"]
        if latitude == nil {
            latitude <- map["latitiude"]
        }
        longitude <- map["longitude"]
        address <- map["address"]
        text <- map["text"]
    }
}
