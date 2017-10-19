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
import Morione

class StringOutputParsingTests: XCTestCase {

    func testThatItSplitsByNewLine() {
        
        // given
        let lines = "a\nb\nc\n"
        
        // when
        let result = lines.splitByNewline()
        
        // then
        XCTAssertEqual(result, ["a","b","c"])
    }
    
    func testThatItDoesNotSplitsByNewLineIfThereAreNoNewLines() {
        
        // given
        let lines = "a b\tc"
        
        // when
        let result = lines.splitByNewline()
        
        // then
        XCTAssertEqual(result, [lines])
    }
    
    func testThatItSplitsByWhitespace() {
        
        // given
        let line = "Filesystem\tSize   Used  Avail\t\tCapacity  iused    ifree\n%iused  Mounted on"
        
        // when
        let result = line.splitByWhitespace()
        
        // then
        XCTAssertEqual(result, ["Filesystem","Size","Used","Avail","Capacity","iused","ifree","%iused","Mounted", "on"])
        
    }
}
