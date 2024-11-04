import UIKit
import DGis

class ViewController: UIViewController {
    private(set) lazy var sdk: DGis.Container = {
        let container = DGis.Container(
            keySource: .default
        )
        return container
    }()
    
    private lazy var mapFactory: DGis.IMapFactory = {
        do {
            var mapOptions = MapOptions.default
            mapOptions.position = CameraPosition(point: GeoPoint(latitude: 55.753284502198895, longitude: 37.62240403545171), zoom: Zoom(floatLiteral: 10))
            let factory = try sdk.makeMapFactory(options: mapOptions)
            return factory
        } catch {
            fatalError("IMapFactory initialization error: \(error)")
        }
    }()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mapFactory.mapView)
        mapFactory.mapView.frame = view.bounds
        
        let position = GeoPointWithElevation(point: GeoPoint(latitude: 55.767701, longitude: 37.729146))
        
        let redSquare = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        redSquare.backgroundColor = UIColor.red
        
        let markerView = MapMarkerView(title: "sdfsd", subtitle: "xcvxcv")
        let view = sdk.markerViewFactory.make(
            view: markerView,
            position: position,
            anchor: Anchor(),
            offsetX: 0.0,
            offsetY: 0.0
        )
        
        mapFactory.markerViewOverlay.add(markerView: view)
    }
}

