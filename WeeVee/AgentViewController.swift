import UIKit
import Alamofire
import ObjectMapper
import TK

class AgentViewController: UITableViewController {
    let manager = Alamofire.Manager()
    var messages = [Message]()
    var typing = false {
        didSet {
            tableView.reloadData()
        }
    }
    
    var backgroundView: UIView!
    var imageView: UIImageView!
    var blurView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(tableView)
        
        backgroundView = UIView(frame: view.bounds)
        backgroundView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        tableView.backgroundView = backgroundView
        
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
        
        configureAlamofire()
        view.backgroundColor = .darkGrayColor()
        
        tableView.separatorStyle = .None
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerClass(MessageTableViewCell.self, forCellReuseIdentifier: "message")
        tableView.registerClass(TypingTableViewCell.self, forCellReuseIdentifier: "typing")

        // load sample json
        let basketJSON = loadJSON("sample")?["data"]
        typing = true
        
        NSTimer.tk_scheduledTimer(1) {
            if let basket = Mapper<Basket>().map(basketJSON) {
                self.loadBasket(basket) { basket, error in
                    if let basketMessages = basket.messages {
                        self.typing = true
                        self.loadMessages(basketMessages)
                    } else {
                        self.typing = false
                    }
                }
            } else {
                self.typing = false
            }
        }
    }
    
    func loadBasket(basket: Basket, completion:(basket: Basket, error: NSError?) -> ()) {
        // TODO: alamofire
        completion(basket: basket, error: nil)
    }
    
    func configureAlamofire() {
        
    }
    
    func loadMessages(var messages: [Message]) {
        if messages.count == 0 {
            return
        }
        
        let message = messages.removeFirst()
        self.messages.append(message)
        tableView.reloadData()
        
        if messages.count == 0 {
            typing = false
            tableView.reloadData()
        } else {
            NSTimer.tk_scheduledTimer(1) {
                self.loadMessages(messages)
            }
        }
    }
    
    // MARK: -
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if typing && indexPath.row == messages.count {
            let cell = tableView.dequeueReusableCellWithIdentifier("typing", forIndexPath: indexPath) as! TypingTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("message", forIndexPath: indexPath) as! MessageTableViewCell
            let message = messages[indexPath.row]
            cell.messageLabel.text = message.value as? String
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count + (typing ? 1 : 0)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // Don't add .json to fileName
    func loadJSON(fileName: String) -> NSDictionary? {
        if let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers) as? NSDictionary
                return jsonResult
            } catch {
                // TODO
            }
        }
        return nil
    }
}