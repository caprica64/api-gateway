// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "FactorialCalculator",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "FactorialCalculator", targets: ["FactorialCalculator"])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-server/swift-aws-lambda-runtime.git", from: "0.5.2")
    ],
    targets: [
        .executableTarget(
            name: "FactorialCalculator",
            dependencies: [
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime")
            ]
        )
    ]
)