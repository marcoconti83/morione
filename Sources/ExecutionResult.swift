//
//  ExecutionResult

//  Morione
//
//  Created by Marco Conti on 19/12/15.
//  Copyright © 2015 com.marco83. All rights reserved.
//

import Foundation

public struct ExecutionResult {
    
    /// Whether the output was captured
    public let didCaptureOutput : Bool
    
    /// The return status of the last subprocess
    public var status: Int32 {
        return pipelineStatuses.last!
    }
    
    /// Return status of all subprocesses in the pipeline
    public let pipelineStatuses : [Int32]
    
    /// The output of the subprocess. Empty string if no output was produced or not captured
    public let output: String
    
    /// The error output of the last subprocess. Empty string if no error output was produced or not captured
    public var errors : String {
        return pipelineErrors?.last ?? ""
    }
    
    /// The error output of all subprocesses in the pipeline. Empty string if no error output was produced or not captured
    public let pipelineErrors : [String]?
    
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
    
    /// An execution result where no output was captured
    init(pipelineStatuses: [Int32]) {
        self.pipelineStatuses = pipelineStatuses
        self.didCaptureOutput = false
        self.pipelineErrors = nil
        self.output = ""
    }
    
    /// An execution result where output was captured
    init(pipelineStatuses: [Int32], pipelineErrors : [String], output : String) {
        self.pipelineStatuses = pipelineStatuses
        self.pipelineErrors = pipelineErrors
        self.output = output
        self.didCaptureOutput = true
    }
}