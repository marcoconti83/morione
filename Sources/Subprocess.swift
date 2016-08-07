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

/**
A definition of a subprocess to be invoked.
 The subprocess can be defined once and executed multiple times (using the `execute` or `output` method), each
 execution will spawn a separate process
*/
public class Subprocess {
    
    /// The path to the executable
    let executablePath : String
    
    /// Arguments to pass to the executable
    let arguments : [String]
    
    /// Working directory for the executable
    let workingDirectory : String
    
    /// Process to pipe to, if any
    let pipeDestination : Subprocess?
    
    /**
     Returns a subprocess ready to be executed
     - parameter executablePath: the path to the executable. The validity of the path won't be verified until the subprocess is executed
     - parameter arguments: the list of arguments. If not specified, no argument will be passed
     - parameter workingDirectiry: the working directory. If not specified, the current working directory will be used
    */
    public convenience init(
        executablePath: String,
        arguments: [String] = [],
        workingDirectory: String = "."
        ) {
        self.init(executablePath: executablePath,
                  arguments: arguments,
                  workingDirectory: workingDirectory,
                  pipeTo: nil)
    }
    
    private init(
        executablePath: String,
        arguments: [String] = [],
        workingDirectory: String = ".",
        pipeTo: Subprocess?
        ) {
        self.executablePath = executablePath
        self.arguments = arguments
        self.workingDirectory = workingDirectory
        self.pipeDestination = pipeTo
    }
    
    /**
     Returns a subprocess ready to be executed
     - SeeAlso: init(executablePath:arguments:workingDirectory)
     */
    public convenience init(
        _ executablePath: String,
        _ arguments: String...,
        workingDirectory: String = ".") {
            self.init(executablePath: executablePath, arguments: arguments, workingDirectory: workingDirectory, pipeTo: nil)
    }
}

// MARK: - Public API
extension Subprocess {

    /**
     Executes the subprocess and wait for completition, returning the exit status
     - returns: the execution result, including the output, or nil if it was not possible to execute the process
     */
    public func run() -> Int32? {
        return self.execute(false)?.status
    }
    
    /**
     Executes the subprocess and wait for completion, returning the output
     - returns: the execution result, including the output, or nil if it was not possible to execute the process
     - warning: the entire output will be stored in a String in memory
     */
    public func runOutput() -> ExecutionResult? {
        return self.execute(true)
    }
}

// MARK: - Piping
extension Subprocess {
    
    /// Pipes the output to this process to another process.
    /// Will return a new subprocess, you should execute that subprocess to
    /// run the entire pipe
    public func pipe(to destination: Subprocess) -> Subprocess {
        let downstreamProcess : Subprocess
        if let existingPipe = self.pipeDestination {
            downstreamProcess = existingPipe.pipe(to: destination)
        } else {
            downstreamProcess = destination
        }
        return Subprocess(executablePath: self.executablePath, arguments: self.arguments, workingDirectory: self.workingDirectory, pipeTo: downstreamProcess)
    }
}

public func | (lhs: Subprocess, rhs: Subprocess) -> Subprocess {
    return lhs.pipe(to: rhs)
}

public func | (lhs: String, rhs: String) -> String {
    return "(\(lhs)\(rhs))"
}

// MARK: - Process execution
public enum SubprocessError : ErrorType {
    case Error(reason: String)
}

extension Subprocess {
    
    /// Returns the task to execute
    private func task() -> NSTask {
        let task = NSTask()
        task.launchPath = self.executablePath
        task.arguments = self.arguments
        task.currentDirectoryPath = self.workingDirectory
        return task
    }
    
    /// Returns the task pipeline for all the downstream processes
    private func buildPipeline(captureOutput: Bool, input: AnyObject? = nil) -> TaskPipeline {
        let task = self.task()
        
        if let inPipe = input {
            task.standardInput = inPipe
        }
        
        if let downstreamProcess = self.pipeDestination {
            let downstreamPipeline = downstreamProcess.buildPipeline(captureOutput, input: task.standardOutput)
            return downstreamPipeline.addToHead(task)
        }
        return TaskPipeline(task: task, captureOutput: captureOutput)
    }
    
    /// Executes the pipeline and returns the return status of the last command of the pipeline
    private func execute(captureOutput: Bool) -> ExecutionResult? {
        return buildPipeline(captureOutput).run()
    }
}
