import SwiftUI

extension View {
    @ViewBuilder
    func demoGlass<S: Shape>(
        _ style: DemoSettings.GlassStyle,
        shape: S = Capsule(),
        isEnabled: Bool = true,
        interactive: Bool = false,
        tint: Color? = nil
    ) -> some View {
        if #available(iOS 26.0, *) {
            let finalGlass: Glass = {
                // Use identity to “disable”
                if !isEnabled || style == .off { return .identity }

                var g: Glass = (style == .clear) ? .clear : .regular

                if let tintColor = tint {
                    g = g.tint(tintColor)
                }
                if interactive {
                    g = g.interactive()
                }
                return g
            }()

            self.glassEffect(finalGlass, in: shape)   // ✅ no isEnabled:
        } else {
            self
                .padding(.vertical, 10)
                .padding(.horizontal, 14)
                .background(shape.fill(.ultraThinMaterial))
                .overlay(shape.stroke(.white.opacity(0.18), lineWidth: 1))
        }
    }
}
