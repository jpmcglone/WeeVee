import UIKit
import SnapKit

protocol OptionsViewDelegate {
    func optionsView(optionsView: OptionsView, didSelectOption option: Option)
}

class OptionsView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    var delegate: OptionsViewDelegate?
    
    var options: [Option]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clearColor()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.estimatedItemSize = CGSize(width: 30, height: 80)
        
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clearColor()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        addSubview(collectionView)
        
        collectionView.snp_makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        collectionView.registerClass(OptionCollectionViewCell.self, forCellWithReuseIdentifier: "option")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("option", forIndexPath: indexPath) as!OptionCollectionViewCell
        
        cell.textLabel.text = options![indexPath.row].text
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let option = options![indexPath.row]
        delegate?.optionsView(self, didSelectOption: option)
    }
}
