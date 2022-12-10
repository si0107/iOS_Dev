//
//  CategoryPickerViewController.swift
//  ToDoApp
//
//  Created by S I on 12/9/22.
//

import UIKit

protocol CategoryPickerViewControllerDelegate: AnyObject {
    func categoryPicker(_ picker: CategoryPickerViewController, didPick categoryName: String)
}

class CategoryPickerViewController: UITableViewController {
    weak var delegate: CategoryPickerViewControllerDelegate?
    
    let categories = [
        "Item", "Event"
    ]

    // MARK: - Table View Delegates
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let categoryName = categories[indexPath.row]
        cell.textLabel!.text = categoryName
        return cell
    }
    
    //Select Row return iconName
    override func tableView(
      _ tableView: UITableView,
      didSelectRowAt indexPath: IndexPath
    ) {
        print("**PICKED A ROW")
        if let delegate = delegate {
            let categoryName = categories[indexPath.row]
            print("CATEGORYNAME FIRST PICKED: \(categoryName)")
            delegate.categoryPicker(self, didPick: categoryName)
      }
    }


}


