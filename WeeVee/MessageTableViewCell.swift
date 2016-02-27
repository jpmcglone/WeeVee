import UIKit
import SnapKit

class MessageTableViewCell: UITableViewCell {
    let messageLabel = UILabel()
    let margin: CGFloat = 20
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        messageLabel.text = "Testing text is lasijdl kasjd laksjd lakjsdl kajsdl kjasldk jalskdj lakjs d alskdj laksjd laksjdl kjalskjd laksjd lkajsdl kjasldkj alkjsd asd"
        messageLabel.numberOfLines = 0
        messageLabel.backgroundColor = .greenColor()
        
        contentView.addSubview(messageLabel)
    
        messageLabel.snp_makeConstraints { make in
            make.top.equalTo(contentView).offset(margin)
            make.left.equalTo(contentView).offset(margin)
            make.right.equalTo(contentView).offset(-margin)
            make.bottom.equalTo(contentView).offset(-margin)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
