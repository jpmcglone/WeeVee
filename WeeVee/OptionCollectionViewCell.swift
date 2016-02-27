import UIKit
import SnapKit
import TK

class OptionCollectionViewCell: UICollectionViewCell {
    let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textLabel.font = UIFont.boldSystemFontOfSize(14)
        textLabel.textColor = .whiteColor()
        textLabel.text = "Options blah dee blah"
        contentView.backgroundColor = UIColor.tk_color(0xFF7B1B)
        contentView.layer.cornerRadius = 4
        contentView.layer.masksToBounds = true
        contentView.addSubview(textLabel)
        
        textLabel.snp_makeConstraints { make in
            make.edges.equalTo(contentView).inset(10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
