import UIKit
import SnapKit

class MessageTableViewCell: UITableViewCell {
    let bubble = UIView()
    let messageLabel = UILabel()
    let margin: CGFloat = 10
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clearColor()
        
        selectionStyle = .None
        
        // TODO chat bubble thing w/ UIImageView
        bubble.backgroundColor = UIColor(white: 1, alpha: 1)
        bubble.layer.cornerRadius = 7
        bubble.layer.masksToBounds = true
        
        messageLabel.text = "Testing text is lasijdl kasjd laksjd lakjsdl kajsdl kjasldk jalskdj lakjs d alskdj laksjd laksjdl kjalskjd laksjd lkajsdl kjasldkj alkjsd asd"
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .grayColor()
        
        contentView.addSubview(bubble)
        contentView.addSubview(messageLabel)
        
        bubble.snp_makeConstraints { make in
            make.top.equalTo(contentView).offset(margin)
            make.left.equalTo(contentView).offset(margin)
            make.right.equalTo(contentView).offset(-margin)
            make.bottom.equalTo(contentView).offset(-margin)
        }
        
        messageLabel.snp_makeConstraints { make in
            make.edges.equalTo(bubble).inset(margin)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
