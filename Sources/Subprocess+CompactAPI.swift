//
//  Subprocess+CompactAPI.swift
//  Morione
//
//  Created by Marco Conti on 02/08/16.
//  Copyright © 2016 com.marco83. All rights reserved.
//

import Foundation


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
            Error.die("Process \(executablePath) returned non-zero status", errorLines, "\n",
                      "with arguments: \(arguments.joinWithSeparator(" "))")
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
            Error.die("Process \(executablePath) returned non-zero status", errorLines, "\n",
                      "with arguments: \(arguments.joinWithSeparator(" "))")
        }
        return result.outputLines
    }
    
    /**
     Executes a subprocess and wait for completion, returning the exit status. If there is an error in creating the task,
     it immediately exits the process with status 1
     - returns: the output as a String
     - note: in case there is any error in launching the process or creating the task, it will halt execution. Use
     the constructor and `run` method for a more graceful error handling
     */
    public static func run(
        executablePath: String,
        _ arguments: String...,
        workingDirectory: String = ".") -> Int32 {
        
        guard let result = Subprocess.init(executablePath: executablePath, arguments: arguments, workingDirectory: workingDirectory).run() else {
            Error.die("Can't execute \(executablePath) \(arguments.joinWithSeparator(" "))")
        }
        return result
    }
    
    /**
     Executes a subprocess and wait for completion. If there is an error in creating the task, or if the tasks returns an exit status other than 0,
     it immediately exits the process with status 1
     - note: in case there is any error in launching the process or creating the task, or if the task exists with a exit status other than 0, it will halt execution. Use
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
            Error.die("Process \(executablePath) returned non-zero status\n",
                      "with arguments: \(arguments.joinWithSeparator(" "))")
        }
    }
}