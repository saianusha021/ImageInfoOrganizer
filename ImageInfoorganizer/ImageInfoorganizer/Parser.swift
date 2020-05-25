//
//  Parser.swift
//  ImageInfoorganizer
//
//  Created by Anusha Meda on 5/11/20.
//  Copyright © 2020 Anusha Meda. All rights reserved.
//


import Foundation

class Parser {
    
   static func parseforDetailsInText(text:String)->Details{
        // MARK: Helper functions
    var detailsObj = Details()
        
            do {
                // Any line could contain the name on the business card.
               // print(text)
                var potentialNames = text.components(separatedBy: .newlines)
                print(potentialNames)
                // Create an NSDataDetector to parse the text, searching for various fields of interest.
                let detector = try NSDataDetector(types: NSTextCheckingAllTypes)
                let matches = detector.matches(in: text, options: .init(), range: NSRange(location: 0, length: text.count))
                for match in matches {
                    
                    let matchStartIdx = text.index(text.startIndex, offsetBy: match.range.location)
                    let matchEndIdx = text.index(text.startIndex, offsetBy: match.range.location + match.range.length)
                    var matchedString = String(text[matchStartIdx..<matchEndIdx])
                    
                    for eachLine in potentialNames {
                        if(eachLine.contains(matchedString) && match.resultType != .phoneNumber) {
                            matchedString = eachLine
                        }
                    }
                    print(matchedString)
                    // This line has been matched so it doesn't contain the name on the business card.
                    while !potentialNames.isEmpty && (matchedString.contains(potentialNames[0]) || potentialNames[0].contains(matchedString)) {
                        potentialNames.remove(at: 0)
                    }
                
                    switch match.resultType {
                    case .address:
                        detailsObj.address.append(matchedString)
                    case .phoneNumber:
                        detailsObj.phNum.append(matchedString)
                    case .date:
                        detailsObj.date.append(matchedString)
                    case .link:
                        if (match.url?.absoluteString.contains("mailto"))! {
                        detailsObj.email = matchedString
                        } else {
                        detailsObj.website = matchedString
                        }
                    default:
                        print("\(matchedString) type:\(match.resultType)")
                    }
                }
                if !potentialNames.isEmpty {
                    // Take the top-most unmatched line to be the person/business name.
                    detailsObj.name = potentialNames.first!
                }
            } catch {
                print(error)
            }
        return detailsObj
    }
    
    static func parseForItemsInItemsString(itemDetailsString:String) ->[String]{
           
           var itemListArray:[String] = []

           let allWordsInItemsContent = itemDetailsString.components(separatedBy: " ")
           
           var itemText = ""
           for eachword in allWordsInItemsContent {
               if (eachword.containsPriceExp()){
                   if itemText.count>0 {
                    if(!itemListArray.contains(itemText)) {
                       itemListArray.append(itemText)
                    }
                     itemText=""
                    continue
                   }
               }
               let newItem = isWordAnItem(word: eachword)
            if  (newItem.0 && newItem.1.count>0) {
                   itemText.append(newItem.1+" ")
               }
           }
           if (itemText.count>0) {
               itemListArray.append(itemText)
           }
           return itemListArray
       }
    
   static func isWordAnItem(word:String)->(Bool,String) {
        
        //print("Checking for word:",(word))
        if(word.count == 1) {
            return (false,word)
        }
        if(word.isInDefaultArray(defArray: defaultDescriptionWords())) {
            return (false,word)
        }
        if(word.containsOnlyLetters()) {
            return (true,word)
        }
        if(word.isAllSpecialCharacters()) {
            return (false,word)
        }
        if Int(word) != nil {
         return (false,word)
        }
        if(word.containsSpecialCharacters()) {
                   let strippedWrd = word.removeSpecialCharsNDigits()
                  // print("strippedWrd--",strippedWrd)
                   if(strippedWrd.count>0) {
                       return isWordAnItem(word: strippedWrd)
                   }
                   
        }
        return (false,word)
    }
    
    static func defaultDescriptionWords()->[String] {
        var defaultReceiptStartingWords = ["grocery","item","qty","amount","price","cost"]
        var defaultReceiptEndingWords = ["tax","total","sub"]
       return  ["reg","regular","disc","discount","diso","markdown","/lb","each","tare","FW","lb","produce","lh","bal","new","sale","loyalty","misc","expires","Bottom of"]+defaultReceiptStartingWords+defaultReceiptEndingWords
    }
    
}



    // MARK: Helper functions
//        func parseContentsForStoreDetails() {
//              do {
//                  // Any line could contain the name on the business card.
//                 // print(text)
//                var storeDetailsArray = storeDetailsString.components(separatedBy: .newlines)
//               self.receiptContentObj.address = "Start  "
//                self.receiptContentObj.phNumber = ""
//                self.receiptContentObj.date = ""
//                  // Create an NSDataDetector to parse the text, searching for various fields of interest.
//                  let detector = try NSDataDetector(types: NSTextCheckingAllTypes)
//
//                  let matches = detector.matches(in: storeDetailsString, options: .init(), range: NSRange(location: 0, length: storeDetailsString.count))
//                  for match in matches {
//                      let matchStartIdx = storeDetailsString.index(storeDetailsString.startIndex, offsetBy: match.range.location)
//                      let matchEndIdx = storeDetailsString.index(storeDetailsString.startIndex, offsetBy: match.range.location + match.range.length)
//                      var matchedString = String(storeDetailsString[matchStartIdx..<matchEndIdx])
//
//                      for eachLine in storeDetailsArray {
//                          if(eachLine.contains(matchedString) && match.resultType == .address) {
//                              matchedString = eachLine
//                          }
//                      }
//                      // This line has been matched so it doesn't contain the name on the business card.
//                      while !storeDetailsArray.isEmpty && (matchedString.contains(storeDetailsArray[0]) || storeDetailsArray[0].contains(matchedString)) {
//                          storeDetailsArray.remove(at: 0)
//                        print(storeDetailsArray )
//                      }
//                      switch match.resultType {
//                      case .address:
//                       self.receiptContentObj.address?.append(matchedString+" ")
//                      case .phoneNumber:
//                       self.receiptContentObj.phNumber?.append(matchedString+" ")
//
//                      case .date:
//                        self.receiptContentObj.date?.append(matchedString)
//                      default:
//                          print("\(matchedString) type:\(match.resultType)")
//                      }
//                  }
//                  if !storeDetailsString.isEmpty {
//                      // Take the top-most unmatched line to be the person/business name.
//                      receiptContentObj.storeName = storeDetailsArray.first
//                  }
//
//              } catch {
//                  print(error)
//              }
//          }
    
   
    
