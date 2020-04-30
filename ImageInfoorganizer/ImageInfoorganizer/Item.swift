//
//  Item.swift
//  ImageInfoorganizer
//
//  Created by Anusha Meda on 3/25/20.
//  Copyright © 2020 Anusha Meda. All rights reserved.
//

import UIKit

public class Item: NSObject,NSCoding {
     public   var itemName:String = ""
    enum key:String {
        case itemName = "itemName"
    }
    init(itemName:String) {
        self.itemName = itemName
    }
    public override init() {
        super.init()
    }
    public  func encode(with coder: NSCoder) {
        coder.encode(itemName, forKey:key.itemName.rawValue )
    }
    
    public required convenience init?(coder: NSCoder) {
        let mitemName = coder.decodeObject(forKey: key.itemName.rawValue) as! String
        self.init(itemName: mitemName)
    }
}
