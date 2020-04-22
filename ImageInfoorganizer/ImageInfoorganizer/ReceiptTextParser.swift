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
    var receiptContentObj:ReceiptContent
    var fullReceiptContentArray = [String]()
    var defaultReceiptStartingWords:[String]
    var defaultReceiptEndingWords:[String]
    var defaultDescriptionWords:[String]
    var itemDetailsString:String = ""
    var storeDetailsString = ""
    var itemListArray = [String]()
    var itemsContentEndsAtPos:Int = 0
    
   enum ItemContentStartingFrom: Int {
        case defaultWords
        case priceExp
        case notFound
    }
    
    override init() {
           self.receiptContentObj = CoreDataContentManager.createObjforEntity(entityName: "ReceiptContent") as! ReceiptContent
        defaultReceiptStartingWords = ["grocery","item","qty","amount","price","cost"]
        defaultReceiptEndingWords = ["tax","total","sub"]
        defaultDescriptionWords = ["reg","regular","disc","discount","diso","markdown","/lb","each","tare","FW","lb","produce","lh","bal","new","sale","loyalty"]+defaultReceiptStartingWords+defaultReceiptEndingWords
        
       }
    
   func addRecognizedText(recognizedText: [VNRecognizedTextObservation]) {
     // Create a full transcript to run analysis on.
          var fullText = ""
          let maximumCandidates = 1
          for observation in recognizedText {
              guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
              fullText.append(candidate.string + "\n")
          }
         fullReceiptContentArray = fullText.components(separatedBy: .newlines)
         divideReceiptContent()
         parseContentsForStoreDetails()
          parseForItemsInItemsString()
    
    print ("Store Details")
    
    print(self.receiptContentObj)
        
    print("\n -------Final Item List Array")
    var itemsArray = [Item]()
    for eachword in itemListArray {
        var item = Item(itemName:eachword)
        print(eachword)
        itemsArray.append(item)
    }
   let items = Items(items: itemsArray)
    receiptContentObj.items = items
   CoreDataContentManager.saveContext()
   }
    
    func divideReceiptContent() {
        var i = -1
        for eachLine in fullReceiptContentArray {
            i+=1
          if( i>3) {
            var line = eachLine.components(separatedBy:.whitespaces)
            var isItemFound = false
            for eachword in line {
                var itemfound = isItemContentStarted(word:eachword)
                if(itemfound.0) {
                    isItemFound = true
                var itemListFoundFrom:ItemContentStartingFrom = itemfound.1
                
                // storing the values from items starting point to end point
                  if(itemListFoundFrom == .defaultWords){
                      locateItemsContent(fromPosition: i+1)
                      
                  }
                  else {
                      locateItemsContent(fromPosition: i-2)
                  }
                locateStoreContentFromItemEndPos()
                break
            }
            
            }
            if(isItemFound) {
                break
            }
          }
          else {
            storeDetailsString.append(eachLine+"\n")
        }
        }
        
        print(storeDetailsString)
        print("--------------------------------")
        print(itemDetailsString)
        
    }
    
    // MARK: Helper functions
        func parseContentsForStoreDetails() {
              do {
                  // Any line could contain the name on the business card.
                 // print(text)
                var storeDetailsArray = storeDetailsString.components(separatedBy: .newlines)
               self.receiptContentObj.address = "Start  "
                self.receiptContentObj.phNumber = ""
                self.receiptContentObj.date = ""
                  // Create an NSDataDetector to parse the text, searching for various fields of interest.
                  let detector = try NSDataDetector(types: NSTextCheckingAllTypes)
                
                  let matches = detector.matches(in: storeDetailsString, options: .init(), range: NSRange(location: 0, length: storeDetailsString.count))
                  for match in matches {
                      let matchStartIdx = storeDetailsString.index(storeDetailsString.startIndex, offsetBy: match.range.location)
                      let matchEndIdx = storeDetailsString.index(storeDetailsString.startIndex, offsetBy: match.range.location + match.range.length)
                      var matchedString = String(storeDetailsString[matchStartIdx..<matchEndIdx])
                      
                      for eachLine in storeDetailsArray {
                          if(eachLine.contains(matchedString) && match.resultType == .address) {
                              matchedString = eachLine
                          }
                      }
                    
                      // This line has been matched so it doesn't contain the name on the business card.
                      while !storeDetailsArray.isEmpty && (matchedString.contains(storeDetailsArray[0]) || storeDetailsArray[0].contains(matchedString)) {
                          storeDetailsArray.remove(at: 0)
                      }
                      switch match.resultType {
                      case .address:
                       self.receiptContentObj.address?.append(matchedString+" ")
                      case .phoneNumber:
                       self.receiptContentObj.phNumber?.append(matchedString+" ")
                       
                      case .date:
                        self.receiptContentObj.date?.append(matchedString)
                      default:
                          print("\(matchedString) type:\(match.resultType)")
                      }
                  }
                  if !storeDetailsString.isEmpty {
                      // Take the top-most unmatched line to be the person/business name.
                      receiptContentObj.storeName = storeDetailsArray.first
                  }
                
              } catch {
                  print(error)
              }
          }
    
    func parseForItemsInItemsString() {

        let allWordsInItemsContent = itemDetailsString.components(separatedBy: " ")
        
        var itemText = ""
        for eachword in allWordsInItemsContent {
            
            if (eachword.containsPriceExp()){
                if itemText.count>0 {
                  itemListArray.append(itemText)
                  itemText=""
                }
            }
            let newItem = isWordAnItem(word: eachword)
            if  (newItem.0) {
                itemText.append(newItem.1+" ")
                
            }

        }
        if (itemText.count>0) {
            itemListArray.append(itemText)
        }
        
    }
    
    func isWordAnItem(word:String)->(Bool,String) {
        
        if(word.count == 1) {
            return (false,word)
        }
        if(word.isDefaultDescription(defArray: defaultDescriptionWords)) {
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
    
    func locateItemsContent(fromPosition:Int ) {
        
        for  i in fromPosition...fullReceiptContentArray.count-1 {
            let word:String = fullReceiptContentArray[i]
            if(defaultReceiptEndingWords.contains(word.lowercased())) {
                itemsContentEndsAtPos = i+1
                break
             }
            itemDetailsString.append(word+" ")
        }
    }
    
    func locateStoreContentFromItemEndPos() {
        
        for  i in itemsContentEndsAtPos+1...fullReceiptContentArray.count-1 {
            let word:String = fullReceiptContentArray[i]
            storeDetailsString.append(word)
        }
    }
    
    func isItemContentStarted(word:String)->(Bool,ItemContentStartingFrom) {
      //  print(word)
        if(defaultReceiptStartingWords.contains(word.lowercased())) {
            return (true,.defaultWords)
        }
        let range1 = NSRange(location: 0, length: word.utf16.count)
        //let range2 = NSRange(location: 1, length: word.utf16.count-1)
        let regex1 = try! NSRegularExpression(pattern: "[0-9]{1}\\.[0-9]{2}")//contains a float value
         if  regex1.firstMatch(in: word, options: [], range: range1) != nil {
             print ("itemContentStartedAt   ", word)
                   return (true,.priceExp)
        }
        return (false,.notFound)
    }
}
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
    
    func isDefaultDescription(defArray:[String])-> Bool {
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
}
