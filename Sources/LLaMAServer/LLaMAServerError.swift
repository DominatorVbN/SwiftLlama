//
//  LLaMAServerError.swift
//
//
//  Created by Amit Samant on 3/23/24.
//

import Foundation

/// Errors related to the LLaMAServer operations.
public enum LLaMAServerError: Error {
    /// Indicates that the executable file was not found at the specified path.
    case executableNotFound(String)
    /// Indicates that an attempt was made to start the server while it is already running.
    case serverAlreadyRunning
    /// Indicates that the server failed to start, with a description of the failure.
    case serverStartFailed(String)
}
