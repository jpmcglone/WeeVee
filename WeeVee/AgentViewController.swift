import UIKit
import Alamofire
import ObjectMapper

class AgentViewController: UITableViewController {
    
    let manager = Alamofire.Manager()
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAlamofire()
        view.backgroundColor = .darkGrayColor()
        
        tableView.separatorStyle = .None
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerClass(MessageTableViewCell.self, forCellReuseIdentifier: "cell")
        
        // load sample json
        let basketJSON = loadJSON("sample")?["data"]
        if let basket = Mapper<Basket>().map(basketJSON) {
            loadBasket(basket) { basket, error in
                
            }
        }
    }
    
    func loadBasket(basket: Basket, completion:(basket: Basket, error: NSError) -> ()) {
        // TODO: one message at a time 
        if let basketMessages = basket.messages {
            for message in basketMessages {
                messages.append(message)
            }
            tableView.reloadData()
        }
    }
    
    func configureAlamofire() {
        
    }
    
    // MARK: -
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MessageTableViewCell
        let message = messages[indexPath.row]
        cell.messageLabel.text = message.value as? String
        return cell
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