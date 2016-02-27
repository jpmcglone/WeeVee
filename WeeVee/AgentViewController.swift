import UIKit
import Alamofire
import ObjectMapper

class AgentViewController: UITableViewController {
    
    let manager = Alamofire.Manager()
    let basket = [Basket]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAlamofire()
        view.backgroundColor = .darkGrayColor()
        
        tableView.separatorStyle = .None
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerClass(MessageTableViewCell.self, forCellReuseIdentifier: "cell")
        
        // load sample json
        let basketJSON = loadJSON("sample")?["data"]
        let basket = Mapper<Basket>().map(basketJSON)
        
    }
    
    func configureAlamofire() {
        
    }
    
    // MARK: -
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MessageTableViewCell
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
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