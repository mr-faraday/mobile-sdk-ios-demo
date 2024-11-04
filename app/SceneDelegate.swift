import UIKit
import SwiftUI
import DGis

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    private let container = Container()
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            do {
                var options = MapOptions.default
                options.position = CameraPosition(point: GeoPoint(latitude: 55.753284502198895, longitude: 37.62240403545171), zoom: Zoom(floatLiteral: 10))
                let mapFactory = try container.sdk.makeMapFactory(options: options)
                let viewModel = try MapObjectsIdentificationDemoViewModel(
                    mapMarkerPresenter: self.makeMapMarkerPresenter(),
                    map: mapFactory.map,
                    mapSourceFactory: MapSourceFactory(context: container.sdk.context)
                )
                                
                let rootView = try MapObjectsIdentificationDemoView(
                    viewModel: viewModel,
                    viewFactory: DemoPageComponentsFactory(
                        sdk: container.sdk,
                        context: container.sdk.context,
                        mapFactory: mapFactory
                    )
                )
                
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let position = GeoPointWithElevation(point: GeoPoint(latitude: 55.767701, longitude: 37.729146))
                      
                      let redSquare = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
                      redSquare.backgroundColor = UIColor.red
                      
                      let markerView = MapMarkerView(viewModel: MapMarkerViewModel(title: "sdfsdf", subtitle: "xcvxcv"))
                    let mapMarkerView = self.container.sdk.markerViewFactory.make(
                          view: markerView,
                          position: position,
                          anchor: Anchor(),
                          offsetX: 0.0,
                          offsetY: 0.0
                      )
                    
                    rootView.mapView?.append(markerView: mapMarkerView)
                }

                window.rootViewController = UINavigationController(
                    rootViewController: UIHostingController(rootView: rootView)
                )
            } catch let error as SDKError {
                window.rootViewController = ErrorViewController(errorText: error.description)
            } catch {
                window.rootViewController = ErrorViewController(errorText: "Unknown error: \(error)")
            }
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
    }
    
    
    private func makeMapMarkerPresenter() -> MapMarkerPresenter {
        MapMarkerPresenter { [sdk = container.sdk] mapMarkerView, position in
            sdk.markerViewFactory.make(
                view: mapMarkerView,
                position: position,
                anchor: Anchor(),
                offsetX: 0.0,
                offsetY: 0.0
            )
        }
    }
}
