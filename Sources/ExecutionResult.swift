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