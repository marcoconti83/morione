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


// MARK: - Compact API
extension Subprocess {
    
    /**
     Executes a subprocess and wait for completion, returning the output. If there is an error in creating the task,
     it immediately exits the process with status 1
     - returns: the output as a String
     - note: in case there is any error in executing the process or creating the task, it will halt execution. Use
     the constructor and `output` instance method for a more graceful error handling
     */
    public static func output(
        executablePath: String,
        _ arguments: String...,
        workingDirectory: String = ".") -> String {
        
        let process = Subprocess.init(executablePath: executablePath, arguments: arguments, workingDirectory: workingDirectory)
        guard let result = process.execute(captureOutput: true) else {
            Error.die("Can't execute \"\(process)\"")
        }
        if result.status != 0 {
            let errorLines = result.errors == "" ? "" : "\n" + result.errors
            Error.die("Process \"\(process)\" returned status \(result.status)", errorLines)
        }
        return result.output
    }
    
    /**
     Executes a subprocess and wait for completion, returning the execution result. If there is an error in creating the task,
     it immediately exits the process with status 1
     - returns: the execution result
     - note: in case there is any error in executing the process or creating the task, it will halt execution. Use
     the constructor and `execute` instance method for a more graceful error handling
     */
    public static func execute(
        executablePath: String,
        _ arguments: String...,
        workingDirectory: String = ".") -> ExecutionResult {
        
        let process = Subprocess.init(executablePath: executablePath, arguments: arguments, workingDirectory: workingDirectory)
        guard let result = process.execute(captureOutput: true) else {
            Error.die("Can't execute \"\(process)\"")
        }
        return result
    }
    
    /**
     Executes a subprocess and wait for completion, returning the output as an array of lines. If there is an error
     in creating or executing the task, it immediately exits the process with status 1
     - returns: the output as a String
     - note: in case there is any error in executing the process or creating the task, it will halt execution. Use
     the constructor and `output` instance method for a more graceful error handling
     */
    public static func outputLines(
        executablePath: String,
        _ arguments: String...,
        workingDirectory: String = ".") -> [String] {
        
        let process = Subprocess.init(executablePath: executablePath, arguments: arguments, workingDirectory: workingDirectory)
        guard let result = process.execute(captureOutput: true) else {
            Error.die("Can't execute \"\(process)\"")
        }
        if result.status != 0 {
            let errorLines = result.errors == "" ? "" : "\n" + result.errors
            Error.die("Process \"\(process)\" returned status \(result.status)", errorLines)
        }
        return result.outputLines
    }
    
    /**
     Executes a subprocess and wait for completion, returning the exit status. If there is an error in creating the task,
     it immediately exits the process with status 1
     - returns: the output as a String
     - note: in case there is any error in launching the process or creating the task, it will halt execution. Use
     the constructor and the `run` instance method for a more graceful error handling
     */
    public static func run(
        executablePath: String,
        _ arguments: String...,
        workingDirectory: String = ".") -> Int32 {
        
        let process = Subprocess.init(executablePath: executablePath, arguments: arguments, workingDirectory: workingDirectory)
        guard let result = process.run() else {
            Error.die("Can't execute \"\(process)\"")
        }
        return result
    }
    
    /**
     Executes a subprocess and wait for completion. If there is an error in creating the task, or if the tasks 
     returns an exit status other than 0, it immediately exits the process with status 1
     - note: in case there is any error in launching the process or creating the task, or if the task exists with a exit status other than 0, it will halt execution. Use
     the constructor and `run` instance method for a more graceful error handling
     */
    public static func runOrDie(
        executablePath: String,
        _ arguments: String...,
        workingDirectory: String = ".") {
        
        let process =  Subprocess.init(executablePath: executablePath, arguments: arguments, workingDirectory: workingDirectory)
        guard let result = process.run() else {
            Error.die("Can't execute \"\(process)\"")
        }
        if result != 0 {
            Error.die("Process \"\(process)\" returned status \(result)")
        }
    }
}
