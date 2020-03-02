//
//  ReceiptTextParser.swift
//  ImageInfoorganizer
//
//  Created by Anusha Meda on 2/28/20.
//  Copyright © 2020 Anusha Meda. All rights reserved.
//

import UIKit
import Vision


class ReceiptTextParser: NSObject,RecognizedTextDataSource {
    var receiptContent = ReceiptContent()
    
    override init() {
           self.receiptContent = CoreDataContentManager.createObjforEntity(entityName: "ReceiptContent") as! ReceiptContent
       }
    
   func addRecognizedText(recognizedText: [VNRecognizedTextObservation]) {
     // Create a full transcript to run analysis on.
    var fullText = ""
          let maximumCandidates = 1
          for observation in recognizedText {
              guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
              fullText.append(candidate.string + "\n")
          }
         parseTextContents(text: fullText)
         CoreDataContentManager.saveContext()
   }
    
    // MARK: Helper functions
        func parseTextContents(text: String) {
              do {
                  // Any line could contain the name on the business card.
                 // print(text)
               
               self.receiptContent.address = "Start  "
                  var potentialNames = text.components(separatedBy: .newlines)
                  print(potentialNames)
                  // Create an NSDataDetector to parse the text, searching for various fields of interest.
                  let detector = try NSDataDetector(types: NSTextCheckingAllTypes)
                  let matches = detector.matches(in: text, options: .init(), range: NSRange(location: 0, length: text.count))
                var isItemListFound = false
                  for match in matches {
                      
                      let matchStartIdx = text.index(text.startIndex, offsetBy: match.range.location)
                      let matchEndIdx = text.index(text.startIndex, offsetBy: match.range.location + match.range.length)
                      var matchedString = String(text[matchStartIdx..<matchEndIdx])
                      
                      for eachLine in potentialNames {
                        if(!isItemListFound) {
                            var item:String? = findIteminTheLine(line: eachLine)
                        }
                          if(eachLine.contains(matchedString) && match.resultType != .phoneNumber) {
                              matchedString = eachLine
                          }
                      }
                    isItemListFound = true
                      print(matchedString)
                      // This line has been matched so it doesn't contain the name on the business card.
                      while !potentialNames.isEmpty && (matchedString.contains(potentialNames[0]) || potentialNames[0].contains(matchedString)) {
                          potentialNames.remove(at: 0)
                      }
                      switch match.resultType {
                      case .address:
                       self.receiptContent.address?.append(matchedString)
                      case .phoneNumber:
                       self.receiptContent.phNumber?.append(matchedString)
                      default:
                          print("\(matchedString) type:\(match.resultType)")
                      }
                  }
                  if !potentialNames.isEmpty {
                      // Take the top-most unmatched line to be the person/business name.
                      receiptContent.storeName = potentialNames.first
                  }
                
                
                
              } catch {
                  print(error)
              }
          }
    
    
    
    func findIteminTheLine(line:String)->String? {
        let wordsInLine = line.components(separatedBy: " ")
        for eachWord in wordsInLine {
            let range = NSRange(location: 0, length: eachWord.utf16.count)
            let regex = try! NSRegularExpression(pattern: "^$[^a-zA-Z][0-9]{1}.[0-9]{2}")
            if regex.firstMatch(in: eachWord, options: [], range: range) != nil {
                return wordsInLine[0]
            }
        }
        
        return nil
    }
       
}

