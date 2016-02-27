import UIKit
import SnapKit

class BubbleTableViewCell: UITableViewCell {
    let avatarImageView = UIImageView()
    let bubble = UIView()
    let margin: CGFloat = 10
    let innerMargin: CGFloat = 10
    
    var isMe = false {
        didSet {
            update()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clearColor()

        selectionStyle = .None

        let height: CGFloat = 25
        avatarImageView.layer.cornerRadius = height / 2
        avatarImageView.layer.masksToBounds = true
        avatarImageView.image = UIImage(named: "avatar")
        avatarImageView.contentMode = .ScaleAspectFit
        
        bubble.backgroundColor = UIColor(white: 1, alpha: 1)
        bubble.layer.cornerRadius = 4
        bubble.layer.masksToBounds = true
        contentView.addSubview(bubble)
        contentView.addSubview(avatarImageView)
        
        avatarImageView.snp_makeConstraints { make in
            make.left.equalTo(contentView).offset(margin)
            make.bottom.equalTo(bubble)
            make.width.equalTo(height)
            make.height.equalTo(height)
        }
        update()
    }
    
    func update() {
        avatarImageView.hidden = isMe
        bubble.backgroundColor = isMe ? .whiteColor() : UIColor(white: 1.0, alpha: 0.4)
        bubble.snp_remakeConstraints { make in
            make.top.equalTo(contentView).offset(margin)
            if isMe {
                make.left.greaterThanOrEqualTo(contentView).offset(margin * 2)
                make.right.equalTo(contentView).offset(-margin)
            } else {
                make.left.equalTo(avatarImageView.snp_right).offset(5)
                make.right.lessThanOrEqualTo(contentView).offset(-margin)
            }
            make.bottom.equalTo(contentView)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
