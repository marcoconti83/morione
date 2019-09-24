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

extension String {
    
    /// Returns an array of string obtained splitting self at each newline ("\n").
    /// If the last character is a newline, it will be ignored (no empty string
    /// will be appended at the end of the array)
    public func splitByNewline() -> [String] {
        return self.split(separator: "\n").map(String.init)
    }
    
    /// Returns an array of string obtained splitting self at each space, newline or TAB character
    public func splitByWhitespace() -> [String] {
        let whitespaces = Set<Character>([" ", "\n", "\t"])
        return self.split { whitespaces.contains($0) }.map(String.init)
    }
}
