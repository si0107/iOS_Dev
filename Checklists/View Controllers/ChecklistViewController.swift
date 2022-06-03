//
//  ViewController.swift
//  Checklists
//
//  Created by S I on 4/7/22.
//


import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    //var items = [ChecklistItem]()
    var checklist: Checklist! //checklist object

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
      
        //removed static items
        //loadChecklistItems()
        
        title = checklist.name
    }

    // MARK: - Navigation
    override func prepare(
      for segue: UIStoryboardSegue,
      sender: Any?
    ) {
      if segue.identifier == "AddItem" {
        let controller = segue.destination as! ItemDetailViewController
        controller.delegate = self
      } else if segue.identifier == "EditItem" {
        let controller = segue.destination as! ItemDetailViewController
        controller.delegate = self

        if let indexPath = tableView.indexPath(
          for: sender as! UITableViewCell) {
            controller.itemToEdit = checklist.items[indexPath.row]
        }
      }
    }
    
    // MARK: - Actions
    //set checkmark
    //symbols:◯◒●★☆
    func configureCheckmark(
      for cell: UITableViewCell,
      with item: ChecklistItem
    ){
    let label = cell.viewWithTag(1001) as! UILabel
      
        switch item.checked{
        case 0:
            if item.event == false {
                label.text = "◯"
            } else {
                label.text = "☆"
            }
        case 1:
            if item.event == false {
                label.text = "◒"
            } else {
                label.text = "★"
            }
        case 2:
            if item.event == false {
                label.text = "●"
            }
            else {
                label.text = "☆"
            }
        default:
            if item.event == false {
                label.text = "◯"
            } else {
                label.text = "☆"
            }
        }
    }

    func configureText(
      for cell: UITableViewCell,
      with item: ChecklistItem
    ) {
      let label = cell.viewWithTag(1000) as! UILabel
      label.text = item.text
    }

    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(
        withIdentifier: "ChecklistItem",
        for: indexPath)

        let item = checklist.items[indexPath.row]

      configureText(for: cell, with: item)
      configureCheckmark(for: cell, with: item)

      return cell
    }

    // MARK: - Table View Delegate
    
    //toggle checkmark
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if let cell = tableView.cellForRow(at: indexPath) {
          let item = checklist.items[indexPath.row]
         
          //If item is event or not
          if item.event == false {
              if item.checked == 0 {
                  item.checked = 1
              } else if item.checked == 1{
                  item.checked = 2
              } else {
                  item.checked = 0
              }
          } else {
              if item.checked == 0 {
                  item.checked = 1
              } else if item.checked == 1 {
                  item.checked = 0
              } else {
                  item.checked = 0
              }
          }

        configureCheckmark(for: cell, with: item)
      }

      tableView.deselectRow(at: indexPath, animated: true)
      
        //saveChecklistItems()
    }

    //swipe-to-delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      // 1
        checklist.items.remove(at: indexPath.row)

      // 2
      let indexPaths = [indexPath]
      tableView.deleteRows(at: indexPaths, with: .automatic)
      
        //saveChecklistItems()
    }

    // MARK: - Add Item ViewController Delegates
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
      navigationController?.popViewController(animated: true)
    }
    
    //add new item
    func itemDetailViewController( _ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)

        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated:true)
        
        //saveChecklistItems()
    }
    
    //edit an existing item
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = checklist.items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
                configureCheckmark(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
        
        //saveChecklistItems()
    }
    
    
    //MARK: - Data Persistence (Will be reimplemented with Core Data)
    
  }
