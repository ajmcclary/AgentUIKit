// swift-tools-version: 6.0
import PackageDescription

let settings: [SwiftSetting] = [.swiftLanguageMode(.v6), .enableExperimentalFeature("StrictConcurrency")]
let package = Package(
    name: "AgentUIKit",
    platforms: [.macOS("27.0")],
    products: [.library(name: "AgentUIKit", targets: ["AgentUIKit"])],
    targets: [
        .target(name: "AgentUIKit", swiftSettings: settings),
        .testTarget(name: "AgentUIKitTests", dependencies: ["AgentUIKit"], swiftSettings: settings)
    ]
)
