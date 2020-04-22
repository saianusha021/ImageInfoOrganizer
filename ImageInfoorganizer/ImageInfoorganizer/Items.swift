//
//  Items.swift
//  ImageInfoorganizer
//
//  Created by Anusha Meda on 3/25/20.
//  Copyright © 2020 Anusha Meda. All rights reserved.
//

import UIKit

public class Items: NSObject,NSCoding {

    
    public var items:[Item] = []
    enum key:String {
        case items = "items"
    }
     init(items:[Item]) {
        self.items = items
    }
    public func encode(with coder: NSCoder) {
        coder.encode(items, forKey:key.items.rawValue )
    }
    
    required convenience public init?(coder: NSCoder) {
        let mitems = coder.decodeObject(forKey: key.items.rawValue) as! [Item]
        self.init(items: mitems)
    }
}
