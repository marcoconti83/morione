//
//  SubprocessTests.swift
//  Morione
//
//  Created by Marco Conti on 19/12/15.
//  Copyright © 2015 com.marco83. All rights reserved.
//

import XCTest
import Morione

class SubprocessTests: XCTestCase {
}

// MARK: - Return code
extension SubprocessTests {
    
    /// Returns a file path that does not to exists at the moment.
    /// It is not guaranteed that it won't exists in future, but the chances
    /// are extremely low
    private func nonExistingFileName() -> String {
        while(true) {
            let uuidString = "/\(NSUUID().hash)/\(NSUUID().hash)"
            if !NSFileManager.defaultManager().fileExistsAtPath(uuidString) {
                return uuidString
            }
        }
    }
    
    /// Returns a file path to a file that exists, but it's not executable
    /// It is not guaranteed that it won't be executable in future, but it's unlikely
    private func nonExecutableFileName() -> String {
        let nonExecutable = NSBundle(forClass: SubprocessTests.self).pathForResource("file", ofType: "txt")
        assert(NSFileManager.defaultManager().fileExistsAtPath(nonExecutable!))
        assert(!NSFileManager.defaultManager().isExecutableFileAtPath(nonExecutable!))
        return nonExecutable!
    }
    
    func testThatItReturnsTheSuccessfulExitCodeOfEcho() {
        
        // given
        let sut = Subprocess("/bin/echo", "Foo", "Bar")
        
        // when
        let result = sut.run()
        
        // then
        XCTAssertEqual(result, 0)
    }
    
    func testThatItReturnsTheInsuccessfulExitCodeOfLS() {
        
        // given
        let nonExistingFileName = self.nonExistingFileName()
        let sut = Subprocess("/bin/ls", nonExistingFileName)
        
        // when
        let result = sut.run()
        
        // then
        XCTAssertEqual(result, 1)
    }
    
    func testThatItReturnNilIfTheExecutableDoesNotExist() {
        
        // given
        let nonExistingFileName = self.nonExistingFileName()
        let sut = Subprocess(nonExistingFileName)
        
        // when
        let result = sut.run()
        
        // then
        XCTAssertNil(result)
    }
    
    func testThatItReturnNilIfTheExecutableIsNotExecutable() {
        
        // given
        let nonExecutable = self.nonExecutableFileName()
        let sut = Subprocess(nonExecutable)
        
        // when
        let result = sut.run()
        
        // then
        XCTAssertNil(result)
    }
}

// MARK: - Output
extension SubprocessTests {
    
    func testThatItReturnsTheOutputOfEcho() {
        
        // given
        let sut = Subprocess("/bin/echo", "Foo\no")
        
        // when
        let result = sut.runOutput()
        
        // then
        XCTAssertEqual(result!.status, 0)
        XCTAssertEqual(result!.output, "Foo\no\n")
        XCTAssertEqual(result!.errors, "")
    }

    func testThatItReturnsTheErrorOutputOfLS() {
        
        // given
        let nonExistingFileName = self.nonExistingFileName()
        let sut = Subprocess("/bin/ls", nonExistingFileName)
        
        // when
        let result = sut.runOutput()
        
        // then
        XCTAssertEqual(result!.status, 1)
        XCTAssertEqual(result!.output, "")
        XCTAssertEqual(result!.errors, "ls: \(nonExistingFileName): No such file or directory\n")
    }
    
    func testThatItReturnNilOutputIfTheExecutableDoesNotExist() {
        
        // given
        let nonExistingFileName = self.nonExistingFileName()
        let sut = Subprocess(nonExistingFileName)
        
        // when
        let result = sut.runOutput()
        
        // then
        XCTAssertNil(result)
    }
    
    func testThatItReturnNilOutputIfTheExecutableIsNotExecutable() {
        
        // given
        let nonExecutable = self.nonExecutableFileName()
        let sut = Subprocess(nonExecutable)
        
        // when
        let result = sut.runOutput()
        
        // then
        XCTAssertNil(result)
    }
}

// MARK: - Working directory
extension SubprocessTests {
    
    func testThatItRunsInTheGivenWorkingDirectory() {
        
        // given
        let expectedDirectory = "/usr/lib"
    
        // when
        let sut = Subprocess("/bin/pwd", workingDirectory: expectedDirectory)
        
        // then
        XCTAssertEqual(sut.runOutput()!.output, expectedDirectory+"\n")
    }
    
    func testThatItReturnsNilIfTheWorkingDirectoryDoesNotExist() {
        
        // given
        let nonExistingPath = self.nonExistingFileName()
        
        // when
        let sut = Subprocess("/bin/pwd", workingDirectory: nonExistingPath)

        // then
        XCTAssertNil(sut.runOutput())
    }
}


// MARK: - Compact API
extension SubprocessTests {
    
    func testThatItReturnsTheOutputOfEchoWithCompactAPI() {
        
        // when
        let result = Subprocess.output("/bin/echo", "Foo\no")
        
        // then
        XCTAssertEqual(result, "Foo\no\n")
    }
    
    func testThatItReturnsTheOutputLinesOfEchoWithCompactAPI() {
        
        // when
        let result = Subprocess.outputLines("/bin/echo", "Foo\no")
        
        // then
        XCTAssertEqual(result, ["Foo","o"])
    }
    
    func testThatItReturnsTheExitStatusWithCompactAPI() {
        
        // when
        let result = Subprocess.run("/bin/echo", "Foo\no")
        
        // then
        XCTAssertEqual(result, 0)
    }

    func testThatItReturnsTheExitStatusOnErrorWithCompactAPI() {
        
        // when
        let result = Subprocess.run("/bin/ls", self.nonExistingFileName())
        
        // then
        XCTAssertNotEqual(result, 0)
    }
}
