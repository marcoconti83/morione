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
        let output = piped.output()!
        
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
        let output = piped.output()!
        
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
        let output = piped.output()!
        
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
        let result = piped.output()
        
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
        let statuses = piped.execute()!.pipelineStatuses
        
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
        let errors = piped.execute(true)!.pipelineErrors!
        
        // then
        XCTAssertEqual(errors[0], "")
        XCTAssertNotEqual(errors[1], "")
        XCTAssertEqual(errors[2], "")
        XCTAssertNotEqual(errors[3], "")
    }
    
    
}