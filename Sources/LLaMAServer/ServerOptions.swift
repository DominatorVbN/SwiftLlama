//
//  ServerOptions.swift
//
//
//  Created by Amit Samant on 3/19/24.
//

import Foundation

/// Represents the configuration for the LLaMA.cpp HTTP server.
public struct ServerConfig {
    
    /// Path to the LLaMA model file.
    public var modelPath: String
    
    /// Number of threads to use during generation. Optional.
    public var threads: Int?
    
    /// Number of threads to use during batch and prompt processing. Optional.
    public var threadsBatch: Int?
    
    /// Number of threads in the HTTP server pool to process requests. Optional.
    public var threadsHTTP: Int?
    
    /// Specify a remote HTTP URL to download the model file. Optional.
    public var modelURL: String?
    
    /// Set an alias for the model. This alias will be returned in API responses. Optional.
    public var alias: String?
    
    /// Set the size of the prompt context. Defaults to 2048 for optimal performance.
    public var ctxSize: Int = 4096
    
    /// When compiled with appropriate support, this option allows offloading some layers to the GPU for computation. Optional.
    public var nGPULayers: Int?
    
    /// When using multiple GPUs, this controls which GPU is used for small tensors. Optional.
    public var mainGPU: Int?
    
    /// Controls how large tensors should be split across all GPUs. The split is a comma-separated list of values. Optional.
    public var tensorSplit: String?
    
    /// Set the batch size for prompt processing. Default is 512.
    public var batchSize: Int?
    
    /// Use 32-bit floats instead of 16-bit floats for memory key+value. Not recommended. Defaults to false.
    public var memoryF32: Bool = false
    
    /// Lock the model in memory, preventing it from being swapped out. Optional.
    public var mlock: Bool = false
    
    /// Do not memory-map the model. By default, models are mapped into memory. Optional.
    public var noMmap: Bool = false
    
    /// Attempt optimizations that help on some NUMA systems. Optional.
    public var numa: String?
    
    /// Apply a LoRA (Low-Rank Adaptation) adapter to the model. This allows adaptation of the pretrained model to specific tasks or domains. Optional.
    public var lora: String?
    
    /// Optional model to use as a base for the layers modified by the LoRA adapter. Used in conjunction with the `--lora` flag. Optional.
    public var loraBase: String?
    
    /// Server read/write timeout in seconds. Defaults to 600.
    public var timeout: Int = 600
    
    /// Set the hostname or IP address to listen on. Default is `127.0.0.1`.
    public var host: String?
    
    /// Set the port to listen on. Default is 8080.
    public var port: Int = 8080
    
    /// Path from which to serve static files. Optional.
    public var path: String?
    
    /// Set API keys for request authorization. Requests must have the Authorization header set with the API key as a Bearer token. Optional.
    public var apiKey: [String]?
    
    /// Path to a file containing API keys delimited by new lines. Requests must include one of the keys for access. Optional.
    public var apiKeyFile: String?
    
    /// Enable embedding extraction. Defaults to disabled.
    public var embedding: Bool = false
    
    /// Set the number of slots for process requests. Default is 1.
    public var parallel: Int?
    
    /// Enable continuous batching (a.k.a dynamic batching). Defaults to disabled.
    public var contBatching: Bool = false
    
    /// Set a file to load "a system prompt" (initial prompt of all slots), useful for chat applications. Optional.
    public var systemPromptFile: String?
    
    /// Path to a multimodal projector file for LLaVA. Optional.
    public var mmproj: String?
    
    /// Set the group attention factor to extend context size through self-extend. Optional.
    public var grpAttnN: Int?
    
    /// Set the group attention width to extend context size through self-extend. Optional.
    public var grpAttnW: Int?
    
    /// Set the maximum tokens to predict. Optional.
    public var nPredict: Int?
    
    /// To disable slots state monitoring endpoint. Slots state may contain user data, including prompts. Defaults to false.
    public var slotsEndpointDisable: Bool = false
    
    /// Enable Prometheus `/metrics` compatible endpoint. Defaults to disabled.
    public var metrics: Bool = false
    
    /// Set a custom Jinja chat template. This parameter accepts a string, not a file name. Optional.
    public var chatTemplate: String?
    
    /// Output logs to stdout only. By default, logs are enabled. Optional.
    public var logDisable: Bool = false
    
    /// Define the log output format: json or text. Default is json. Optional.
    public var logFormat: String?
    
