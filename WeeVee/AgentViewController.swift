import UIKit
import Alamofire
import ObjectMapper
import TK
import SnapKit
import SDWebImage

class AgentViewController: UITableViewController, OptionsViewDelegate {
    let manager = Alamofire.Manager()
    let baseURLString = "http://weevee.herokuapp.com/api"
    
    var messages = [Message]()
    var typing = false
    
    var backgroundView: UIView!
    var imageView: UIImageView!
    var blurView: UIVisualEffectView!
    
    var optionsView = OptionsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionsView.delegate = self
    
        tableView.delegate = self
        tableView.dataSource = self
        
        backgroundView = UIView(frame: view.bounds)
        tableView.backgroundView = backgroundView
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)
        
        imageView = UIImageView(frame: backgroundView.bounds)
        imageView.image = UIImage(named: "background")
        imageView.contentMode = .ScaleAspectFill
        imageView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        backgroundView.addSubview(imageView)
        
        let blurEffect = UIBlurEffect(style: .Dark)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = backgroundView.bounds
        blurView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        backgroundView.addSubview(blurView)
        
        self.title = "WeeVee"
        
        view.backgroundColor = .darkGrayColor()
        
        tableView.separatorStyle = .None
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerClass(MessageTableViewCell.self, forCellReuseIdentifier: "message")
        tableView.registerClass(TypingTableViewCell.self, forCellReuseIdentifier: "typing")

        // load sample json
        fetch(uri: "baskets")
    }
    
    func fetch(uri uri: String) {
        let url = "\(baseURLString)/\(uri)"
        
        manager.request(.GET, url, parameters: nil).responseJSON { response in
            switch response.result {
            case .Success(let data):
                let json = data as! [String : AnyObject]
                self.fetch(json["data"])
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func typingMessage() -> Message {
        let message = Message()
        message.type = .Typing
        return message
    }
    
    func addMessage(message: Message, atIndex index: Int) {
        messages.insert(message, atIndex: index)
        tableView.reloadData()
    }
    
    func fetch(basketJSON: AnyObject?) {
        addMessage(typingMessage(), atIndex: messages.count)

        NSTimer.tk_scheduledTimer(1) {
            if let basket = Mapper<Basket>().map(basketJSON) {
                if let basketMessages = basket.messages {
                    self.loadMessages(basketMessages) {
                    self.setOptions(basket.options!)
                    }
                }
            }
        }
    }
    
    func loadMessages(var messages: [Message], completion: ()->()) {
        let message = messages.removeFirst()
        
        let index = self.messages.count-1
        self.addMessage(message, atIndex: index)

        if messages.count == 0 {
            let index = self.messages.count-1
            self.messages.removeAtIndex(index)
            completion()
        } else {
            NSTimer.tk_scheduledTimer(1) {
                self.loadMessages(messages, completion: completion)
            }
        }
        
        tableView.reloadData()
    }
    
    // MARK: -
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        if message.type == .Typing {
            let cell = tableView.dequeueReusableCellWithIdentifier("typing", forIndexPath: indexPath) as! TypingTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("message", forIndexPath: indexPath) as! MessageTableViewCell
            cell.profileImageView.sd_cancelCurrentImageLoad()
            
            if let type = message.type where type != .Other{
                switch type {
                case .Profile:
                    cell.messageLabel.font = UIFont.boldSystemFontOfSize(10)
                default:
                    cell.messageLabel.font = UIFont.systemFontOfSize(18)
                }
            } else {
                cell.messageLabel.font = UIFont.systemFontOfSize(18)
            }
            
            cell.isMe = message.isMe
            
            if let url = message.profileURL {
                cell.profileImageView.sd_setImageWithURL(url, completed: { image, error, _, _ in
                    cell.updateImageConstraints()
                })
                cell.hasImage = true
            } else {
                cell.profileImageView.image = nil
                cell.hasImage = false
            }
            cell.messageLabel.text = message.text
            cell.updateImageConstraints()
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 80
    }

    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return optionsView
    }
    
    // Don't add .json to fileName
    func loadJSON(fileName: String) -> [String : AnyObject]? {
        if let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers) as? [String : AnyObject]
                return jsonResult
            } catch {
                // TODO
            }
        }
        return nil
    }
    
    func setOptions(options: [Option]?) {
        optionsView.options = options
    }
    
    // Mark: - 
    func optionsView(optionsView: OptionsView, didSelectOption option: Option) {
        print(option.text)
        // make and add fake message
        let message = Message()
        message.text = option.text
        message.isMe = true
        
        addMessage(message, atIndex: messages.count)
        
        setOptions(nil)
        fetch(uri: option.uri!)
    }
}