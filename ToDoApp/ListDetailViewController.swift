//
//  ListDetailViewController.swift
//  ToDoApp
//
//  Created by S I on 12/9/22.
//

import UIKit
import CoreData

class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
    
    
    @IBOutlet var listNameTextField: UITextField!
    @IBOutlet weak var iconPicView: UIImageView!
    @IBOutlet var listDoneBarButton: UIBarButtonItem!
    
    var listNameText = ""
    var iconName = "check"
    var managedObjectContext: NSManagedObjectContext!
    var addList: NSSet = []
    
    var listToEdit: Checklist? {
        didSet {
            if let list = listToEdit {
                listNameText = list.name
                iconName = list.listIconName
                if (list.listOfItems.count != 0){
                    addList = list.listOfItems
                }
            }
        }
    }
    
    //MARK: - Actions
    @IBAction func done() {
        guard let mainView = navigationController?.parent?.view
          else { return }
        let hudView = HudView.hud(inView: mainView, animated: true)
        
        let list: Checklist
        if let temp = listToEdit {
            list = temp
            hudView.text = "Updated!"
        } else {
            hudView.text = "Added!"
            list = Checklist(context: managedObjectContext)
        }
        
        list.name = listNameTextField.text!
        list.listIconName = iconName
        list.listOfItems = addList
        
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
    
    @IBAction func cancel() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        listDoneBarButton.isEnabled = false
        navigationItem.largeTitleDisplayMode = .never
        
        if let list = listToEdit {
            title = "Edit List"
            listDoneBarButton.isEnabled = true
        }
        listNameTextField.text = listNameText
        iconPicView.image = UIImage(named: iconName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listNameTextField.becomeFirstResponder()
    }
    
    
    
    //can only select the icon
    override func tableView(
      _ tableView: UITableView,
      willSelectRowAt indexPath: IndexPath
    ) -> IndexPath? {
      return indexPath.section == 1 ? indexPath : nil
    }
    

    // MARK: - Table view data source
    //set var iconName to name of chosen icon
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
        self.iconName = iconName
        iconPicView.image = UIImage(named: iconName)
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "PickIcon" {
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
      }
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
            listDoneBarButton.isEnabled = false
        } else {
            listDoneBarButton.isEnabled = true
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        listDoneBarButton.isEnabled = false
        return true
    }
    
}
