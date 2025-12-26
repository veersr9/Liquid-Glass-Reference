import SwiftUI

struct InfoSheetView: View {
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                Text("About this Demo")
                    .font(.title.bold())

                Text("This sheet intentionally avoids custom backgrounds so the system can apply the new glass presentation.")
                    .foregroundStyle(.secondary)

                Divider()

                Text("Try:")
                    .font(.headline)

                Text("• Switch Regular/Clear/Off in Settings\n• Toggle Interactive + Tint\n• Expand the floating action cluster\n• Scroll between dark/light blocks")
                    .foregroundStyle(.secondary)

                Spacer()
            }
            .padding()
            .navigationTitle("Info")
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.medium, .large])
    }
}
