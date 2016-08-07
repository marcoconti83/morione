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

extension NSTask {
    
    /// Launches a task, captures any objective-c exception and relaunches it as Swift error
    private func launchCapturingExceptions() throws {
        if let exception = MCMExecuteWithPossibleExceptionInBlock({
            self.launch()
        }) {
            let reason = exception.reason ?? "unknown error"
            throw SubprocessError.Error(reason: reason)
        }
    }
}

/// A pipeline of tasks, connected in a cascade pattern with pipes
struct TaskPipeline {
    
    /// List of tasks in the pipeline
    let tasks: [NSTask]
    
    /// Output pipe
    let outputPipe: NSPipe?
    
    /// Whether the pipeline should capture output to stdErr and stdOut
    let captureOutput : Bool
    
    /// Adds a task to the head of the pipeline, that is, the task will provide the input
    /// for the first task currently on the head of the pipeline
    func addToHead(task: NSTask) -> TaskPipeline {
        guard let firstTask = tasks.first else {
            fatalError("Expecting at least one task")
        }
        let inoutPipe = NSPipe()
        firstTask.standardInput = inoutPipe
        task.standardOutput = inoutPipe
        
        var errorPipe : NSPipe?
        if self.captureOutput {
            errorPipe = NSPipe()
            task.standardError = errorPipe
        }
        return TaskPipeline(tasks: [task] + self.tasks, outputPipe: self.outputPipe, captureOutput: self.captureOutput)
    }
    
    /// Start all tasks in the pipeline, then wait for them to complete
    /// - returns: the return status of the last process in the pipe, or nil if there was an error
    func run() -> ExecutionResult? {
        
        let runTasks = launchAndReturnNotFailedTasks()
        if runTasks.count != self.tasks.count {
            // dropped a task? it's because it failed to start, so error
            return nil
        }
        runTasks.forEach { $0.waitUntilExit() }
        
        // exit status
        let exitStatuses = runTasks.map { $0.terminationStatus }
        guard captureOutput else {
            return ExecutionResult(pipelineStatuses: exitStatuses)
        }
        
        // output
        let errorOutput = runTasks.map { task -> String in
            guard let errorPipe = task.standardError as? NSPipe else { return "" }
            let readData = errorPipe.fileHandleForReading.readDataToEndOfFile()
            return String(data: readData, encoding: NSUTF8StringEncoding)!
        }
        let output = String(data: self.outputPipe!.fileHandleForReading.readDataToEndOfFile(), encoding: NSUTF8StringEncoding)!
        return ExecutionResult(pipelineStatuses: exitStatuses, pipelineErrors: errorOutput, output: output)
    }
    
    /// Run all tasks and return the tasks that did not fail to launch
    private func launchAndReturnNotFailedTasks() -> [NSTask] {
        return self.tasks.flatMap { task -> NSTask? in
            do {
                try task.launchCapturingExceptions()
                return task
            } catch {
                return nil
            }
        }
    }
    
    init(task: NSTask, captureOutput: Bool) {
        self.tasks = [task]
        self.captureOutput = captureOutput
        if captureOutput {
            self.outputPipe = NSPipe()
            task.standardOutput = self.outputPipe
            let errorPipe = NSPipe()
            task.standardError = errorPipe
        } else {
            self.outputPipe = nil
        }
    }
    
    private init(tasks: [NSTask], outputPipe: NSPipe?, captureOutput: Bool) {
        self.tasks = tasks
        self.outputPipe = outputPipe
        self.captureOutput = captureOutput
    }
}
