import UIKit
import Alamofire
import ObjectMapper
import TK
import SnapKit
import SDWebImage

class AgentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, OptionsViewDelegate {
    let tableView = UITableView()
    
    let manager = Alamofire.Manager()
    let baseURLString = "http://weevee.herokuapp.com/api"
    
    var messages = [Message]()
    var typing = false {
        didSet {
            tableView.reloadData()
        }
    }
    
    var backgroundView: UIView!
    var imageView: UIImageView!
    var blurView: UIVisualEffectView!
    
    var optionsView = OptionsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionsView.delegate = self
        
        view.addSubview(tableView)

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
        
        view.addSubview(optionsView)

        updateOptionsViewConstraints()
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
    
    func fetch(basketJSON: AnyObject?) {
        typing = true
        NSTimer.tk_scheduledTimer(1) {
            if let basket = Mapper<Basket>().map(basketJSON) {
                if let basketMessages = basket.messages {
                    self.typing = true
                    self.loadMessages(basketMessages) {
                        NSTimer.tk_scheduledTimer(0.5) {
                            self.setOptions(basket.options!)
                        }
                    }
                } else {
                    self.typing = false
                }
            } else {
                self.typing = false
            }
        }
    }
    
    func loadMessages(var messages: [Message], completion: ()->()) {
        let message = messages.removeFirst()
        self.messages.append(message)
        tableView.reloadData()
        
        if messages.count == 0 {
            typing = false
            tableView.reloadData()
            completion()
        } else {
            NSTimer.tk_scheduledTimer(1) {
                self.loadMessages(messages, completion: completion)
            }
        }
    }
    
    // MARK: -
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if typing && indexPath.row == messages.count {
            let cell = tableView.dequeueReusableCellWithIdentifier("typing", forIndexPath: indexPath) as! TypingTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("message", forIndexPath: indexPath) as! MessageTableViewCell
            cell.profileImageView.sd_cancelCurrentImageLoad()
            
            let message = messages[indexPath.row]
            
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
                cell.profileImageView.sd_setImageWithURL(url)
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count + (typing ? 1 : 0)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
    
    func updateOptionsViewConstraints() {
        tableView.snp_remakeConstraints { make in
            if self.optionsView.options == nil {
                make.edges.equalTo(view)
            } else {
                make.top.left.right.equalTo(view)
                make.bottom.equalTo(optionsView.snp_top)
            }
        }
        
        optionsView.snp_remakeConstraints { make in
            if self.optionsView.options == nil {
                make.height.equalTo(0)
            } else {
                make.height.equalTo(80)
            }
            make.bottom.equalTo(view)
            make.width.equalTo(view)
            make.top.greaterThanOrEqualTo(0)
        }
    }
    
    func setOptions(options: [Option]?) {
        optionsView.options = options
        updateOptionsViewConstraints()
    }
    
    // Mark: - 
    func optionsView(optionsView: OptionsView, didSelectOption option: Option) {
        print(option.text)
        // make and add fake message
        let message = Message()
        message.text = option.text
        message.isMe = true
        messages.append(message)
        tableView.reloadData()
        
        setOptions(nil)
        fetch(uri: option.uri!)
    }
}