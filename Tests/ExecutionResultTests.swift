//
//  ExecutionResultTests.swift
//  Morione
//
//  Created by Marco Conti on 19/12/15.
//  Copyright © 2015 com.marco83. All rights reserved.
//

import XCTest
import Morione

class ExecutionResultTests: XCTestCase {

    func testThatItInitializesStatusAndOutput() {
        
        // given
        let sut = ExecutionResult(status: 23, output: "foo", errors: "bar")
        
        // then
        XCTAssertEqual(sut.status, 23)
        XCTAssertEqual(sut.output, "foo")
        XCTAssertEqual(sut.errors, "bar")
    }
    
    func testThatItSplitsOutputInLines() {
        
        // given
        let sut = ExecutionResult(status: 23, output: "a\nb\nc", errors: "1\n2\n3")
        
        // then
        XCTAssertEqual(sut.status, 23)
        XCTAssertEqual(sut.outputLines, ["a","b","c"])
        XCTAssertEqual(sut.errorsLines, ["1","2","3"])
    }

}
