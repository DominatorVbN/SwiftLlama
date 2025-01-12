//
//  LLaMAConfig.swift
//
//
//  Created by Amit Samant on 3/23/24.
//

import Foundation

/// Configuration for initializing a LLaMAServer.
public struct LLaMAConfig {
    /// The path to the server executable.
    public let executablePath: String
    /// Configuration parameters for the server, encapsulated within a `ServerConfig`.
    public let serverConfig: ServerConfig

    /// Initializes a new LLaMAConfig with the specified executable path and server configuration.
    /// - Parameters:
    ///   - executablePath: The path to the server executable. If nil, the bundle's main executable path is used.
    ///   - serverConfig: The configuration parameters for the server.
    public init(executablePath: String? = nil, serverConfig: ServerConfig) {
        self.executablePath = executablePath ?? Bundle.module.path(forResource: "llama-server", ofType: nil) ?? ""
        self.serverConfig = serverConfig
    }
}
