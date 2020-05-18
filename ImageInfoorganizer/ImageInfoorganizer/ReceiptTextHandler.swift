//
//  ReceiptTextHandler.swift
//  ImageInfoorganizer
//
//  Created by Anusha Meda on 5/11/20.
//  Copyright © 2020 Anusha Meda. All rights reserved.
//

import Foundation
import UIKit
import Vision


class ReceiptTextHandler: RecognizedTextDataSource {
    
//    var receiptContentObj:ReceiptContent
   // var fullReceiptContentArray = [String]()
    var defaultReceiptStartingWords:[String]
    var defaultReceiptEndingWords:[String]
   // var defaultDescriptionWords:[String]
   // var itemListArray = [String]()
    var itemsContentEndsAtPos:Int = 0
    var storeNamesArr = ["Burlington","Target","Costco","Indian Grocers","Sai Grocers","CVS Pharmacy","Rite Aid","Walmart","Buschs","Macys","JCPenny","Old Navy"]

   enum ItemContentStartingFrom: Int {
        case defaultWords
        case priceExp
        case notFound
    }
    
     init() {
       
//           self.receiptContentObj = CoreDataContentManager.createObjforEntity(entityName: "ReceiptContent") as! ReceiptContent
        defaultReceiptStartingWords = ["grocery","item","qty","amount","price","cost"]
        defaultReceiptEndingWords = ["tax","total","sub"]
//        defaultDescriptionWords = ["reg","regular","disc","discount","diso","markdown","/lb","each","tare","FW","lb","produce","lh","bal","new","sale","loyalty","misc","expires","Bottom of"]+defaultReceiptStartingWords+defaultReceiptEndingWords

       }
    
   func addRecognizedText(recognizedText: [VNRecognizedTextObservation]) {
     // Create a full transcript to run analysis on.
          var fullText = ""
          let maximumCandidates = 1
          for observation in recognizedText {
              guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
              fullText.append(candidate.string + "\n")
          }
 
    let dividedText = divideReceiptContent(allText: fullText)
    let storeDetailString = dividedText.0
    let itemDetailString = dividedText.1
    let storeNameStr = dividedText.2
    var detailsObj = Parser.parseforDetailsInText(text: storeDetailString)
    print("Store Name: ",detailsObj.name)
    print("Store Name: ",storeNameStr)
    var storeName = self.StoreName(storeNameStr: storeNameStr)
    if(!storeName.isEmpty) {
        detailsObj.name = storeName
    }
    var itemsArray=Parser.parseForItemsInItemsString(itemDetailsString:itemDetailString)
    
    saveTheItemsToCoreData(detailsObj:detailsObj,items: itemsArray)
   }
    
    func StoreName(storeNameStr:String)->String {
        
        let strNameStrLwrCased = storeNameStr.lowercased()
        for storeName in storeNamesArr {
             if(strNameStrLwrCased.contains(storeName)) {
                           return storeName
                }
            var storeNamePartsArr = storeName.components(separatedBy: .newlines)
             
            for storeNamePart in storeNamePartsArr {
                let midIndex:Int = (storeNamePart.count/2)
                for i in 0...midIndex {
                    let StoreNamePartSubStrfromStart = storeNamePart.substring(from: i)
                    if(strNameStrLwrCased.localizedCaseInsensitiveContains(StoreNamePartSubStrfromStart)) {
                               return storeName
                    }
                    let StoreNamePartSubStrfromEnd = storeNamePart.substring(to:storeNamePart.count-1-i)
                    if(strNameStrLwrCased.localizedCaseInsensitiveContains(StoreNamePartSubStrfromEnd)) {
                               return storeName
                    }
                }
            }
        }
       return ""
    }

    func divideReceiptContent(allText:String)->(String,String,String) {
        var storeDetailsString = ""
        var itemDetailsString = ""
         var storeNameStr:String = ""
        var itemStartingPos = 0
        
        var fullReceiptContentArray = allText.components(separatedBy: .newlines)
        var i = -1
        
        for eachLine in fullReceiptContentArray {
            i+=1
            if(i>=0 && i<2) {
                 storeNameStr =  storeNameStr+" "+fullReceiptContentArray[i]
            }
          if( i>3) {
            var line = eachLine.components(separatedBy:.whitespaces)
            var isItemFound = false
            var wordsCount=0
            for eachword in line {
                var itemfound = isItemContentStarted(word:eachword)
                if(itemfound.0) {
                    isItemFound = true
                    var itemListFoundFrom:ItemContentStartingFrom = itemfound.1
                // storing the values from items starting point to end point
                    if(itemListFoundFrom == .defaultWords){
                        itemStartingPos = i+1
                    }
                    else if(wordsCount>3) {
                        itemStartingPos = i
                    }
                    else {
                        itemStartingPos = i-3
                    }
                    // locateStoreContentFromItemEndPos()
                    break
                }
                wordsCount+=1
            }
            if(isItemFound) {
                itemDetailsString = locateItemsContent(fromPosition:itemStartingPos,fullReceiptContentArray:fullReceiptContentArray)
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
       
        return (storeDetailsString,itemDetailsString,storeNameStr)
    }

    func locateItemsContent(fromPosition:Int, fullReceiptContentArray:[String] )->String{
        var itemDetailsString = ""
        for  i in fromPosition...fullReceiptContentArray.count-1 {
            let word:String = fullReceiptContentArray[i]
            if(word.isInDefaultArray(defArray: defaultReceiptEndingWords)) {
                itemsContentEndsAtPos = i
                break
             }
            itemDetailsString.append(word+" ")
        }
        return itemDetailsString
    }

//    func locateStoreContentFromItemEndPos() {
//
//        for  i in itemsContentEndsAtPos+1...fullReceiptContentArray.count-1 {
//            let word:String = fullReceiptContentArray[i]
//            storeDetailsString.append(word)
//        }
//    }
    
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
    
    func saveTheItemsToCoreData(detailsObj:Details,items:[String]) {
        
        var receiptContentObj = CoreDataContentManager.createObjforEntity(entityName: "ReceiptContent") as! ReceiptContent
        receiptContentObj.storeName = detailsObj.name
        receiptContentObj.address = detailsObj.address
        receiptContentObj.phNumber = detailsObj.phNum
        receiptContentObj.date = ""
        
           print("\n -------Final Item List Array")
           var itemsArray = [Item]()
           for eachword in items {
               let item = Item(itemName:eachword)
               print(eachword)
               itemsArray.append(item)
           }
          let items = Items(items: itemsArray)
           receiptContentObj.items = items
          CoreDataContentManager.saveContext()
    }
    
   
}


//for storeName in storeNamesArr {
//           let storeNamePartsArr = storeName.lowercased().components(separatedBy: .newlines)
//           var numberOfMatches = 0
//           for storeNameParts  in storeNamePartsArr {
//           if(strNameStrLwrCased.contains(storeNameParts)) {
//               return storeName
//           }
//           let storeNamesStrArr = strNameStrLwrCased.components(separatedBy: .newlines)
//           for str in storeNamesStrArr {
//
//           }
//         }
////       }
//func areSameStoreNames(storeNameStr:String,storeName:String)->Bool {
//
//    var storeNameStrfrmStarting:String
//    var storeNameStrfrmEnding:String
//    var newStoreName:String
//    if(storeNameStr.count >= storeName.count) {
//        //only omitting the special characters in  starting or ending
//         storeNameStrfrmStarting = String(storeNameStr.prefix(storeName.count))
//         storeNameStrfrmEnding = String(storeNameStr.suffix(storeName.count))
//    }
//    else {
//
//    }
//  return false
//}
