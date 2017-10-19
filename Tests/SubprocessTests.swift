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

class SubprocessTests: XCTestCase {
}

// MARK: - Return code
extension SubprocessTests {
    
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
        let noFile = nonExistingFileName()
        let sut = Subprocess("/bin/ls", noFile)
        
        // when
        let result = sut.run()
        
        // then
        XCTAssertEqual(result, 1)
    }
    
    func testThatItReturnNilIfTheExecutableDoesNotExist() {
        
        // given
        let noFile = nonExistingFileName()
        let sut = Subprocess(noFile)
        
        // when
        let result = sut.run()
        
        // then
        XCTAssertNil(result)
    }
    
    func testThatItReturnNilIfTheExecutableIsNotExecutable() {
        
        // given
        let nonExecutable = nonExecutableFileName()
        let sut = Subprocess(nonExecutable)
        
        // when
        let result = sut.run()
        
        // then
        XCTAssertNil(result)
    }
}

// MARK: - Input
extension SubprocessTests {
    
    func testThatItPassesTheExactArguments() {
        
        // given
        let binary = NSBundle(forClass: self.dynamicType).URLForResource("wcarg", withExtension: ".sh")!.path!
        let sut = Subprocess(binary, "1$23")
        
        // when
        let result = sut.runOutput()
        
        // then
        XCTAssertEqual(result?.output, "49 36 50 51\n")
    }
}




// MARK: - Output
extension SubprocessTests {
    
    func testThatItReturnsTheOutputOfEcho() {
        
        // given
        let sut = Subprocess("/bin/echo", "Foo\no")
        
        // when
        let result = sut.execute(true)
        
        // then
        XCTAssertEqual(result!.status, 0)
        XCTAssertEqual(result!.output, "Foo\no\n")
        XCTAssertEqual(result!.errors, "")
    }

    func testThatItReturnsTheErrorOutputOfLS() {
        
        // given
        let noFile = nonExistingFileName()
        let sut = Subprocess("/bin/ls", noFile)
        
        // when
        let result = sut.execute(true)
        
        // then
        XCTAssertEqual(result!.status, 1)
        XCTAssertEqual(result!.output, "")
        XCTAssertEqual(result!.errors, "ls: \(noFile): No such file or directory\n")
    }
    
    func testThatItReturnNilOutputIfTheExecutableDoesNotExist() {
        
        // given
        let noFile = nonExistingFileName()
        let sut = Subprocess(noFile )
        
        // when
        let result = sut.execute()
        
        // then
        XCTAssertNil(result)
    }
    
    func testThatItReturnNilOutputIfTheExecutableIsNotExecutable() {
        
        // given
        let nonExecutable = nonExecutableFileName()
        let sut = Subprocess(nonExecutable)
        
        // when
        let result = sut.execute()
        
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
        XCTAssertEqual(sut.output(), expectedDirectory+"\n")
    }
    
    func testThatItReturnsNilIfTheWorkingDirectoryDoesNotExist() {
        
        // given
        let nonExistingPath = nonExistingFileName()
        
        // when
        let sut = Subprocess("/bin/pwd", workingDirectory: nonExistingPath)

        // then
        XCTAssertNil(sut.output())
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
        let result = Subprocess.run("/bin/ls", nonExistingFileName())
        
        // then
        XCTAssertNotEqual(result, 0)
    }
    
    func testThatItSuccessfullyRunOrDie() {
        
        // when
        Subprocess.runOrDie("/bin/ls")
        
        // then: not crashing
    }
}

// MARK: - Description
extension SubprocessTests {
    
    func testThatItDescribesExecutable() {
        
        // given
        let path = "/bin/ls"
        let sut = Subprocess(path)
        
        // then
        XCTAssertEqual(sut.description, path)
    }
    
    func testThatItDescribesExecutableAndArguments() {
        
        // given
        let path = "/bin/ls"
        let sut = Subprocess(path, "-l", "foo")
        
        // then
        XCTAssertEqual(sut.description, "\(path) -l foo")
    }
    
    func testThatItDescribesExecutableAndArgumentsWithSpace() {
        
        // given
        let path = "/bin/ls"
        let sut = Subprocess(path, "-l", "My Documents")
        
        // then
        XCTAssertEqual(sut.description, "\(path) -l My\\ Documents")
    }
    
    func testThatItDescribesPipe() {
        
        // given
        let sut1 = Subprocess("/bin/echo", "That's it")
        let sut2 = Subprocess("/usr/bin/grep", "it")
        let sut3 = Subprocess("/usr/bin/sed", "s/it/not it/")
        
        // when
        let sut = sut1 | sut2 | sut3
        
        // then
        XCTAssertEqual(sut.description, "\(sut1.description) | \(sut2.description) | \(sut3.description)")
    }
}
