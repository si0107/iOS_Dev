//
//  Checklist.swift
//  Checklists
//
//  Created by S I on 4/19/22.
//

import UIKit

class Checklist: NSObject, Codable {
    var name = ""
    var iconName = "check" //Initialize with checkmark image (No Icon for none)
    var items = [ChecklistItem]() //keep an array of checklist items
    
    //Checklist constructor
    init(name: String, iconName: String = "No Icon") {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    func countUncheckedItems() -> Int {
      var count = 0
      for item in items where !(item.checked == 2) {
          count += 1
      }
      return count
    }
    
}
