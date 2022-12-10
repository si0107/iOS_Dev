//
//  AddItemViewController.swift
//  ToDoApp
//
//  Created by S I on 12/7/22.
//

import UIKit
import CoreData
import AudioToolbox

class AddItemViewController: UITableViewController, UITextFieldDelegate, CategoryPickerViewControllerDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    //@IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var categoryText: UILabel!
    
    var soundID: SystemSoundID = 0

    var managedObjectContext: NSManagedObjectContext!
    var titleText = ""
    var categoryName = "Event"
    var descriptionText = ""
    //var segmentControlIndex = 0
    var itemToEdit: ChecklistItem? {
        didSet {
            if let item = itemToEdit {
                titleText = item.title
                descriptionText = item.itemDescription
//                if item.category == "Item" {
//                    segmentControlIndex = 0
//                } else {
//                    segmentControlIndex = 1
//                }
                categoryName = item.category
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneBarButton.isEnabled = false
        navigationItem.largeTitleDisplayMode = .never
        loadSoundEffect("Sound.caf")
        
        if let item = itemToEdit {
            title = "Edit Item"
            doneBarButton.isEnabled = true
        }
        titleTextField.text = titleText
        descriptionTextField.text = descriptionText
        //selectedSegmentIndex = segmentControlIndex
        categoryText.text = categoryName
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
        self.playSoundEffect()
        
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
//        if segmentedControl.selectedSegmentIndex == 0 {
//            item.category = "Item" //or event
//        } else {
//            item.category = "Event" //or event
//        }
        item.category = categoryText.text!
        
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
    
//    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
//        print("Segment changed: \(sender.selectedSegmentIndex)")
//    }

    // MARK: - Table view data source
    
    // MARK: - Table View Delegates
    override func tableView(
      _ tableView: UITableView,
      willSelectRowAt indexPath: IndexPath
    ) -> IndexPath? {
        //return nil so they can't select the rows
        //select only the category cell
        return indexPath.section == 2 ? indexPath : nil
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
    
    // MARK: - Table view data source
    func categoryPicker(_ picker: CategoryPickerViewController, didPick categoryName: String) {
        self.categoryName = categoryName
        categoryText.text = self.categoryName
        navigationController?.popViewController(animated: true)
        self.tableView.reloadData()
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "PickCategory" {
            let controller = segue.destination as! CategoryPickerViewController
            controller.delegate = self
      }
    }
    
    // MARK: - Sound effects
    func loadSoundEffect(_ name: String) {
      if let path = Bundle.main.path(forResource: name, ofType: nil)
    {
        let fileURL = URL(fileURLWithPath: path, isDirectory: false)
        let error = AudioServicesCreateSystemSoundID(fileURL as
    CFURL, &soundID)
        if error != kAudioServicesNoError {
          print("Error code \(error) loading sound: \(path)")
        }
    } }
    func unloadSoundEffect() {
      AudioServicesDisposeSystemSoundID(soundID)
    soundID = 0 }
    func playSoundEffect() {
      AudioServicesPlaySystemSound(soundID)
    }
    

}
