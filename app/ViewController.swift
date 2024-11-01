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
        
        // Позиция на карте, к которой прикрепится view 55.773944110853236, 37.772914918354886
        let position = GeoPointWithElevation(point: GeoPoint(latitude: 55.767701, longitude: 37.729146))
        // Точка внутри view, к которой будет привязана координата position
        let anchor = DGis.Anchor(x: 0, y: 0)
        // Смещение в пикселях по осям
        let offsetX: CGFloat = 0.0
        let offsetY: CGFloat = 0.0
        
        let redSquare = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        redSquare.backgroundColor = UIColor.red

        let viewFactory = sdk.markerViewFactory.make(
            view: redSquare,
            position : position,
            anchor: anchor,
            offsetX: offsetX,
            offsetY: offsetY
        )
        
        mapFactory.markerViewOverlay.add(markerView: viewFactory)
    }
}

