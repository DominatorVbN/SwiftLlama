import Foundation
import os.log

public class LLaMAServer {
    
    private var serverProcess: Process?
    private var outputPipe: Pipe?
    private var errorPipe: Pipe?
    private let logger = Logger(subsystem: "LLaMAServer", category: "Server")
    
    
    public init(){
        
    }
    
    /// Indicates whether the LLaMA server is currently running.
    public var isServerRunning: Bool {
        return serverProcess?.isRunning ?? false
    }

    /// Starts the LLaMA server with the specified configuration.
    /// Throws an error if the server cannot be started, including if the executable is not found or if the server is already running.
    /// - Parameter config: The configuration for the LLaMA server.
    public func startServer(with config: LLaMAConfig) throws {
        guard FileManager.default.fileExists(atPath: config.executablePath) else {
            logger.error("Executable does not exist at path: \(config.executablePath)")
            throw LLaMAServerError.executableNotFound(config.executablePath)
        }
        
        if isServerRunning == true {
            logger.warning("Server is already running, to restart please call LLaMAServer.restartServer(with:)")
            return
        }
        
        // Setup a new process and pipes every time to ensure clean state
        serverProcess = Process()
        serverProcess?.executableURL = URL(fileURLWithPath: config.executablePath)
        serverProcess?.arguments = config.serverConfig.toArguments()
        print("\(URL(fileURLWithPath: config.executablePath).path) \(config.serverConfig.toArguments().joined(separator: " "))")
        setupOutputHandling(for: serverProcess!)
        setupErrorHandling(for: serverProcess!)
        
        do {
            try serverProcess!.run()
        } catch {
            logger.error("Failed to start LLaMA server: \(error)")
            throw LLaMAServerError.serverStartFailed(error.localizedDescription)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(processTerminated), name: Process.didTerminateNotification, object: serverProcess!)

    }
    
    /// Called when the server process terminates. Removes the observer for the termination notification.
    @objc private func processTerminated(notification: Notification) {
        guard let process = notification.object as? Process else { return }
        logger.critical("LLaMA server process with pid \(process.processIdentifier) terminated, with status code: \(process.terminationStatus)")
        NotificationCenter.default.removeObserver(self, name: Process.didTerminateNotification, object: process)
    }

    /// Stops the running LLaMA server. Does nothing if the server is not running.
    public func stopServer() {
        guard isServerRunning else { return }
        serverProcess?.terminate()
    }


    /// Restarts the LLaMA server with the provided configuration. Stops the server if it is running, then starts it again.
    /// - Parameter config: The configuration for the server.
    public func restartServer(with config: LLaMAConfig) throws {
        stopServer()
        try startServer(with: config)
    }

    /// Sets up output handling for capturing and logging the standard output of the server process.
    /// - Parameter process: server process
    private func setupOutputHandling(for process: Process) {
        let outputPipe = Pipe()
        process.standardOutput = outputPipe
        self.outputPipe = outputPipe

        outputPipe.fileHandleForReading.readabilityHandler = { [weak self] handle in
            let data = handle.availableData
            if let output = String(data: data, encoding: .utf8) {
                self?.handleServerOutput(output)
            }
        }
    }

    /// Sets up error handling for capturing and logging the standard error output of the server process.    
    /// - Parameter process: server process
    private func setupErrorHandling(for process: Process) {
        let errorPipe = Pipe()
        process.standardError = errorPipe
        self.errorPipe = errorPipe

        errorPipe.fileHandleForReading.readabilityHandler = { [weak self] handle in
            let data = handle.availableData
            if let output = String(data: data, encoding: .utf8) {
                self?.handleServerError(output)
            }
        }
    }

    /// Handles logging of the server's standard output.
    /// - Parameter output: The output string to log.
    private func handleServerOutput(_ output: String) {
        guard !output.isEmpty else {
            return
        }
        logger.info("[LLAMA Server i]: \(output)")
    }

    /// Handles logging of the server's error output.
    /// - Parameter output: The error string to log.
    private func handleServerError(_ output: String) {
        guard !output.isEmpty else {
            return
        }
        logger.error("[LLAMA Server e]: \(output)")
    }

}
