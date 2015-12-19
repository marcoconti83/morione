//
//  StringOutputParsingTests.swift
//  Morione
//
//  Created by Marco Conti on 19/12/15.
//  Copyright © 2015 com.marco83. All rights reserved.
//

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
