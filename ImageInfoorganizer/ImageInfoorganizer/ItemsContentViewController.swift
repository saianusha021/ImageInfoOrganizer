//
//  ItemsContentViewController.swift
//  ImageInfoorganizer
//
//  Created by Anusha Meda on 5/24/20.
//  Copyright © 2020 Anusha Meda. All rights reserved.
//

import UIKit

class ItemsContentViewController: UIViewController {
   
    var itemsArray:[Item]?
    var storeName:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        if(storeName != nil) {
            self.title = storeName!
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
extension ItemsContentViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray?.count ?? 0
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let itm = itemsArray?[indexPath.row]
        cell.textLabel?.text = itm?.itemName
            return cell
       }
}
extension ItemsContentViewController:UITableViewDelegate {
    
}
