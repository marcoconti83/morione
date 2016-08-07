//
//  ExecutionResultTests.swift
//  Morione
//
//  Created by Marco Conti on 19/12/15.
//  Copyright © 2015 com.marco83. All rights reserved.
//

import XCTest
@testable import Morione

class ExecutionResultTests: XCTestCase {

    func testThatItReturnsLastStatusWithMultipleProcesses() {
        
        // given
        let sut = ExecutionResult(pipelineStatuses: [3,1,2])
        
        // then
        XCTAssertEqual(sut.status, 2)
    }
    
    func testThatItReturnsLastStatus() {
        
        // given
        let sut = ExecutionResult(pipelineStatuses: [2])
        
        // then
        XCTAssertEqual(sut.status, 2)
    }
    
    func testThatItReturnsLastErrorsWithMultipleProcesses() {
        
        // given
        let sut = ExecutionResult(pipelineStatuses: [0,1], pipelineErrors: ["a","b"], output: "c")
        
        // then
        XCTAssertEqual(sut.errors, "b")
    }
    
    func testThatItReturnsLastErrors() {
        
        // given
        let sut = ExecutionResult(pipelineStatuses: [1], pipelineErrors: ["b"], output: "c")
        
        // then
        XCTAssertEqual(sut.errors, "b")
    }
    
    func testThatItReturnsOutput() {
        
        // given
        let sut = ExecutionResult(pipelineStatuses: [1], pipelineErrors: ["b"], output: "c")
        
        // then
        XCTAssertEqual(sut.output, "c")
    }
    
    func testThatItReturnsOutputWithMultipleLines() {
        
        // given
        let sut = ExecutionResult(pipelineStatuses: [1], pipelineErrors: ["b"], output: "c1\nc2")
        
        // then
        XCTAssertEqual(sut.outputLines, ["c1","c2"])
    }
    
    func testThatItReturnsNonNilValuesWhenItHasOutput() {
        
        // given
        let errors = ["a","b"]
    
        // when
        let sut = ExecutionResult(pipelineStatuses: [4,1], pipelineErrors: ["a","b"], output: "dd")
        
        // then
        XCTAssertEqual(sut.pipelineStatuses, [4,1])
        if let pipelineErrors = sut.pipelineErrors {
            XCTAssertEqual(pipelineErrors, errors)
        } else {
            XCTFail()
        }
        XCTAssertTrue(sut.didCaptureOutput)
        XCTAssertEqual(sut.output, "dd")
    }
    
    func testThatItReturnsNilValuesWhenItHasNoOutput() {
        
        // given
        let sut = ExecutionResult(pipelineStatuses: [4,1])
        
        // then
        XCTAssertEqual(sut.pipelineStatuses, [4,1])
        XCTAssertNil(sut.pipelineErrors)
        XCTAssertFalse(sut.didCaptureOutput)
        XCTAssertEqual(sut.output, "")
    }

}
