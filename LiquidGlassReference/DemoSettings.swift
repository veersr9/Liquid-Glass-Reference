import SwiftUI

final class DemoSettings: ObservableObject {
    enum GlassStyle: String, CaseIterable, Identifiable {
        case regular, clear, off
        var id: String { rawValue }

        var title: String {
            switch self {
            case .regular: return "Regular"
            case .clear: return "Clear"
            case .off: return "Off"
            }
        }
    }

    @Published var style: GlassStyle = .regular
    @Published var isEnabled: Bool = true
    @Published var interactive: Bool = true
    @Published var tintEnabled: Bool = false
    @Published var dimBackgroundForClear: Bool = true
}
