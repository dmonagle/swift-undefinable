// swift-tools-version: 5.4
import PackageDescription

let package = Package(
    name: "undefinable",
    products: [
        .library(
            name: "Undefinable",
            targets: ["Undefinable"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Undefinable",
            dependencies: []),
        .testTarget(
            name: "UndefinableTests",
            dependencies: ["Undefinable"]),
    ]
)
