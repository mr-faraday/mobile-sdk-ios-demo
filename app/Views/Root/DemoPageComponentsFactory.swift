import SwiftUI
import PlatformSDK

struct DemoPageComponentsFactory {
	private let mapFactory: IMapFactory
	private let imageFactory: () -> IImageFactory
	private let sourceFactory: () -> ISourceFactory
	private let routeEditorFactory: () -> RouteEditor
	private let routeEditorSourceFactory: (RouteEditor) -> RouteEditorSource

	internal init(
		mapFactory: IMapFactory,
		imageFactory: @escaping () -> IImageFactory,
		sourceFactory: @escaping () -> ISourceFactory,
		routeEditorFactory: @escaping () -> RouteEditor,
		routeEditorSourceFactory: @escaping (RouteEditor) -> RouteEditorSource
	) {
		self.mapFactory = mapFactory
		self.imageFactory = imageFactory
		self.sourceFactory = sourceFactory
		self.routeEditorFactory = routeEditorFactory
		self.routeEditorSourceFactory = routeEditorSourceFactory
	}

	func makeMapView() -> MapView {
		MapView(mapUIViewFactory: { [mapFactory = self.mapFactory] in
			mapFactory.mapView
		})
	}

	func makeMapViewWithZoomControl(
		alignment: CopyrightAlignment = .bottomRight,
		mapCoordinateSpace: String = "map",
		touchUpHandler: ((CGPoint) -> Void)? = nil
	) -> some View {
		ZStack {
			self.makeMapView()
				.copyrightAlignment(alignment)
				.coordinateSpace(name: mapCoordinateSpace)
				.touchUpRecognizer(coordinateSpace: .named(mapCoordinateSpace), handler: { location in
					touchUpHandler?(location)
				})
			HStack {
				Spacer()
				self.makeZoomControl()
					.frame(width: 60, height: 128)
					.fixedSize()
					.transformEffect(.init(scaleX: 0.8, y: 0.8))
					.padding(10)
			}
		}
	}

	func makeZoomControl() -> some View {
		MapControl(controlFactory: self.mapFactory.mapControlFactory.makeZoomControl)
	}

	func makeCustomControl() -> some View {
		MapControl(controlFactory: { [mapFactory = self.mapFactory] in
			CustomZoomControl(map: mapFactory.map)
		})
	}

	func makeSearchView(searchStore: SearchStore) -> some View {
		return SearchView(store: searchStore)
	}

	func makeMarkerView(show: Binding<Bool>) -> some View {
		let viewModel = MarkerViewModel(imageFactory: self.imageFactory(), map: self.mapFactory.map)
		return MarkerView(viewModel: viewModel, show: show)
	}

	func makeRouteView(show: Binding<Bool>) -> some View {
		let viewModel = RouteViewModel(
			sourceFactory: self.sourceFactory,
			routeEditorSourceFactory: self.routeEditorSourceFactory,
			routeEditorFactory: self.routeEditorFactory,
			map: self.mapFactory.map)
		return RouteView(viewModel: viewModel, show: show)
	}

	func makeMapObjectCardView(_ viewModel: MapObjectCardViewModel) -> some View {
		return MapObjectCardView(viewModel: viewModel)
	}
}