    /// Converts the `ServerConfig` instance into an array of command-line arguments for the LLaMA.cpp server.
    func toArguments() -> [String] {
        var args: [String] = []
        
        // Model configuration
        args.append(contentsOf: optionalArgumentPair("--model", modelPath))
        args.append(contentsOf: optionalArgumentPair("--model-url", modelURL))
        args.append(contentsOf: optionalArgumentPair("--alias", "-a", alias))
        args.append(contentsOf: optionalArgumentPair("--ctx-size", ctxSize))
        args.append(contentsOf: optionalArgumentPair("--lora", lora))
        args.append(contentsOf: optionalArgumentPair("--lora-base", loraBase))
        
        // Performance and threading
        args.append(contentsOf: optionalArgumentPair("--threads", threads))
        args.append(contentsOf: optionalArgumentPair("--threads-batch", threadsBatch))
        args.append(contentsOf: optionalArgumentPair("--threads-http", threadsHTTP))
        args.append(contentsOf: optionalArgumentPair("--n-gpu-layers", nGPULayers))
        args.append(contentsOf: optionalArgumentPair("--main-gpu", mainGPU))
        args.append(contentsOf: optionalArgumentPair("--tensor-split", tensorSplit))
        args.append(contentsOf: optionalArgumentPair("-b", batchSize))
        args.append(contentsOf: optionalArgumentPair("-np", parallel))
        args.append(contentsOf: flagArgument("--memory-f32", memoryF32))
        args.append(contentsOf: flagArgument("--mlock", mlock))
        args.append(contentsOf: flagArgument("--no-mmap", noMmap))
        args.append(contentsOf: flagArgument("-cb", contBatching))
        args.append(contentsOf: optionalArgumentPair("--numa", numa))
        
        // Server and API configuration
        args.append(contentsOf: optionalArgumentPair("--host", host))
        args.append(contentsOf: argumentPair("--port", "\(port)"))
        args.append(contentsOf: optionalArgumentPair("--path", path))
        apiKey?.forEach { args.append(contentsOf: ["--api-key", $0]) }
        args.append(contentsOf: optionalArgumentPair("--api-key-file", apiKeyFile))
        args.append(contentsOf: flagArgument("--embedding", embedding))
        args.append(contentsOf: flagArgument("--slots-endpoint-disable", slotsEndpointDisable))
        args.append(contentsOf: flagArgument("--metrics", metrics))
        args.append(contentsOf: optionalArgumentPair("--system-prompt-file", systemPromptFile))
        args.append(contentsOf: optionalArgumentPair("--mmproj", mmproj))
        args.append(contentsOf: optionalArgumentPair("--grp-attn-n", grpAttnN))
        args.append(contentsOf: optionalArgumentPair("--grp-attn-w", grpAttnW))
        args.append(contentsOf: optionalArgumentPair("-n", nPredict))
        args.append(contentsOf: optionalArgumentPair("--chat-template", chatTemplate))
        args.append(contentsOf: flagArgument("--log-disable", logDisable))
        args.append(contentsOf: optionalArgumentPair("--log-format", logFormat))
        
        return args
    }
    
    private func argumentPair(_ key: String, _ value: String) -> [String] {
        [key, value]
    }
    
    private func optionalArgumentPair<T>(_ key: String, _ value: T?) -> [String] {
        guard let value = value else { return [] }
        return [key, "\(value)"]
    }
    
    private func optionalArgumentPair<T>(_ key: String, _ alternativeKey: String? = nil, _ value: T?) -> [String] {
        guard let value = value else { return [] }
        let keyToUse = alternativeKey ?? key
        return [keyToUse, "\(value)"]
    }
    
    private func flagArgument(_ key: String, _ isEnabled: Bool) -> [String] {
        isEnabled ? [key] : []
    }
    
    public init(
        modelPath: String,
        threads: Int? = nil,
        threadsBatch: Int? = nil,
        threadsHTTP: Int? = nil,
        modelURL: String? = nil,
        alias: String? = nil,
        ctxSize: Int = 4096,
        nGPULayers: Int? = 512,
        mainGPU: Int? = nil,
        tensorSplit: String? = nil,
        batchSize: Int? = nil,
        memoryF32: Bool = false,
        mlock: Bool = false,
        noMmap: Bool = false,
        numa: String? = nil,
        lora: String? = nil,
        loraBase: String? = nil,
        timeout: Int = 600,
        host: String? = nil,
        port: Int = 8080,
        path: String? = nil,
        apiKey: [String]? = nil, 
        apiKeyFile: String? = nil,
        embedding: Bool = false,
        parallel: Int? = nil,
        contBatching: Bool = false,
        systemPromptFile: String? = nil,
        mmproj: String? = nil,
        grpAttnN: Int? = nil,
        grpAttnW: Int? = nil,
        nPredict: Int? = nil,
        slotsEndpointDisable: Bool = false,
        metrics: Bool = false,
        chatTemplate: String? = nil,
        logDisable: Bool = false,
        logFormat: String? = nil
    ) {
        self.modelPath = modelPath
        self.threads = threads
        self.threadsBatch = threadsBatch
        self.threadsHTTP = threadsHTTP
        self.modelURL = modelURL
        self.alias = alias
        self.ctxSize = ctxSize
        self.nGPULayers = nGPULayers
        self.mainGPU = mainGPU
        self.tensorSplit = tensorSplit
        self.batchSize = batchSize
        self.memoryF32 = memoryF32
        self.mlock = mlock
        self.noMmap = noMmap
        self.numa = numa
        self.lora = lora
        self.loraBase = loraBase
        self.timeout = timeout
        self.host = host
        self.port = port
        self.path = path
        self.apiKey = apiKey
        self.apiKeyFile = apiKeyFile
        self.embedding = embedding
        self.parallel = parallel
        self.contBatching = contBatching
        self.systemPromptFile = systemPromptFile
        self.mmproj = mmproj
        self.grpAttnN = grpAttnN
        self.grpAttnW = grpAttnW
        self.nPredict = nPredict
        self.slotsEndpointDisable = slotsEndpointDisable
        self.metrics = metrics
        self.chatTemplate = chatTemplate
        self.logDisable = logDisable
        self.logFormat = logFormat
    }
}

