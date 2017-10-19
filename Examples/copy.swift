#!/usr/bin/swift -F Carthage/Build/Mac
// Copyright (c) 2015  Marco Conti
//
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
//
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
//
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

// INSTRUCTIONS: 
// before running this script, make sure to run
//      carthage build --no-skip-current
// from the project folder. Then you can invoke it **from the project folder** using
//  ./Examples/<script name>.swift
//

import Morione

let fileThatDoesNotExists = "R9GQap3awTa0eCh10aYD-3QsAZnDrrdwbwgEhVNeB.txt"

// this will return non-zero exit status
let result = Subprocess.run("/bin/cp", fileThatDoesNotExists, "..")
if result != 0 {
	print("Failed to copy")
}
print("But the script continues...")

// this will fail, and abort the script
Subprocess.runOrDie("/bin/cp", fileThatDoesNotExists, "..")

print("You should not see this, as the script should have been aborted")
