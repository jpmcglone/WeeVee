import UIKit
import SnapKit
import TK

class MessageTableViewCell: BubbleTableViewCell {
    let messageLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        messageLabel.textColor = .whiteColor()
        messageLabel.numberOfLines = 0
        
        contentView.addSubview(messageLabel)
        
        messageLabel.snp_makeConstraints { make in
            make.edges.equalTo(bubble).inset(innerMargin)
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
