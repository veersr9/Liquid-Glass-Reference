import SwiftUI

struct RootTabView: View {
    @State private var selectedTab = 0
    @State private var searchText = ""

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house", value: 0) {
                HomeView()
            }

            Tab("Playground", systemImage: "sparkles", value: 1) {
                GlassPlaygroundView()
            }

            Tab("Search", systemImage: "magnifyingglass", value: 2, role: .search) {
                SearchDemoView(searchText: $searchText)
            }

            Tab("Settings", systemImage: "gearshape", value: 3) {
                SettingsView()
            }
        }
        .searchable(text: $searchText)
        .applyTabBarExtras()
    }
}

private extension View {
    @ViewBuilder
    func applyTabBarExtras() -> some View {
        if #available(iOS 26.0, *) {
            self
                .tabBarMinimizeBehavior(.onScrollDown)
                .tabViewBottomAccessory {
                    NowPlayingAccessoryView()
                }
        } else {
            self
        }
    }
}

struct NowPlayingAccessoryView: View {
    @Environment(\.tabViewBottomAccessoryPlacement) private var placement

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "music.note")
                .font(.title3)

            VStack(alignment: .leading, spacing: 2) {
                Text("Now Playing")
                    .font(.subheadline.bold())
                Text("Liquid Glass Demo Mix")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button { } label: {
                Image(systemName: "play.fill")
            }
            .applyGlassButtonStyle()
        }
        .padding()
        .opacity((placement ?? .expanded) == .inline ? 0.75 : 1.0)
    }
}

private extension View {
    @ViewBuilder
    func applyGlassButtonStyle() -> some View {
        if #available(iOS 26.0, *) {
            self
                .buttonStyle(.glass)
                .controlSize(.small)
        } else {
            self
        }
    }
}
