import UIKit
import SnapKit
import TK

class ProfileViewController: UIViewController {
    let backgroundView = UIImageView()
    let imageView = UIImageView()
    let descriptionLabel = UILabel()
    let companyLabel = UILabel()
    
    var message: Message? {
        didSet {
            update()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blackColor()
        
        companyLabel.textColor = .redColor() //.tk_color(0x6CFF52)
        companyLabel.font = UIFont.boldSystemFontOfSize(12)
        companyLabel.text = "Company"
        
        view.addSubview(companyLabel)
        
        backgroundView.image = UIImage(named: "background")
        backgroundView.contentMode = .ScaleAspectFill
        view.addSubview(backgroundView)
        view.addSubview(imageView)
        
        descriptionLabel.textColor = .whiteColor()
        descriptionLabel.font = UIFont.boldSystemFontOfSize(14)
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .Center
        view.addSubview(descriptionLabel)
        
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .blackColor()
        imageView.snp_makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(200)
            make.centerX.equalTo(view)
            make.top.equalTo(snp_topLayoutGuideBottom).offset(15)
        }
        
        backgroundView.snp_makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        companyLabel.snp_makeConstraints { make in
            make.top.equalTo(imageView.snp_bottom).offset(20)
            make.left.equalTo(view).offset(10)
            make.right.equalTo(view).offset(-10)
        }
        
        descriptionLabel.snp_makeConstraints { make in
            make.top.equalTo(companyLabel.snp_bottom).offset(10)
            make.left.equalTo(view).offset(10)
            make.right.equalTo(view).offset(-10)
        }
    }
    
    func update() {
        if let message = message {
            self.title = message.text
            self.descriptionLabel.text = message.description
            imageView.sd_setImageWithURL(message.profileURL)
        }
    }
}
