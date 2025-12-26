import SwiftUI

@main
struct LiquidGlassReferenceApp: App {
    @StateObject private var settings = DemoSettings()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(settings)
        }
    }
}
