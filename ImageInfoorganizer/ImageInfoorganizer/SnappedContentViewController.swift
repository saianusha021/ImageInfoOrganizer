//
//  SnappedContentViewController.swift
//  ImageInfoorganizer
//
//  Created by Anusha Meda on 2/27/20.
//  Copyright © 2020 Anusha Meda. All rights reserved.
//

import UIKit

class SnappedContentViewController: UIViewController {
   
    var snappedReceiptItems:[Item] = []
    var snappedReceipts:[ReceiptContent] = []
    var snappedCategories = ["Items","BusinessCards"]
    
    @IBOutlet weak var tableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        snappedReceipts = CoreDataContentManager.retrievemanagedObjsforEntity(entityName: "ReceiptContent") as! [ReceiptContent]
        
        for data in snappedReceipts {
            // displaying items in store
            let itemsObj = data.value(forKey: "items") as! Items
            snappedReceiptItems.append(contentsOf:itemsObj.items)
            for item in snappedReceiptItems {
                print("items name",item.itemName)
            }
            //Displaying Store Name
            let storeName = data.value(forKey: "storeName") as! String
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SnappedContentViewController:UITableViewDataSource {

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return snappedCategories.count
    }
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return snappedCategories[section]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if(section == 0) {
            return snappedReceipts.count
        }
        
         return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = snappedReceipts[indexPath.row].storeName
        return cell
    }
}


extension SnappedContentViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
