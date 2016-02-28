import Foundation
import ObjectMapper

class Message: Mappable {
    enum MessageType {
        case Other, Text, Profile, Event, Typing
    }
    
    var isMe = false
    var id: String?
    var type: MessageType?
    var text: String?
    var avatarURL: NSURL?
    
    var profileURL: NSURL?
    var location: Location?
    
    init() {
        
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        type <- (map["type"], MessageTypeTransform())
        text <- map["text"]
        if text == nil {
            text <- map["Text"]
        }
        avatarURL <- (map["avatar_url"], URLTransform())
        profileURL <- (map["profile_url"], URLTransform())
        location <- map["location"]
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
            case "Typing":
                return .Typing
            case "Event":
                return .Event
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
            case .Event:
                return "Event"
            default:
                return "Typing"
            }
        }
        return nil
    }
}