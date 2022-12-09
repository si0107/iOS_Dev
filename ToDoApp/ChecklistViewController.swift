//
//  ChecklistViewController.swift
//  ToDoApp
//
//  Created by S I on 12/7/22.
//

import UIKit
import CoreData

class ChecklistViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var managedObjectContext: NSManagedObjectContext!
    //var checklist = [ChecklistItem]()
    
    lazy var fetchedResultsController: NSFetchedResultsController<ChecklistItem> = {
      let fetchRequest = NSFetchRequest<ChecklistItem>()

      let entity = ChecklistItem.entity()
      fetchRequest.entity = entity

      let sort1 = NSSortDescriptor(key: "category", ascending: true)
      let sort2 = NSSortDescriptor(key: "title", ascending: true)
      fetchRequest.sortDescriptors = [sort1,sort2]

      fetchRequest.fetchBatchSize = 20

      let fetchedResultsController = NSFetchedResultsController(
        fetchRequest: fetchRequest,
        managedObjectContext: self.managedObjectContext,
        sectionNameKeyPath: "category",
        cacheName: "Checklist")

      fetchedResultsController.delegate = self
      return fetchedResultsController
    }()
    
    struct TableView {
      struct CellIdentifiers {
          static let checklistItemCell = "ChecklistItemCell"
          //static let nothingFoundCell = "NothingFoundCell"
          //static let loadingCell = "LoadingCell"
      }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        navigationItem.largeTitleDisplayMode = .never
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableView.automaticDimension
        
        //addFakeData()
        performFetch()
        
//        let cellNib = UINib(nibName: "ChecklistItemCell", bundle: nil)
//        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.checklistItemCell)

    }
    
    deinit {
        self.fetchedResultsController.delegate = nil
    }
    
    // MARK: - Helper methods
    func performFetch() {
      do {
          try self.fetchedResultsController.performFetch()
      } catch {
        fatalCoreDataError(error)
      }
    }
    
    func addFakeData(){
        
        let item = ChecklistItem(context: managedObjectContext)
        item.title = "title"
        item.category = "Event" //or event
        item.checked = 0
        item.itemDescription = "description"
        
        do {
            try self.managedObjectContext.save()
            
            print("*ADDED FAKE DATA!!!")
        } catch {
            //fatalError("Error: \(error)")
            fatalCoreDataError(error)
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! AddItemViewController
            controller.managedObjectContext = managedObjectContext
        } else if segue.identifier == "EditItem"  {
            let controller = segue.destination as! AddItemViewController
            controller.managedObjectContext = managedObjectContext
            if let indexPath = tableView.indexPath(
                for: sender as! UITableViewCell) {
                let item = fetchedResultsController.object(at: indexPath)
                controller.itemToEdit = item
            }

        }
    }

}


// MARK: - Table View Delegate
extension ChecklistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(
      in tableView: UITableView
    ) -> Int {
        if let count = self.fetchedResultsController.sections?.count{
            return count
        } else {
            return 0
        }
    }

    func tableView(
      _ tableView: UITableView,
      titleForHeaderInSection section: Int
    ) -> String? {
        if let sectionInfo = self.fetchedResultsController.sections?[section] {
            return sectionInfo.name.uppercased()
        } else {
            return ""
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        //sections returns an array of objects
        if let sectionInfo = self.fetchedResultsController.sections?[section]{
            return sectionInfo.numberOfObjects}
        else{
            return 0
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.checklistItemCell,
            for: indexPath) as! ChecklistItemCell
        
        let item = self.fetchedResultsController.object(at: indexPath)
        cell.configure(for: item)
        
//        if checklist.count == 0{
//            cell.titleLabel.text = "Nothing found"
//            cell.descriptionLabel.text = ""
//        } else {
//            let item = checklist[indexPath.row]
//            cell.titleLabel.text = item.title
//            cell.descriptionLabel.text = item.itemDescription
//            cell.configure(for: item)
//        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = self.tableView.cellForRow(at: indexPath) as? ChecklistItemCell {
            let item = fetchedResultsController.object(at: indexPath) as! ChecklistItem
            //If item is event or not
            
            if item.category == "Item" {
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
            cell.configure(for: item)
            do {
                try managedObjectContext.save()
            } catch {
              fatalCoreDataError(error)
            }
        }
        self.tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(
      _ tableView: UITableView,
      commit editingStyle: UITableViewCell.EditingStyle,
      forRowAt indexPath: IndexPath
    ) {
      if editingStyle == .delete {
        let item = fetchedResultsController.object(at: indexPath)
        managedObjectContext.delete(item)
        do {
          try managedObjectContext.save()
        } catch {
          fatalCoreDataError(error)
        }
      }
    }
    
    //edit an item
    
    //add an item
    
}

extension ChecklistViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(
      _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
      print("*** controllerWillChangeContent")
        self.tableView.beginUpdates()
    }

    func controller(
      _ controller: NSFetchedResultsController<NSFetchRequestResult>,
      didChange anObject: Any,
      at indexPath: IndexPath?,
      for type: NSFetchedResultsChangeType,
      newIndexPath: IndexPath?
    ) {
      switch type {
      case .insert:
        print("*** NSFetchedResultsChangeInsert (object)")
        self.tableView.insertRows(at: [newIndexPath!], with: .fade)

      case .delete:
        print("*** NSFetchedResultsChangeDelete (object)")
        self.tableView.deleteRows(at: [indexPath!], with: .fade)

      case .update:
          print("*** NSFetchedResultsChangeUpdate (object)")
          if let cell = self.tableView.cellForRow(at: indexPath!) as? ChecklistItemCell {
              let item = controller.object(at: indexPath!) as! ChecklistItem
              cell.configure(for: item)
          }

      case .move:
          print("*** NSFetchedResultsChangeMove (object)")
          self.tableView.deleteRows(at: [indexPath!], with: .fade)
          self.tableView.insertRows(at: [newIndexPath!], with: .fade)

      @unknown default:
          print("*** NSFetchedResults unknown type")
      }
    }

    func controller(
      _ controller: NSFetchedResultsController<NSFetchRequestResult>,
      didChange sectionInfo: NSFetchedResultsSectionInfo,
      atSectionIndex sectionIndex: Int,
      for type: NSFetchedResultsChangeType
    ) {
      switch type {
      case .insert:
          print("*** NSFetchedResultsChangeInsert (section)")
          self.tableView.insertSections(
          IndexSet(integer: sectionIndex), with: .fade)
      case .delete:
        print("*** NSFetchedResultsChangeDelete (section)")
          self.tableView.deleteSections(
          IndexSet(integer: sectionIndex), with: .fade)
      case .update:
          print("*** NSFetchedResultsChangeUpdate (section)")
      case .move:
          print("*** NSFetchedResultsChangeMove (section)")
      @unknown default:
          print("*** NSFetchedResults unknown type")
      }
    }

    func controllerDidChangeContent(
      _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        print("*** controllerDidChangeContent")
        self.tableView.endUpdates()
    }
  }
