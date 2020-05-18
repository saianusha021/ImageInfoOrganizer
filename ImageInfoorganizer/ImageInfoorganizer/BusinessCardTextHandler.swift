//
//  BusinessCardTextHandler.swift
//  ImageInfoorganizer
//
//  Created by Anusha Meda on 5/11/20.
//  Copyright © 2020 Anusha Meda. All rights reserved.
//

import Foundation
import UIKit
import Vision


class BusinessCardTextHandler: NSObject,RecognizedTextDataSource {
    
//    var businessCardContent:BusinessCardContent
//
//    override init() {
//        self.businessCardContent = CoreDataContentManager.createObjforEntity(entityName: "BusinessCardContent") as! BusinessCardContent
//    }
//
   func addRecognizedText(recognizedText: [VNRecognizedTextObservation]) {
        var fullText = ""
        let maximumCandidates = 1
        for observation in recognizedText {
            guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
            fullText.append(candidate.string + "\n")
        }
       //parseTextContents(text: fullText)
       var bcDetails = Parser.parseforDetailsInText(text:fullText)
        saveBusinessCardDetailsToCoreData(businessCardDetails: bcDetails)
    }
    
    
    func saveBusinessCardDetailsToCoreData(businessCardDetails:Details) {
         var businessCardContent = CoreDataContentManager.createObjforEntity(entityName: "BusinessCardContent") as! BusinessCardContent
        businessCardContent.businessName = businessCardDetails.name
        businessCardContent.address = businessCardDetails.address
        businessCardContent.phNumber = businessCardDetails.phNum
        businessCardContent.email  = businessCardDetails.email
        businessCardContent.website = businessCardDetails.website
        
        print("\n ------")
        print(businessCardContent)
        CoreDataContentManager.saveContext()
        
    }
    
    // MARK: Helper functions
//       func parseTextContents(text: String) {
//           do {
//               // Any line could contain the name on the business card.
//              // print(text)
//
//            self.businessCardContent.address = "Start  "
//               var potentialNames = text.components(separatedBy: .newlines)
//               print(potentialNames)
//               // Create an NSDataDetector to parse the text, searching for various fields of interest.
//               let detector = try NSDataDetector(types: NSTextCheckingAllTypes)
//               let matches = detector.matches(in: text, options: .init(), range: NSRange(location: 0, length: text.count))
//               for match in matches {
//
//                   let matchStartIdx = text.index(text.startIndex, offsetBy: match.range.location)
//                   let matchEndIdx = text.index(text.startIndex, offsetBy: match.range.location + match.range.length)
//                   var matchedString = String(text[matchStartIdx..<matchEndIdx])
//
//                   for eachLine in potentialNames {
//                       if(eachLine.contains(matchedString) && match.resultType != .phoneNumber) {
//                           matchedString = eachLine
//                       }
//                   }
//                   print(matchedString)
//                   // This line has been matched so it doesn't contain the name on the business card.
//                   while !potentialNames.isEmpty && (matchedString.contains(potentialNames[0]) || potentialNames[0].contains(matchedString)) {
//                       potentialNames.remove(at: 0)
//                   }
//
//                   switch match.resultType {
//                   case .address:
//                    self.businessCardContent.address?.append(matchedString)
//                   case .phoneNumber:
//                    self.businessCardContent.phNumber?.append(matchedString)
//                   case .link:
//                       if (match.url?.absoluteString.contains("mailto"))! {
//                           businessCardContent.email = matchedString
//                       } else {
//                           businessCardContent.website = matchedString
//                       }
//                   default:
//                       print("\(matchedString) type:\(match.resultType)")
//                   }
//               }
//               if !potentialNames.isEmpty {
//                   // Take the top-most unmatched line to be the person/business name.
//                   businessCardContent.businessName = potentialNames.first
//               }
//           } catch {
//               print(error)
//           }
//       }
    
    
    
}
