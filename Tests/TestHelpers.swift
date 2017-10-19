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

/// Returns a file path that does not to exists at the moment.
/// It is not guaranteed that it won't exists in future, but the chances
/// are extremely low
func nonExistingFileName() -> String {
    while(true) {
        let uuidString = "/\(NSUUID().hash)/\(NSUUID().hash)"
        if !NSFileManager.defaultManager().fileExistsAtPath(uuidString) {
            return uuidString
        }
    }
}

/// Returns a file path to a file that exists, but it's not executable
/// It is not guaranteed that it won't be executable in future, but it's unlikely
func nonExecutableFileName() -> String {
    let nonExecutable = NSBundle(forClass: SubprocessTests.self).pathForResource("file", ofType: "txt")
    assert(NSFileManager.defaultManager().fileExistsAtPath(nonExecutable!))
    assert(!NSFileManager.defaultManager().isExecutableFileAtPath(nonExecutable!))
    return nonExecutable!
}