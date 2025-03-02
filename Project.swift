import ProjectDescription
import Foundation

extension Target {
    static func featureTarget(
        name: String,
        productName: String,
        product: Product = .staticLibrary,
        dependencies: [TargetDependency],
        hasResources: Bool = false
    ) -> Self {
         target(
            name: name,
            destinations: .iOS,
            product: .staticLibrary,
            productName: productName,
            bundleId: "com.swiftbuddies.\(productName.lowercased())",
            deploymentTargets: .iOS("17.0"),
            sources: ["SwiftBuddiesIOS/Targets/\(name)Module/Sources/**"],
            resources: hasResources ? ["SwiftBuddiesIOS/Targets/\(name)Module/Resources/**"] : [],
            dependencies: dependencies)
    }
}

let project = Project(
    name: "Buddies",
    packages: [
        .remote(url: "https://github.com/google/GoogleSignIn-iOS.git", requirement: .exact("7.0.0")),
        .remote(url: "https://github.com/apple/swift-argument-parser.git", requirement: .exact("1.3.0")),
        .remote(url: "https://github.com/darkbringer1/BuddiesNetwork.git", requirement: .upToNextMajor(from: .init(0, 0, 1)))
    ],
    targets: [
        .target(
            name: "SwiftBuddiesIOS",
            destinations: .iOS,
            product: .app,
            bundleId: "com.dogukaank.SwiftBuddiesIOS",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(
                with: [
                    "CFBundleShortVersionString": "0.0.1",
                    "CFBundleVersion": "1",
                    "UIMainStoryboardFile": "",
                    "UILaunchStoryboardName": "LaunchScreen",
                    "CLIENT_ID": "1015261010783-dq3s025o2j6pcj81ped6nqpbiv5m1fvr.apps.googleusercontent.com",
                    "REVERSED_CLIENT_ID": "com.googleusercontent.apps.1015261010783-dq3s025o2j6pcj81ped6nqpbiv5m1fvr",
                    "NSLocationWhenInUseUsageDescription": "Your location is needed to provide location-based features.",
                    "NSCameraUsageDescription": "Camera is needed to take photos.",
                    "CFBundleURLTypes": [
                        ["CFBundleURLSchemes": ["com.googleusercontent.apps.1015261010783-dq3s025o2j6pcj81ped6nqpbiv5m1fvr"]]
                    ],
                    "ITSAppUsesNonExemptEncryption": false
                ]
            ),
            sources: ["SwiftBuddiesIOS/Sources/**"],
            resources: ["SwiftBuddiesIOS/Resources/**"],
            entitlements: .dictionary(
                [
                    "com.apple.developer.applesignin" : ["Default"],
                    "com.apple.developer.authentication-services.autofill-credential-provider": true
                ]
            ),
            dependencies: [
                .package(product: "GoogleSignIn", type: .runtime, condition: .none),
                .package(product: "BuddiesNetwork", type: .runtime, condition: .none),
                .target(Modules.design.target),
                .target(Modules.auth.target),
                .target(Modules.onboarding.target),
                .target(Modules.login.target),
                .target(Modules.feed.target),
                .target(Modules.map.target),
                .target(Modules.profile.target),
                .target(Modules.contributors.target),
                .target(Modules.network.target),
                .target(Modules.localization.target),
                .target(Modules.core.target)
            ]
        ),
        Modules.design.target,
        Modules.auth.target,
        Modules.onboarding.target,
        Modules.login.target,
        Modules.feed.target,
        Modules.map.target,
        Modules.profile.target,
        Modules.contributors.target,
        Modules.network.target,
        Modules.localization.target,
        Modules.core.target,
        Modules.localicationCodegen
    ]
)


