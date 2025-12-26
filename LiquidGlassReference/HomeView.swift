import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var settings: DemoSettings

    @State private var showActions = false
    @State private var showInfoSheet = false

    @Namespace private var glassNS
    @Namespace private var sheetNS

    var body: some View {
        NavigationStack {
            ZStack {
                background

                ScrollView {
                    LazyVStack(spacing: 14) {
                        DemoCard(title: "Adaptive Background", subtitle: "Scroll between dark/light blocks to see glass adapt.") {
                            AdaptiveBlocks()
                        }

                        DemoCard(title: "Morphing Cluster", subtitle: "Tap + to expand. Uses GlassEffectContainer + glassEffectID + materialize.") {
                            Text("Look bottom-right →")
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        DemoCard(title: "Union Example", subtitle: "Two distant controls unified with glassEffectUnion.") {
                            UnionExample(glassNS: glassNS)
                        }

                        ForEach(0..<10) { i in
                            DemoCard(title: "Card \(i + 1)", subtitle: "Content stays normal. Glass stays in navigation/controls layer.") {
                                Text("This is regular content (no glass).")
                                    .foregroundStyle(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .padding()
                }

                // Floating controls layer (navigation layer)
                floatingCluster
            }
            .navigationTitle("Liquid Glass")
            .toolbar { topToolbar }
            .sheet(isPresented: $showInfoSheet) {
                InfoSheetView()
                    .applySheetZoomIfAvailable(sourceID: "info", ns: sheetNS)
            }
        }
    }

    private var background: some View {
        LinearGradient(
            colors: [
                Color.black.opacity(0.85),
                Color.blue.opacity(0.35),
                Color.white.opacity(0.95)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        .overlay {
            if settings.style == .clear, settings.dimBackgroundForClear {
                Color.black.opacity(0.25).ignoresSafeArea()
            }
        }
    }

    private var floatingCluster: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()

                MorphingActionCluster(
                    showActions: $showActions,
                    glassNS: glassNS
                )
                .padding()
            }
        }
    }

    @ToolbarContentBuilder
    private var topToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                showInfoSheet = true
            } label: {
                Image(systemName: "info.circle")
            }
            .applyMatchedTransitionSourceIfAvailable(id: "info", ns: sheetNS)
        }

        if #available(iOS 26.0, *) {
            ToolbarSpacer(.fixed)

            ToolbarItemGroup(placement: .topBarTrailing) {
                Button { } label: { Image(systemName: "bell") }
                    .badge(3)

                Button { } label: { Image(systemName: "square.and.pencil") }
            }
        }
    }
}

// MARK: - Morphing Cluster

private struct MorphingActionCluster: View {
    @EnvironmentObject private var settings: DemoSettings

    @Binding var showActions: Bool
    let glassNS: Namespace.ID

    private let actions: [(id: String, icon: String, title: String, tint: Color)] = [
        ("photo", "photo", "Photo", .blue),
        ("doc", "doc.text", "Document", .green),
        ("chat", "message.fill", "Chat", .orange)
    ]

    var body: some View {
        Group {
            if #available(iOS 26.0, *) {
                GlassEffectContainer(spacing: 18) {
                    VStack(spacing: 12) {
                        if showActions {
                            ForEach(actions, id: \.id) { a in
                                actionButton(icon: a.icon, title: a.title, tint: settings.tintEnabled ? a.tint : nil)
                                    .glassEffectID(a.id, in: glassNS)
                                    .glassEffectTransition(.materialize)
                            }
                        }

                        toggleButton
                            .glassEffectID("toggle", in: glassNS)
                    }
                }
            } else {
                VStack(spacing: 12) {
                    if showActions {
                        ForEach(actions, id: \.id) { a in
                            actionButton(icon: a.icon, title: a.title, tint: settings.tintEnabled ? a.tint : nil)
                        }
                    }
                    toggleButton
                }
            }
        }
    }

    private var toggleButton: some View {
        Button {
            withAnimation(.bouncy(duration: 0.38)) {
                showActions.toggle()
            }
        } label: {
            Image(systemName: showActions ? "xmark" : "plus")
                .font(.title2.bold())
                .frame(width: 56, height: 56)
        }
        .applyProminentGlassStyle()
        .tint(settings.tintEnabled ? .blue : .accentColor)
    }

    private func actionButton(icon: String, title: String, tint: Color?) -> some View {
        Button { } label: {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.headline)
                Text(title)
                    .font(.callout.bold())
                Spacer(minLength: 0)
            }
            .frame(width: 170, height: 46)
            .padding(.horizontal, 12)
        }
        .applyGlassStyle(tint: tint, interactive: settings.interactive)
    }
}

// MARK: - Cards & Demos

private struct DemoCard<Content: View>: View {
    let title: String
    let subtitle: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title).font(.headline)
            Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
            content
        }
        .padding(14)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.12), lineWidth: 1)
        )
    }
}

private struct AdaptiveBlocks: View {
    var body: some View {
        VStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.black.opacity(0.85))
                .frame(height: 90)
                .overlay(alignment: .leading) {
                    Text("Dark block")
                        .font(.subheadline.bold())
                        .padding(.leading, 12)
                        .foregroundStyle(.white)
                }

            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.95))
                .frame(height: 90)
                .overlay(alignment: .leading) {
                    Text("Light block")
                        .font(.subheadline.bold())
                        .padding(.leading, 12)
                        .foregroundStyle(.black)
                }
        }
    }
}

private struct UnionExample: View {
    @EnvironmentObject private var settings: DemoSettings
    let glassNS: Namespace.ID

    var body: some View {
        VStack(spacing: 14) {
            Text("These two controls are far apart, but visually grouped.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            if #available(iOS 26.0, *) {
                GlassEffectContainer {
                    Button { } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    .applyGlassStyle(tint: settings.tintEnabled ? .purple : nil, interactive: settings.interactive)
                    .glassEffectUnion(id: "tools", namespace: glassNS)

                    Spacer().frame(height: 60)

                    Button(role: .destructive) { } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .applyGlassStyle(tint: settings.tintEnabled ? .red : nil, interactive: settings.interactive)
                    .glassEffectUnion(id: "tools", namespace: glassNS)
                }
            } else {
                VStack(spacing: 10) {
                    Button("Edit") { }
                    Button("Delete") { }
                }
            }
        }
    }
}

// MARK: - Helpers

private extension View {
    @ViewBuilder
    func applyGlassStyle(tint: Color?, interactive: Bool) -> some View {
        if #available(iOS 26.0, *) {
            self
                .buttonStyle(.glass)
                .tint(tint ?? .primary)
                .controlSize(.regular)
        } else {
            self
        }
    }

    @ViewBuilder
    func applyProminentGlassStyle() -> some View {
        if #available(iOS 26.0, *) {
            self
                .buttonStyle(.glassProminent)
                .buttonBorderShape(.circle)
                .clipShape(Circle()) // beta-friendly
        } else {
            self
        }
    }

    @ViewBuilder
    func applyMatchedTransitionSourceIfAvailable(id: String, ns: Namespace.ID) -> some View {
        if #available(iOS 26.0, *) {
            self.matchedTransitionSource(id: id, in: ns)
        } else {
            self
        }
    }

    @ViewBuilder
    func applySheetZoomIfAvailable(sourceID: String, ns: Namespace.ID) -> some View {
        if #available(iOS 26.0, *) {
            self.navigationTransition(.zoom(sourceID: sourceID, in: ns))
        } else {
            self
        }
    }
}
