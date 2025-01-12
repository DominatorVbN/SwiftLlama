import XCTest
@testable import LLaMAServer

final class LLaMAServerTests: XCTestCase {
    func testStartServer() throws {
        let path = try XCTUnwrap(Bundle.module.path(forResource: "tinyllama-1.1b-chat-v0.3.Q2_K", ofType: "gguf"))
        let server = LLaMAServer()
        let sut = ServerConfig(modelPath: path, port: 8080)
        try server.startServer(with: .init(serverConfig: sut))
        XCTAssertTrue(server.isServerRunning)
    }
}
