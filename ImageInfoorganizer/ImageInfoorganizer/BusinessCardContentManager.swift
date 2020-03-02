//
//  BusinessCardContentManager.swift
//  ImageInfoorganizer
//
//  Created by Anusha Meda on 2/29/20.
//  Copyright © 2020 Anusha Meda. All rights reserved.
//

import UIKit
import CoreData

class BusinessCardContentManager: NSObject {
    
    static let businessCardEntity:String = "BusinessCardContent"
    
    static func createBusinessCardContentObj()->NSManagedObject {
       let context = managedContext()
        let businessCardEntity = NSEntityDescription.entity(forEntityName: self.businessCardEntity, in: context)
        let newbusinessCardContent = NSManagedObject(entity: businessCardEntity!, insertInto: context)
        return newbusinessCardContent
        
    }
    
//    static func retieveBusinessCardContentObjs()->[BusinessCardContent] {
//      let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        var contents = appDelegate.retrievemanagedObjsforEntity(entityName: businessCardEntity)
//        return contents as! [BusinessCardContent]
//    }
    
    static func saveContext() {
        let context = managedContext()
        do {
           try context.save()
          } catch {
           print("Failed saving")
        }
    }
    
    static  func managedContext()-> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
   
}
