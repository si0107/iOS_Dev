//
//  AddItemViewController.swift
//  ToDoApp
//
//  Created by S I on 12/7/22.
//

import UIKit
import CoreData

class AddItemViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!

    var managedObjectContext: NSManagedObjectContext!
    
    var itemToEdit: ChecklistItem? {
        didSet {
            if let item = itemToEdit {
                titleText = item.title
                descriptionText = item.itemDescription
                if item.category == "Item" {
                    segmentControlIndex = 0
                } else {
                    segmentControlIndex = 1
                }
            }
        }
    }
    
    var titleText = ""
    var descriptionText = ""
    var segmentControlIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneBarButton.isEnabled = false
        navigationItem.largeTitleDisplayMode = .never
        
        if let item = itemToEdit {
            title = "Edit Item"
            doneBarButton.isEnabled = true
        }
        titleTextField.text = titleText
        descriptionTextField.text = descriptionText
        segmentedControl.selectedSegmentIndex = segmentControlIndex
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleTextField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    @IBAction func cancel() {
      navigationController?.popViewController(animated: true)
    }
    
    @IBAction func done() {
        guard let mainView = navigationController?.parent?.view
          else { return }
        let hudView = HudView.hud(inView: mainView, animated: true)
        
        print("Contents of the text field: \(titleTextField.text!)")
        
        let item: ChecklistItem
        if let temp = itemToEdit {
            item = temp
            hudView.text = "Updated!"
        } else {
            hudView.text = "Added!"
            item = ChecklistItem(context: managedObjectContext)
        }
        
        item.title = titleTextField.text!
        item.itemDescription = descriptionTextField.text!
        item.checked = 0 //Always unchecked
        if segmentedControl.selectedSegmentIndex == 0 {
            item.category = "Item" //or event
        } else {
            item.category = "Event" //or event
        }
        
        do {
            try self.managedObjectContext.save()
            print("*ADDED NEW ITEM!!!")
            afterDelay(0.6) {
              hudView.hide()
              self.navigationController?.popViewController(
                animated: true)
            }
        } catch {
            //fatalError("Error: \(error)")
            fatalCoreDataError(error)
        }
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        print("Segment changed: \(sender.selectedSegmentIndex)")
    }

    // MARK: - Table view data source
    
    // MARK: - Table View Delegates
    override func tableView(
      _ tableView: UITableView,
      willSelectRowAt indexPath: IndexPath
    ) -> IndexPath? {
        //return nil so they can't select the rows
        return nil
    }
    
    
    // MARK: - Text Field Delegates
    func textField(
      _ textField: UITextField,
      shouldChangeCharactersIn range: NSRange,
      replacementString string: String
    ) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(
            in: stringRange,
            with: string)
        if newText.isEmpty {
            doneBarButton.isEnabled = false
        } else {
            doneBarButton.isEnabled = true
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
    

}
