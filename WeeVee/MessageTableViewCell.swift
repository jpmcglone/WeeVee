import UIKit
import SnapKit
import TK

class MessageTableViewCell: BubbleTableViewCell {
    let messageLabel = UILabel()
    let profileImageView = UIImageView()
    var hasImage = false {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        messageLabel.textColor = .whiteColor()
        messageLabel.numberOfLines = 0
        
        profileImageView.backgroundColor = UIColor(white: 1, alpha: 0.1)
        contentView.addSubview(messageLabel)
        contentView.addSubview(profileImageView)
        
        messageLabel.snp_makeConstraints { make in
            make.edges.equalTo(bubble).inset(innerMargin)
        }

        profileImageView.snp_makeConstraints { make in
            make.left.equalTo(messageLabel)
            make.height.equalTo(50)
            make.width.equalTo(0)
            make.bottom.equalTo(bubble)
        }
    }
    
    func updateImageConstraints() {
        messageLabel.snp_remakeConstraints { make in
            if hasImage {
                make.top.left.equalTo(bubble).inset(innerMargin)
                make.right.greaterThanOrEqualTo(bubble).inset(innerMargin)
                make.bottom.equalTo(profileImageView.snp_top)
            } else {
                make.edges.equalTo(bubble).inset(innerMargin)
            }
        }
        
        profileImageView.snp_remakeConstraints { make in
            make.left.equalTo(bubble).inset(innerMargin)

            if hasImage {
                make.right.equalTo(bubble).offset(-innerMargin)
                
                let maxHeight: CGFloat = 200
                make.height.equalTo(maxHeight)
                if let image = profileImageView.image where image.size.height > 0 {
                    let ratio = maxHeight / image.size.height
                    let width = image.size.width * ratio
                    make.width.equalTo(width)
                }
                make.bottom.equalTo(bubble).offset(-innerMargin)
                print("if")
            } else {
                make.height.equalTo(0)
                make.width.equalTo(0)
                make.bottom.equalTo(bubble)
                make.top.greaterThanOrEqualTo(0)
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
