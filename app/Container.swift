import SwiftUI
import DGis

final class Container {
	private(set) lazy var sdk: DGis.Container = {
		let container = DGis.Container(
			keySource: .default
		)
        
		return container
	}()
}
