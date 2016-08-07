//
//  TestHelpers.swift
//  Morione
//
//  Created by Marco Conti on 07/08/16.
//  Copyright © 2016 com.marco83. All rights reserved.
//

import Foundation

/// Returns a file path that does not to exists at the moment.
/// It is not guaranteed that it won't exists in future, but the chances
/// are extremely low
func nonExistingFileName() -> String {
    while(true) {
        let uuidString = "/\(NSUUID().hash)/\(NSUUID().hash)"
        if !NSFileManager.defaultManager().fileExistsAtPath(uuidString) {
            return uuidString
        }
    }
}

/// Returns a file path to a file that exists, but it's not executable
/// It is not guaranteed that it won't be executable in future, but it's unlikely
func nonExecutableFileName() -> String {
    let nonExecutable = NSBundle(forClass: SubprocessTests.self).pathForResource("file", ofType: "txt")
    assert(NSFileManager.defaultManager().fileExistsAtPath(nonExecutable!))
    assert(!NSFileManager.defaultManager().isExecutableFileAtPath(nonExecutable!))
    return nonExecutable!
}