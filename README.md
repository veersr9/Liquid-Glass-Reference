# Liquid-Glass-Reference

# LiquidGlassReference (iOS 26 Liquid Glass Demo)

A SwiftUI sample app that showcases Apple’s **iOS 26 Liquid Glass** design system APIs in a clean, practical “playground” style project.

This repo focuses on **navigation-layer glass** (toolbars, floating controls, tab bar extras) and demonstrates how to build real UI patterns using:

- `glassEffect(_:, in:)`
- `GlassEffectContainer`
- `glassEffectID` (morphing)
- `glassEffectTransition(.materialize)`
- `glassEffectUnion` (manual grouping)
- `TabView` extras (minimize behavior + bottom accessory)
- Optional helpers to keep the app compiling on older iOS versions (fallback)

---

## Requirements

- **Xcode 26+**
- **iOS 26 SDK**
- Run on an **iOS 26 Simulator** or **iOS 26 device**

> Note: If you see only “My Mac” in the run destinations, ensure the scheme target is **iOS** (iphoneos/iphonesimulator) and not macOS.

---

## What’s Inside

### Tabs

**1) Home**
- Floating “Action Cluster” using `GlassEffectContainer` + `glassEffectID`
- Smooth show/hide morphing using `glassEffectTransition(.materialize)`
- “Union” demo: distant controls grouped with `glassEffectUnion`
- Toolbar buttons + sheet open animation (guarded by availability)

**2) Playground**
- Switch between **Regular / Clear / Off**
- Toggle **Interactive** and **Tint**
- Grid of different glass shapes (capsule, circle, rounded rectangle)
- Morphing row sample

**3) Search**
- `searchable(text:)`
- iOS 26 search toolbar behavior (minimized) when available

**4) Settings**
- Global toggles to control how glass is applied across the demo
- Clear variant background dim option for readability

---

## Key APIs Demonstrated

### Basic Glass
```swift
Text("Hello")
  .padding()
  .glassEffect(.regular, in: .capsule)
```

**Container (Recommended for Multiple Glass Elements)  **
```swift
GlassEffectContainer {
  HStack {
    Button("Edit") { }
      .buttonStyle(.glass)

    Button("Delete") { }
      .buttonStyle(.glass)
  }
}
```

**Morphing (glassEffectID + Namespace)**
```swift
@Namespace private var ns
@State private var expanded = false

GlassEffectContainer(spacing: 18) {
  if expanded {
    Button("Action") { }
      .glassEffect(.regular, in: .capsule)
      .glassEffectID("action", in: ns)
      .glassEffectTransition(.materialize)
  }

  Button(expanded ? "Close" : "Open") { expanded.toggle() }
    .glassEffect(.regular, in: .circle)
    .glassEffectID("toggle", in: ns)
}
```

**Union (Group Far-Apart Glass Controls)**
```swift
GlassEffectContainer {
  Button("Edit") { }
    .buttonStyle(.glass)
    .glassEffectUnion(id: "tools", namespace: ns)

  Spacer().frame(height: 80)

  Button("Delete") { }
    .buttonStyle(.glass)
    .glassEffectUnion(id: "tools", namespace: ns)
}
```

Compatibility Helper
This repo includes a small helper (demoGlass) that:
* Uses iOS 26 Liquid Glass when available
* Falls back to ultraThinMaterial on older iOS versions
Liquid Glass is best reserved for the navigation layer, not content cells/lists.


How to Run
1. Open LiquidGlassReference.xcodeproj
2. Select an iOS 26 Simulator
3. Run ▶︎
If signing issues appear:
* Go to Signing & Capabilities
* Select your Team


Credits / References
* Apple WWDC 2025 sessions and SwiftUI Liquid Glass documentation
* iOS 26 sample patterns inspired by community Liquid Glass demos
