//
//  String+OutputParsing.swift
//  Morione
//
//  Created by Marco Conti on 19/12/15.
//  Copyright © 2015 com.marco83. All rights reserved.
//

import Foundation

extension String {
    
    /// Returns an array of string obtained splitting self at each newline ("\n").
    /// If the last character is a newline, it will be ignored (no empty string
    /// will be appended at the end of the array)
    public func splitByNewline() -> [String] {
        return self.characters.split { $0 == "\n" }.map(String.init)
    }
    
    /// Returns an array of string obtained splitting self at each space, newline or TAB character
    public func splitByWhitespace() -> [String] {
        let whitespaces = Set<Character>([" ", "\n", "\t"])
        return self.characters.split { whitespaces.contains($0) }.map(String.init)
    }
}