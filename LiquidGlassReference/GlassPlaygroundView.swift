import SwiftUI

struct GlassPlaygroundView: View {
    @EnvironmentObject private var settings: DemoSettings
    @State private var demoPressed = false
    @Namespace private var ns

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text("Playground")
                        .font(.largeTitle.bold())
                        .padding(.top, 8)

                    styleControls

                    Text("Basic Glass Samples")
                        .font(.headline)

                    samplesGrid

                    Text("Morphing Row")
                        .font(.headline)

                    morphingRow
                }
                .padding()
            }
            .navigationTitle("Playground")
        }
    }

    private var styleControls: some View {
        VStack(spacing: 12) {
            Picker("Glass", selection: $settings.style) {
                ForEach(DemoSettings.GlassStyle.allCases) { style in
                    Text(style.title).tag(style)
                }
            }
            .pickerStyle(.segmented)

            Toggle("Enabled", isOn: $settings.isEnabled)
            Toggle("Interactive", isOn: $settings.interactive)
            Toggle("Tint Enabled", isOn: $settings.tintEnabled)
        }
        .padding(14)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.12), lineWidth: 1)
        )
    }

    private var samplesGrid: some View {
        let tint: Color? = settings.tintEnabled ? .blue.opacity(0.75) : nil

        return LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
            sampleTile("Capsule", system: "capsule.fill") {
                Label("Hello", systemImage: "sparkles")
                    .labelStyle(.titleAndIcon)
                    .demoGlass(settings.style, shape: Capsule(),
                               isEnabled: settings.isEnabled,
                               interactive: settings.interactive,
                               tint: tint)
            }

            sampleTile("Circle", system: "circle.fill") {
                Image(systemName: "heart.fill")
                    .font(.title2.bold())
                    .frame(width: 54, height: 54)
                    .demoGlass(settings.style, shape: Circle(),
                               isEnabled: settings.isEnabled,
                               interactive: settings.interactive,
                               tint: settings.tintEnabled ? .red.opacity(0.8) : nil)
            }

            sampleTile("RoundedRect", system: "square.roundedbottom.fill") {
                Text("Rounded")
                    .font(.headline)
                    .demoGlass(settings.style,
                               shape: RoundedRectangle(cornerRadius: 16, style: .continuous),
                               isEnabled: settings.isEnabled,
                               interactive: settings.interactive,
                               tint: tint)
            }

            sampleTile("Press", system: "hand.tap.fill") {
                Button {
                    demoPressed.toggle()
                } label: {
                    Text(demoPressed ? "Pressed" : "Tap me")
                        .font(.headline)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .demoGlass(settings.style,
                           shape: Capsule(),
                           isEnabled: settings.isEnabled,
                           interactive: true,
                           tint: settings.tintEnabled ? .purple.opacity(0.7) : nil)
            }
        }
    }

    private func sampleTile(_ title: String, system: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(title, systemImage: system)
                .font(.subheadline.bold())
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.12), lineWidth: 1)
        )
    }

    private var morphingRow: some View {
        Group {
            if #available(iOS 26.0, *) {
                GlassEffectContainer(spacing: 22) {
                    HStack(spacing: 12) {
                        Button { } label: { Image(systemName: "pencil") }
                            .frame(width: 48, height: 48)
                            .buttonStyle(.glass)
                            .buttonBorderShape(.circle)
                            .glassEffectID("a", in: ns)

                        if settings.isEnabled {
                            Button { } label: { Image(systemName: "crop") }
                                .frame(width: 48, height: 48)
                                .buttonStyle(.glass)
                                .buttonBorderShape(.circle)
                                .glassEffectID("b", in: ns)
                                .glassEffectTransition(.materialize)
                        }

                        Button { } label: { Image(systemName: "trash") }
                            .frame(width: 48, height: 48)
                            .buttonStyle(.glass)
                            .buttonBorderShape(.circle)
                            .glassEffectID("c", in: ns)
                    }
                }
                .padding(14)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            } else {
                Text("Requires iOS 26")
                    .foregroundStyle(.secondary)
            }
        }
    }
}
