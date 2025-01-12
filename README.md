# LLaMAServer

LLaMAServer is a Swift-based server application designed to manage and run LLaMA.cpp server process on macOS. This repository contains the source code, configuration files, and tests necessary to build and run the server.

## Table of Contents

- Installation
- Usage
- Configuration
- Testing
- Contributing
- License

## Installation

To install the LLaMAServer in your Swift Package, add the repository url in you package dependecies.

```swift
.package(url: "https://github.com/DominatorVbN/SwiftLlama.git", .upToNextMajor(from: "0.0.1"))
```

and add the dependency as

```swift
targets: [
    .target(
        name: "YourModule",
        dependencies: ["LLaMAServer"]
    )
]
```

To install the SPM in you mac os apps

add this url to File -> Swift Packages -> Add new Dependecy

```
https://github.com/DominatorVbN/SwiftLlama.git
```

## Usage

#### Starting the Server

```swift
import LLaMAServer

let path = "path/to/model.gguf"
var serverConfig = ServerConfig(modelPath: path, port: 8080)
var config = LLaMAConfig(serverConfig: serverConfig)
let server = LLaMAServer()
try server.startServer(with: config)
```

This is gonna start a server on localhost on provided port.

The SPM ships with pre-built server executable, from version b4458 - https://github.com/ggerganov/llama.cpp/releases/tag/b4458

If you wish to use different executable you can pass the executable path in `LLaMAConfig`.

#### Stopping the Server

``` swift
server.stopServer()
```

#### Restarting the Server

``` swift
try server.restartServer(with: config)
```

## Testing

Unit tests are provided in the Tests directory. To run the tests, use the following command:

``` bash
swift test
```

## Contributing
Contributions are welcome! Please open an issue or submit a pull request with your changes.

## License

MIT License
```
MIT License

Copyright (c) 2023 Amit Samant

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

