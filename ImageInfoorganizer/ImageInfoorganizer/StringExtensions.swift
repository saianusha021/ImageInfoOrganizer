//
//  StringExtensions.swift
//  ImageInfoorganizer
//
//  Created by Anusha Meda on 5/11/20.
//  Copyright © 2020 Anusha Meda. All rights reserved.
//

import Foundation

extension String {
    func containsOnlyLetters() -> Bool {
          for chr in self {
             if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                return false
             }
          }
          return true
       }
    func containsPriceExp()-> Bool {
        let range = NSRange(location: 0, length: self.utf16.count)
         let regex = try! NSRegularExpression(pattern: "[0-9]{1}\\.[0-9]{2}")//contains a float value
        if  regex.firstMatch(in: self, options: [], range: range) != nil {
                           return true
        }
        return false
    }
    
    func containsSpecialCharacters()->Bool {
        
        let range = NSRange(location: 0, length: self.utf16.count)
               let regex = try! NSRegularExpression(pattern: "[^a-zA-Z0-9]")
              if  regex.firstMatch(in: self, options: [], range: range) != nil {
                                 return true
              }
              return false
    }
    
    func isInDefaultArray(defArray:[String])-> Bool {
        let word = self.lowercased()
        for str in defArray {
            if(word.contains(str)) {
              return true
            }
        }
        return false
    }
    
    func removeSpecialCharsNDigits() -> String {
        let okayChars =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ")
        return self.filter {okayChars.contains($0)}
    }
    func isAllSpecialCharacters()->Bool {
        if self.removeSpecialCharsNDigits().count == 0{
         return true
        }
        return false
    }
    
    func index(from: Int) -> Index {
           return self.index(startIndex, offsetBy: from)
       }

       func substring(from: Int) -> String {
           let fromIndex = index(from: from)
           return String(self[fromIndex...])
       }

       func substring(to: Int) -> String {
           let toIndex = index(from: to)
           return String(self[..<toIndex])
       }
    
    func indices(of occurrence: String) -> [Int] {
        var indices = [Int]()
        var position = startIndex
        while let range = range(of: occurrence, range: position..<endIndex) {
            let i = distance(from: startIndex,
                             to: range.lowerBound)
            indices.append(i)
            let offset = occurrence.distance(from: occurrence.startIndex,
                                             to: occurrence.endIndex) - 1
            guard let after = index(range.lowerBound,
                                    offsetBy: offset,
                                    limitedBy: endIndex) else {
                                        break
            }
            position = index(after: after)
        }
        return indices
    }
}

