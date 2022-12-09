//
//  AllListsViewController.swift
//  ToDoApp
//
//  Created by S I on 12/7/22.
//

import UIKit

class AllListsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellidentifier", for: indexPath)
        cell.textLabel!.text = "List \(indexPath.row)"
          return cell
    }
  
    // MARK: - Navigation

}
