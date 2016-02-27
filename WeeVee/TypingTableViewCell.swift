import UIKit
import SnapKit

class TypingTableViewCell: BubbleTableViewCell {
    let loadingImageView = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(loadingImageView)
        loadingImageView.image = UIImage(named: "loading")
        loadingImageView.snp_makeConstraints { make in
            make.edges.equalTo(bubble).inset(innerMargin)
        }
    }
      
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
