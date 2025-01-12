// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftLLaMA",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "LLaMAServer",
            targets: ["LLaMAServer"]),
    ],
    targets: [
        .target(
            name: "LLaMAServer",
            sources: [
                "LLaMAConfig.swift",
                "LLaMAServer.swift",
                "LLaMAServerError.swift",
                "ServerOptions.swift"
            ],
            resources: [
                .copy("Resources/llama-server")
            ]
        ),
        .testTarget(
            name: "LLaMAServerTests",
            dependencies: ["LLaMAServer"],
            resources: [
                
                .copy("tinyllama-1.1b-chat-v0.3.Q2_K.gguf")
            ]
        ),
    ]
)
