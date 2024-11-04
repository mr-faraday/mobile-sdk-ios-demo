import SwiftUI
import DGis

final class Container {
	private(set) lazy var sdk: DGis.Container = {
		let container = DGis.Container(
			keySource: .default
		)
        
		return container
	}()

	private lazy var mapFactoryProvider = MapFactoryProvider(container: self.sdk, mapGesturesType: .default(.event))

	private lazy var navigationService: NavigationService = NavigationService()

//	private var localeManager: LocaleManager?

	func makeRootView() throws -> some View {
		let viewModel = self.makeRootViewModel()
		let viewFactory = try self.makeRootViewFactory()
		return RootView(
			viewModel: viewModel,
			viewFactory: viewFactory
		)
		.environmentObject(self.navigationService)
	}

	private func makeRootViewFactory() throws -> RootViewFactory {
		let viewFactory = try RootViewFactory(
			sdk: self.sdk,
			locationManagerFactory: {
				LocationService()
			},
//			settingsService: self.settingsService,
			mapProvider: self.mapFactoryProvider
//			applicationIdleTimerService: self.applicationIdleTimerService
//			navigatorSettings: self.navigatorSettings
		)
		return viewFactory
	}

	private func makeRootViewModel() -> RootViewModel {
		let rootViewModel = RootViewModel(
			demoPages: DemoPage.allCases
//			settingsService: self.settingsService
		)
		return rootViewModel
	}
}
