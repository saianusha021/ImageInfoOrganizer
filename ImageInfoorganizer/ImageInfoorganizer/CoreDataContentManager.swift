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
          var managedObjs = [NSManagedObject]()
                 do {
                   var  fetchedResults = try managedContext().fetch(ReceiptContent.fetchRequest())
                     if fetchedResults.count != 0 {
                         managedObjs = fetchedResults as! [NSManagedObject]
                     }
                 }
                 catch {
                     print ("fetch task failed")
                 }
                   return managedObjs
      }
    static func getItemNamesForStoreName(storeName:String)->ReceiptContent?{
        let predicate = NSPredicate(format: "storeName == %@", storeName)
       // var itemsObj:Items = Items(items: [Item]())
        var itemNamesArr:[String] = []
        let context = managedContext()
                let request = NSFetchRequest<NSFetchRequestResult>(entityName:"ReceiptContent")
        request.predicate = predicate
        var receiptObjs = [ReceiptContent]()
        do {
            let result = try context.fetch(request)
                if result.count != 0 {
                      receiptObjs = result as! [ReceiptContent]
                    if(receiptObjs.count>0){
                        let receiptContentObj:ReceiptContent = receiptObjs[0] 
                        //itemsObj = receiptContentObj.items!
                    }
            }
        
            }
        catch {
        
                print("Failed gettinf receipts with a storeName:",storeName)
              }
        
        if(receiptObjs.count>0) {
            return receiptObjs[0]
        }
        return nil
                     
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



//          let context = managedContext()
//         let request = NSFetchRequest<NSFetchRequestResult>(entityName:entityName)
//          var managedObjs = [NSManagedObject]()
//
//         do {
//             let result = try context.fetch(request)
//          if result.count != 0 {
//              managedObjs = result as! [NSManagedObject]
//          }
//
//         } catch {
//
//             print("Failed")
//         }
//          return managedObjs
