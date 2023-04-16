// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MyCoverAI",
    
    platforms:[
        .iOS(.v15)
    ],
    
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "MyCoverAI",
            targets: ["MyCoverAI"]),
    ],
    
    
    
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "Lottie", url: "https://github.com/airbnb/lottie-ios", .upToNextMajor(from: "4.0.0")),
        .package(name: "FilePicker", url: "https://github.com/markrenaud/FilePicker", .upToNextMajor(from: "1.0.0")),
        .package(name: "Alamofire", url: "https://github.com/Alamofire/Alamofire", .upToNextMajor(from: "5.0.0")),
        .package(name: "AnyCodable", url: "https://github.com/Flight-School/AnyCodable", .upToNextMajor(from: "0.6.7")),
        
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "MyCoverAI",
            dependencies: [
                .product(name: "Lottie", package: "Lottie"),
                .product(name: "FilePicker", package: "FilePicker"),
                .product(name: "Alamofire", package: "Alamofire"),
                //.product(name: "Pusher", package: "Pusher"),
                .product(name: "AnyCodable", package: "AnyCodable"),
            ], resources: [
                .process("Assets.xcassets"),
                .process("fonts"),
                .process("check.json"),
                .process("loading.json")

            ]),
        .testTarget(
            name: "MCALibraryTests",
            dependencies: ["MyCoverAI"]),
    ]
)
