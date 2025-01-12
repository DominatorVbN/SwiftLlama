//
//  ServerConfigTests.swift
//
//
//  Created by Amit Samant on 3/19/24.
//

import XCTest
@testable import LLaMAServer

final class ServerConfigTests: XCTestCase {
    // Helper method to check if all elements of `subset` are in `array`.
    // This method doesn't consider the order of elements.
    private func assertContainsSameElements(array: [String], subset: [String]) {
        subset.forEach { element in
            XCTAssertTrue(array.contains(element), "Expected \(element) to be in the arguments array")
        }
    }

    func testBasicConfiguration() {
        let sut = ServerConfig(modelPath: "/path/to/model")
        let arguments = sut.toArguments()
        let expectedArguments = ["--model", "/path/to/model", "-c", "2048", "-b", "512", "--host", "127.0.0.1", "--port", "8080", "-np", "1"]

        XCTAssertEqual(arguments.count, expectedArguments.count, "Arguments array doesn't contain the expected number of elements.")
        assertContainsSameElements(array: arguments, subset: expectedArguments)
    }

    func testFullConfiguration() {
        var sut = ServerConfig(modelPath: "/path/to/model")
        sut.threads = 4
        sut.modelURL = "http://example.com/model"
        sut.alias = "testModel"
        sut.ctxSize = 4096
        sut.memoryF32 = true
        sut.host = "0.0.0.0"
        sut.port = 8081
        sut.parallel = 2
        sut.embedding = true

        let arguments = sut.toArguments()

        let expectedArguments = [
            "--model", "/path/to/model",
            "--model-url", "http://example.com/model",
            "-a", "testModel",
            "-c", "4096",
            "--threads", "4",
            "-b", "512",
            "--memory-f32",
            "--host", "0.0.0.0",
            "--port", "8081",
            "-np", "2",
            "--embedding"
        ]

        XCTAssertEqual(arguments.count, expectedArguments.count, "Arguments array doesn't contain the expected number of elements.")
        assertContainsSameElements(array: arguments, subset: expectedArguments)
    }

    func testOptionalAndFlagArguments() {
        var sut = ServerConfig(modelPath: "/path/to/model")
        sut.threadsHTTP = nil // This should not appear in the arguments
        sut.mlock = true
        sut.noMmap = true

        let arguments = sut.toArguments()

        XCTAssertTrue(arguments.contains("--mlock"), "Arguments should contain '--mlock'.")
        XCTAssertTrue(arguments.contains("--no-mmap"), "Arguments should contain '--no-mmap'.")
        XCTAssertFalse(arguments.contains("--threads-http"), "Arguments should not contain '--threads-http'.")
    }
}
