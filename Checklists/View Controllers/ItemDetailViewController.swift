//
//  AddEditItemViewController.swift
//  Checklists
//
//  Created by S I on 4/19/22.
//

import UIKit

protocol ItemDetailViewControllerDelegate: AnyObject {
  func itemDetailViewControllerDidCancel(
    _ controller: ItemDetailViewController)
  func itemDetailViewController(
    _ controller: ItemDetailViewController,
    didFinishAdding item: ChecklistItem
  )
  func itemDetailViewController(
    _ controller: ItemDetailViewController,
    didFinishEditing item: ChecklistItem
  )
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var selectedSegment: UISegmentedControl!
    
    weak var delegate: ItemDetailViewControllerDelegate?
    var itemToEdit: ChecklistItem?
    var itemSeg = false

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never
    if let item = itemToEdit {
      title = "Edit Item"
      textField.text = item.text
      //Change segment based on what item event is
      if item.event == false {
        selectedSegment.selectedSegmentIndex = 0
        itemSeg = false
      } else {
        selectedSegment.selectedSegmentIndex = 1
          itemSeg = true
      }
      doneBarButton.isEnabled = true
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }

  // MARK: - Actions
  @IBAction func cancel() {
    delegate?.itemDetailViewControllerDidCancel(self)
  }

  @IBAction func done() {
    if let item = itemToEdit {
      item.text = textField.text!
        if itemSeg == false{
            item.event = false
        } else {
            item.event = true
            item.checked = 0
        }
      delegate?.itemDetailViewController(self, didFinishEditing: item)
    } else {
      let item = ChecklistItem()
      item.text = textField.text!
      if itemSeg == false{
          item.event = false
          item.checked = 0
      } else {
          item.event = true
          item.checked = 0
      }
      delegate?.itemDetailViewController(self, didFinishAdding: item)
    }
  }
    
  @IBAction func eventSegment(_ sender: UISegmentedControl) {
    if sender.selectedSegmentIndex == 0 {
        itemSeg = false
    } else {
        itemSeg = true
    }
  }
    

  // MARK: - Table View Delegates
  override func tableView(
    _ tableView: UITableView,
    willSelectRowAt indexPath: IndexPath
  ) -> IndexPath? {
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
