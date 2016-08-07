//
//  PipingTests.swift
//  Morione
//
//  Created by Marco Conti on 02/08/16.
//  Copyright © 2016 com.marco83. All rights reserved.
//

import Foundation
import Morione
import XCTest

class PipingTests : XCTestCase {

    func testThatItPipesTwoProcesses() {
        
        // given
        let text = "This text is not that long"
        let procLs = Subprocess("/bin/echo", "-n", text)
        let procWc = Subprocess("/usr/bin/wc")
        
        // when
        let piped = procLs | procWc
        let output = piped.runOutput()!.output
        
        // then
        XCTAssertEqual(output, "       0       6      26\n")
    }
    
    func testThatItPipesFourProcesses() {
        
        // given
        let text = "This text is not that long"
        let procLs = Subprocess("/bin/echo", "-n", text)
        let procSed1 = Subprocess("/usr/bin/sed", "s/long/short/")
        let procSed2 = Subprocess("/usr/bin/sed", "s/ that//")
        let procSed3 = Subprocess("/usr/bin/sed", "s/ not//")
        
        // when
        let piped = procLs | procSed1 | procSed2 | procSed3
        let output = piped.runOutput()!.output
        
        // then
        XCTAssertEqual(output, "This text is short\n")
    }
    
    func testThatItReturnsTheOutputOfTheLast() {
        
        // given
        let proc1 = Subprocess("/bin/echo", "a")
        let proc2 = Subprocess("/bin/echo", "b")
        let proc3 = Subprocess("/bin/echo", "c")
        
        // when
        let piped = proc1 | proc2 | proc3
        let output = piped.runOutput()!.output
        
        // then 
        XCTAssertEqual(output, "c\n")
    }
    
    func testThatItReturnsNilIfOneProcessInThePipeDoesNotExists() {
        // given
        let proc1 = Subprocess("/bin/echo", "a")
        let proc2 = Subprocess("/foo", "b")
        let proc3 = Subprocess("/bin/echo", "c")
        
        // when
        let piped = proc1 | proc2 | proc3
        let result = piped.runOutput()
        
        // then
        XCTAssertNil(result)
    }
    
    func testThatItReturnsTheExitStatusOfAllProcesses() {
        // given
        let proc1 = Subprocess("/bin/echo", "a")
        let proc2 = Subprocess("/bin/ls", nonExistingFileName())
        let proc3 = Subprocess("/bin/echo", "c")
        let proc4 = Subprocess("/bin/ls", nonExistingFileName())
        
        // when
        let piped = proc1 | proc2 | proc3 | proc4
        let statuses = piped.runOutput()!.pipelineStatuses
        
        // then
        XCTAssertEqual(statuses, [0,1,0,1])
    }
    
    func testThatItReturnsTheErrorsOfAllProcesses() {
        // given
        let name1 = nonExistingFileName()
        let name2 = nonExistingFileName()
        let proc1 = Subprocess("/bin/echo", "a")
        let proc2 = Subprocess("/bin/ls", name1)
        let proc3 = Subprocess("/bin/echo", "c")
        let proc4 = Subprocess("/bin/ls", name2)
        
        // when
        let piped = proc1 | proc2 | proc3 | proc4
        let errors = piped.runOutput()!.pipelineErrors!
        
        // then
        XCTAssertEqual(errors[0], "")
        XCTAssertNotEqual(errors[1], "")
        XCTAssertEqual(errors[2], "")
        XCTAssertNotEqual(errors[3], "")
    }
    
    
}