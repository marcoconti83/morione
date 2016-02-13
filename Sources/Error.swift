//
//  Error.swift
//  Morione
//
//  Created by Marco Conti on 13/02/16.
//  Copyright © 2016 com.marco83. All rights reserved.
//

import Foundation

struct Error {
    
    /// Prints to console the arguments and exits with status 1
    @noreturn static func die(arguments: Any...) {
        let output = "ERROR: " + arguments.reduce("") { $0 + "\($1) " }
        let trimOutput = output.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) + "\n"
        let stderr = NSFileHandle.fileHandleWithStandardError()
        stderr.writeData(trimOutput.dataUsingEncoding(NSUTF8StringEncoding)!)
        exit(1)
    }
}