import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settings: DemoSettings

    var body: some View {
        NavigationStack {
            Form {
                Section("Glass") {
                    Picker("Variant", selection: $settings.style) {
                        ForEach(DemoSettings.GlassStyle.allCases) { style in
                            Text(style.title).tag(style)
                        }
                    }

                    Toggle("Enabled", isOn: $settings.isEnabled)
                    Toggle("Interactive", isOn: $settings.interactive)
                    Toggle("Tint Enabled", isOn: $settings.tintEnabled)

                    if settings.style == .clear {
                        Toggle("Dim background for Clear", isOn: $settings.dimBackgroundForClear)
                    }
                }

                Section("Preview") {
                    HStack(spacing: 10) {
                        Image(systemName: "sparkles")
                        Text("Preview Control")
                            .font(.headline)
                    }
                    .foregroundStyle(.white)
                    .demoGlass(
                        settings.style,
                        shape: RoundedRectangle(cornerRadius: 16, style: .continuous),
                        isEnabled: settings.isEnabled,
                        interactive: settings.interactive,
                        tint: settings.tintEnabled ? .blue.opacity(0.75) : nil
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .navigationTitle("Settings")
        }
    }
}
