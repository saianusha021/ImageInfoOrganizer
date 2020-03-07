//
//  CoreDataContentManager.swift
//  ImageInfoorganizer
//
//  Created by Anusha Meda on 3/1/20.
//  Copyright © 2020 Anusha Meda. All rights reserved.
//

import UIKit
import CoreData

class CoreDataContentManager: NSObject {
      
    static func createObjforEntity(entityName:String)->NSManagedObject {
         let context = managedContext()
          let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
          let newreceiptContent = NSManagedObject(entity: entity!, insertInto: context)
          return newreceiptContent
          
      }
      
      static func retrievemanagedObjsforEntity(entityName:String )->[NSManagedObject] {
          
          let context = managedContext()
         let request = NSFetchRequest<NSFetchRequestResult>(entityName:entityName)
          var managedObjs = [NSManagedObject]()
         do {
             let result = try context.fetch(request)
             print(result)
          if result.count != 0 {
              managedObjs = result as! [NSManagedObject]
          }
          
         } catch {
             
             print("Failed")
         }
          return managedObjs
      }
    
    
      
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
