//
//  SnappedContentViewController.swift
//  ImageInfoorganizer
//
//  Created by Anusha Meda on 2/27/20.
//  Copyright © 2020 Anusha Meda. All rights reserved.
//

import UIKit

class SnappedContentViewController: UIViewController {
   
    var snappedContentArray:[NSObject]?
    
    @IBOutlet weak var tableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad")
        let obj = CoreDataContentManager.retrievemanagedObjsforEntity(entityName: "ReceiptContent")
        for data in obj as! [ReceiptContent] {
            var itemsObj = data.value(forKey: "items") as! Items
            for item in itemsObj.items {
                print("items name",item.itemName)
            }
        }
        // Do any additional setup after loading the view.
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
        return 2
    }
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "section title"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "cell"
        return cell
    }
    
    
    
}
extension SnappedContentViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
