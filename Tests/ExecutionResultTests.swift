//
//Copyright (c) Marco Conti 2016
//
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

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
