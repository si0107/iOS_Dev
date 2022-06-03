//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by S I on 4/29/22.
//

import Foundation
import UIKit

protocol IconPickerViewControllerDelegate: AnyObject {
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String)
}

class IconPickerViewController: UITableViewController {
    weak var delegate: IconPickerViewControllerDelegate?
    
    let icons = [
        "No Icon", "art", "bookshelf", "brush-pencil", "calculator", "calendar", "camera", "car", "check", "clapboard", "clock", "compose", "computer", "fashion", "flower", "gamecontroller", "heart", "money", "news", "rocket", "schoolbus", "scissors", "star", "x"
    ]
    
    // MARK: - Table View Delegates
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
        let iconName = icons[indexPath.row]
        cell.textLabel!.text = iconName
        cell.imageView!.image = UIImage(named: iconName)
        return cell
    }
    
    //Select Row return iconName
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if let delegate = delegate {
            let iconName = icons[indexPath.row]
            delegate.iconPicker(self, didPick: iconName)
      }
    }
    
    
}
