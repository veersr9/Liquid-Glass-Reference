import SwiftUI

struct SearchDemoView: View {
    @Binding var searchText: String

    private let items = (1...40).map { "Result Item \($0)" }

    private var filtered: [String] {
        guard !searchText.isEmpty else { return items }
        return items.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            List {
                if filtered.isEmpty {
                    Text("No results for “\(searchText)”")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(filtered, id: \.self) { item in
                        Label(item, systemImage: "magnifyingglass")
                    }
                }
            }
            .navigationTitle("Search")
            .applyMinimizedSearchIfAvailable()
        }
    }
}

private extension View {
    @ViewBuilder
    func applyMinimizedSearchIfAvailable() -> some View {
        if #available(iOS 26.0, *) {
            self.searchToolbarBehavior(.minimize)
        } else {
            self
        }
    }
}
