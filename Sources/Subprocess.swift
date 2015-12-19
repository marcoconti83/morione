//
//  Subprocess.swift
//  Morione
//
//  Created by Marco Conti on 19/12/15.
//  Copyright © 2015 com.marco83. All rights reserved.
//

import Foundation

/**
A definition of a subprocess to be invoked.
 The subprocess can be defined once and executed multiple times (using the `execute` or `output` method), each
 execution will spawn a separate process
*/
public class Subprocess {
    
    /// The path to the executable
    private let executablePath : String
    
    /// Arguments to pass to the executable
    private let arguments : [String]
    
    /// Working directory for the executable
    private let workingDirectory : String
    
    /**
     Returns a subprocess ready to be executed
     - parameter executablePath: the path to the executable. The validity of the path won't be verified until the subprocess is executed
     - parameter arguments: the list of arguments. If not specified, no argument will be passed
     - parameter workingDirectiry: the working directory. If not specified, the current working directory will be used
    */
    public init(
        executablePath: String,
        arguments: [String] = [],
        workingDirectory: String = ".") {
            self.executablePath = executablePath
            self.arguments = arguments
            self.workingDirectory = workingDirectory
    }
    
    /**
     Returns a subprocess ready to be executed
     - SeeAlso: init(executablePath:arguments:workingDirectory)
     */
    public convenience init(
        _ executablePath: String,
        _ arguments: String...,
        workingDirectory: String = ".") {
            self.init(executablePath: executablePath, arguments: arguments, workingDirectory: workingDirectory)
    }
}


// MARK: - Process execution
extension Subprocess {
    
    /// Launches the task and wait for execution to complete. Will print any exception.
    /// - param configure: the block that will be called before executing the task
    /// - returns: nil if the task generated an exception
    private func executeTask(configure: (NSTask)->() = { _ in }) -> NSTask? {
        let task = NSTask()
        task.launchPath = self.executablePath
        task.arguments = self.arguments
        task.currentDirectoryPath = self.workingDirectory
        configure(task)
        
        if let exception = MCMExecuteWithPossibleExceptionInBlock({
            task.launch()
        }) {
            let reason = exception.reason ?? "unknown error"
            print("Can not execute \(self.executablePath): \(reason)")
            return nil
        }
        task.waitUntilExit()
        return task
    }
    
    /**
     Executes the subprocess and wait for completion
     - returns: the exit status of the subprocess, or nil if it was not possible to execute the process
     */
    public func run() -> Int32? {
        if let task = self.executeTask() {
            return task.terminationStatus
        }
        return nil
    }
}

// MARK: - Output
extension Subprocess {
    
    /**
     Executes the subprocess and wait for completion, returning the output
     - returns: the execution result, including the output, or nil if it was not possible to execute the process
     - warning: the entire output will be stored in a String in memory
     */
    public func runOutput() -> ExecutionResult? {
        
        let stdOutPipe = NSPipe()
        let stdErrPipe = NSPipe()
        
        guard let task = self.executeTask({
            $0.standardOutput = stdOutPipe
            $0.standardError = stdErrPipe
        }) else {
            return nil
        }
        
        let stdOutData = stdOutPipe.fileHandleForReading.readDataToEndOfFile()
        let output = NSString(data: stdOutData, encoding: NSUTF8StringEncoding) as! String
        
        let stdErrData = stdErrPipe.fileHandleForReading.readDataToEndOfFile()
        let errors = NSString(data: stdErrData, encoding: NSUTF8StringEncoding) as! String
        
        return ExecutionResult(status: task.terminationStatus, output: output, errors: errors)
    }
}