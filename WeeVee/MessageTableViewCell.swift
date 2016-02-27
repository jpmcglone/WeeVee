import UIKit
import SnapKit
import TK

class MessageTableViewCell: BubbleTableViewCell {
    let messageLabel = UILabel()
    let profileImageView = UIImageView()
    var hasImage = false {
        didSet {
            updateImageViewConstraints()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        messageLabel.textColor = .whiteColor()
        messageLabel.numberOfLines = 0
        
        profileImageView.backgroundColor = UIColor(white: 1, alpha: 0.1)
        contentView.addSubview(messageLabel)
        contentView.addSubview(profileImageView)
    }
    
    func updateImageViewConstraints() {
        messageLabel.snp_makeConstraints { make in
            if !hasImage {
                make.edges.equalTo(bubble).inset(innerMargin)
            } else {
                make.top.left.right.equalTo(bubble).inset(innerMargin)
            }
        }
        
        profileImageView.snp_remakeConstraints { make in
            make.left.equalTo(messageLabel)
            
            if !hasImage {
                make.height.equalTo(0)
                make.width.equalTo(0)
                make.bottom.equalTo(bubble)
            } else {
                make.right.equalTo(bubble).inset(innerMargin)
                make.top.equalTo(messageLabel.snp_bottom)
                let maxHeight: CGFloat = 200
                make.height.equalTo(maxHeight)
                if let image = profileImageView.image where image.size.height > 0 {
                    let ratio = maxHeight / image.size.height
                    let width = image.size.width * ratio
                    make.width.equalTo(width)
                }
                make.bottom.equalTo(bubble).inset(innerMargin)
            }
        }
    }
    
    override func update() {
        super.update()
        messageLabel.textColor = isMe ? .tk_color(0x565656) : .whiteColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
