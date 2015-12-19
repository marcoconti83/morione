//
//  ExecutionResult

//  Morione
//
//  Created by Marco Conti on 19/12/15.
//  Copyright © 2015 com.marco83. All rights reserved.
//

import Foundation

public struct ExecutionResult {
    
    /// The return status of the executable
    public let status: Int32
    
    /// The output of the executable. Empty string if no output was produced
    public let output: String
    
    /// The error output of the executable. Empty string if no error output was produced
    public let errors : String
    
    /// The output, split by newline
    /// - SeeAlso: `output`
    public var outputLines : [String] {
        return self.output.splitByNewline()
    }

    /// The error output, split by newline
    /// - SeeAlso: `output`
    public var errorsLines : [String] {
        return self.errors.splitByNewline()
    }
    
    public init(status: Int32, output: String, errors: String)
    {
        self.status = status
        self.output = output
        self.errors = errors
    }
}