import Foundation
import ObjectMapper

class Message: Mappable {
    enum MessageType {
        case Other, Text, Profile
    }
    
    var isMe = false
    var id: String?
    var type: MessageType?
    var text: String?
    var avatarURL: NSURL?
    
    var profileURL: NSURL?
    
    init() {
        
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        type <- (map["type"], MessageTypeTransform())
        text <- map["text"]
        avatarURL <- (map["avatar_url"], URLTransform())
        profileURL <- (map["profile_url"], URLTransform())
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
            case "Profile":
                return .Profile
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
            case .Profile:
                return "Profile"
            }
        }
        return nil
    }
}