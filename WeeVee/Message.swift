import Foundation
import ObjectMapper

class Message: Mappable {
    enum MessageType {
        case Text, Other
    }
    
    var id: String?
    var type: MessageType?
    var value: AnyObject?
    var avatarURL: NSURL?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        type <- (map["type"], MessageTypeTransform())
        value <- map["value"]
        avatarURL <- (map["avatar_url"], URLTransform())
    }
}

class MessageTypeTransform: TransformType {
    typealias Object = Message.MessageType
    typealias JSON = String
    
    init() {}
    
    func transformFromJSON(value: AnyObject?) -> Message.MessageType? {
        if let type = value as? String {
            switch type {
            case "Text":
                return .Text
            default:
                return .Other
            }
        }
        return nil
    }
    
    func transformToJSON(value: Message.MessageType?) -> String? {
        if let messageType = value {
            switch messageType {
            case .Text:
                return "Text"
            case .Other:
                return "Other"
            }
        }
        return nil
    }
}