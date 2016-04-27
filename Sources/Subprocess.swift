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

// MARK: - Compact API
extension Subprocess {
    
    /**
     Executes a subprocess and wait for completion, returning the output. If there is an error in creating the task, 
     it immediately exits the process with status 1
     - returns: the output as a String
     - note: in case there is any error in executing the process or creating the task, it will halt execution. Use 
     the constructor and `runOutput` method for a more graceful error handling
    */
    public static func output(
        executablePath: String,
        _ arguments: String...,
        workingDirectory: String = ".") -> String {
        
            guard let result = Subprocess.init(executablePath: executablePath, arguments: arguments, workingDirectory: workingDirectory).runOutput() else {
                Error.die("Can't execute \(executablePath) \(arguments.joinWithSeparator(" "))")
            }
            if result.status != 0 {
                let errorLines = result.errors == "" ? "" : "\n" + result.errors
                Error.die("Process \(executablePath) returned non-zero status", errorLines)
            }
            return result.output
    }
    
    /**
     Executes a subprocess and wait for completion, returning the output as an array of lines. If there is an error
     in creating or executing the task, it immediately exits the process with status 1
     - returns: the output as a String
     - note: in case there is any error in executing the process or creating the task, it will halt execution. Use
     the constructor and `runOutput` method for a more graceful error handling
     */
    public static func outputLines(
        executablePath: String,
        _ arguments: String...,
        workingDirectory: String = ".") -> [String] {
            
            guard let result = Subprocess.init(executablePath: executablePath, arguments: arguments, workingDirectory: workingDirectory).runOutput() else {
                Error.die("Can't execute \(executablePath) \(arguments.joinWithSeparator(" "))")
            }
            if result.status != 0 {
                let errorLines = result.errors == "" ? "" : "\n" + result.errors
                Error.die("Process \(executablePath) returned non-zero status", errorLines)
            }
            return result.outputLines
    }
    
    /**
     Executes a subprocess and wait for completion, returning the exit status. If there is an error in creating the task,
      it immediately exits the process with status 1
     - returns: the output as a String
     - note: in case there is any error in executing the process or creating the task, it will halt execution. Use
     the constructor and `run` method for a more graceful error handling
     */
    public static func run(
        executablePath: String,
        _ arguments: String...,
        workingDirectory: String = ".") -> Int32 {
            
            guard let result = Subprocess.init(executablePath: executablePath, arguments: arguments, workingDirectory: workingDirectory).runOutput() else {
                Error.die("Can't execute \(executablePath) \(arguments.joinWithSeparator(" "))")
            }
            return result.status
    }

    /**
     Executes a subprocess and wait for completion. If there is an error in creating the task, or if the tasks returns an exit status other than 0,
     it immediately exits the process with status 1
     - note: in case there is any error in executing the process or creating the task, or if the task exists with a exit status other than 0, it will halt execution. Use
     the constructor and `run` method for a more graceful error handling
     */
    public static func runOrDie(
        executablePath: String,
        _ arguments: String...,
        workingDirectory: String = ".") {
        
        guard let result = Subprocess.init(executablePath: executablePath, arguments: arguments, workingDirectory: workingDirectory).run() else {
            Error.die("Can't execute \(executablePath) \(arguments.joinWithSeparator(" "))")
        }
        if result != 0 {
            Error.die("Process \(executablePath) returned non-zero status")
        }
    }
}