import Foundation
import ObjectMapper

class Option: Mappable {
    enum OptionType {
        case
        Other,
        Profile, // Who
        Event, // What
        Location, // Where
        Calendar, // When
        Philosophy, // Why
        Instruction // How
    }
    
    var text: String?
    var type: OptionType? = .Other
    var uri: String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        text <- map["text"]
        type <- (map["type"], OptionTransform())
        uri <- map["uri"]
    }
}

class OptionTransform: TransformType {
    typealias Object = Option.OptionType
    typealias JSON = String
    
    init() {}
    
    // TOOD: better enum?
    func transformFromJSON(value: AnyObject?) -> Option.OptionType? {
        if let type = value as? String {
            switch type {
            case "Profile":
                return .Profile
            case "Event":
                return .Event
            case "Location":
                return .Location
            case "Calendar":
                return .Calendar
            case "Philosophy":
                return .Philosophy
            case "Instruction":
                return .Instruction
            default:
                return .Other
            }
        }
        return nil
    }
    
    func transformToJSON(value: Option.OptionType?) -> String? {
        if let messageType = value {
            switch messageType {
            case .Profile:
                return "Profile"
            case .Event:
                return "Event"
            case .Location:
                return "Location"
            case .Calendar:
                return "Calendar"
            case .Philosophy:
                return "Philosophy"
            case .Instruction:
                return "Instruction"
            default:
                return nil
            }
        }
        return nil
    }
}