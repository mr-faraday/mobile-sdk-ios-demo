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
//                let options = MapOptions.default
//                let mapFactory = try container.sdk.makeMapFactory(options: options)
//                let viewModel = try MapObjectsIdentificationDemoViewModel(
//                    searchManager: self.makeSearchManager(),
//                    imageFactory: self.makeImageFactory(),
//                    mapMarkerPresenter: self.makeMapMarkerPresenter(),
//                    map: mapFactory.map,
//                    mapSourceFactory: MapSourceFactory(context: self.context)
//                )
//                let view = MapObjectsIdentificationDemoView(
//                    viewModel: viewModel,
//                    viewFactory: self.makeDemoPageComponentsFactory(mapFactory: mapFactory)
//                )
                
                
				let rootView = try self.container.makeRootView()
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
}