enum Modules: CaseIterable {
    case core
    case localization
    case design
    case network
    case auth
    case onboarding
    case login
    case feed
    case map
    case profile
    case contributors
    
    
    var target: Target {
        switch self {
        case .core:
            Target.featureTarget(
                name: "Core",
                productName: "Core",
                dependencies:
                    [.target(Modules.auth.target), .target(Modules.network.target),
                        .package(product: "GoogleSignIn", type: .runtime, condition: .none)]
            )
        case .localization:
            Target.featureTarget(
                name: "Localization",
                productName: "Localization",
                dependencies: [],
                hasResources: true
            )
        case .design:
            Target.featureTarget(
                name: "Design",
                productName: "Design",
                dependencies: [.target(Modules.localization.target)],
                hasResources: true
            )
        case .network:
            Target.featureTarget(
                name: "Network",
                productName: "Network",
                dependencies: [
                    .package(product: "BuddiesNetwork", type: .runtime, condition: .none)
                ]
            )
        case .auth:
            Target.featureTarget(
                name: "Auth",
                productName: "Auth",
                dependencies: [
                    .target(Modules.network.target),
                    .package(product: "GoogleSignIn", type: .runtime, condition: .none)
                ]
            )
        case .onboarding:
            Target.featureTarget(
                name: "Onboarding",
                productName: "Onboarding",
                dependencies: [
                    .target(Modules.design.target),
                    .target(Modules.core.target),
                ]
            )
        case .login:
            Target.featureTarget(
                name: "Login",
                productName: "Login",
                dependencies: [
                    .target(Modules.design.target),
                    .target(Modules.auth.target),
                    .target(Modules.network.target),
                    .target(Modules.core.target),
                    .package(product: "GoogleSignIn", type: .runtime, condition: .none)
                ]
            )
        case .feed:
            Target.featureTarget(
                name: "Feed",
                productName: "Feed",
                dependencies: [
                    .target(Modules.core.target),
                    .target(Modules.design.target),
                    .package(product: "GoogleSignIn", type: .runtime, condition: .none)
                ]
            )
        case .map:
            Target.featureTarget(
                name: "Map",
                productName: "Map",
                dependencies: [
                    .target(Modules.core.target),
                    .target(Modules.design.target)
                ]
            )
        case .profile:
            Target.featureTarget(
                name: "Profile",
                productName: "Profile",
                dependencies: [
                    .target(Modules.design.target),
                    .target(Modules.auth.target),
                    .target(Modules.network.target),
                    .target(Modules.core.target),
                    .package(product: "GoogleSignIn", type: .runtime, condition: .none)
                ]
            )
        case .contributors:
            Target.featureTarget(
                name: "Contributors",
                productName: "Contributors",
                dependencies: [
                    .target(Modules.core.target),
                    .target(Modules.design.target)
                ]
            )
        }
    }
    
    static let localicationCodegen = Target.target(
        name: "LocalizationCodegen",
        destinations: .macOS,
        product: .commandLineTool,
        productName: "LocalizationCodegen",
        bundleId: "com.swiftbuddies.localization",
        sources: ["SwiftBuddiesIOS/Targets/ScriptsModule/LocalizationCodegen/**"],
        scripts: [],
        dependencies: [.package(product: "ArgumentParser", type: .runtime, condition: .none)],
        coreDataModels: [],
        environmentVariables: [:],
        launchArguments: [],
        additionalFiles: [],
        buildRules: [],
        mergedBinaryType: .automatic,
        mergeable: false
    )
}

//let scriptsModule = Target.target(
//    name: "Scripts",
//    destinations: .macOS,
//    product: .staticFramework,
//    productName: "Scripts",
//    bundleId: "com.swiftbuddies.scripts",
//    deploymentTargets: nil,
//    infoPlist: nil,
//
//    sources: ["SwiftBuddiesIOS/Targets/ScriptsModule/**"],
//    resources: nil,
//    copyFiles: nil,
//    headers: nil,
//    entitlements: nil,
//    scripts: [],
//    dependencies: [.target(localicationCodegen)],
//    settings: nil,
//    coreDataModels: [],
//    environmentVariables: [:],
//    launchArguments: [],
//    additionalFiles: [],
//    buildRules: [],
//    mergedBinaryType: .automatic,
//    mergeable: false
//)
