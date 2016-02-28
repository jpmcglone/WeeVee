import UIKit
import MapKit
import SnapKit
import TK

class EventTableViewCell: BubbleTableViewCell {
    let titleLabel = UILabel()
    let mapView = MKMapView()
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0) {
        didSet {
//            if oldValue.latitude == coordinate.latitude && oldValue.longitude == coordinate.longitude {
//                return
//            }
//            let mapPoint = MKMapPointForCoordinate(coordinate)
//            let mapRect = MKMapRectMake(mapPoint.x, mapPoint.y, 2, 2)
//            let zoomRect = MKMapRectUnion(MKMapRectNull, mapRect)
//            mapView.setVisibleMapRect(zoomRect, animated: false)
//            
            let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            var region = MKCoordinateRegion(center: coordinate, span: span)
            region = mapView.regionThatFits(region)
            
            mapView.setRegion(region, animated: false)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        mapView.userInteractionEnabled = false
        titleLabel.text = "Event yo"
        titleLabel.font = UIFont.boldSystemFontOfSize(12)
        titleLabel.textColor = .whiteColor()
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(mapView)
        
        titleLabel.snp_makeConstraints { make in
            make.left.top.equalTo(bubble).offset(10)
            make.right.lessThanOrEqualTo(bubble).offset(-10)
        }
        
        mapView.snp_makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottom).offset(10)
            make.width.equalTo(200)
            make.height.equalTo(200)
            make.left.equalTo(bubble).offset(10)
            make.right.equalTo(bubble).offset(-10)
            make.bottom.equalTo(bubble).offset(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
