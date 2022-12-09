//
//  AllListsViewController.swift
//  ToDoApp
//
//  Created by S I on 12/7/22.
//

import UIKit
import CoreData

class AllListsViewController: UITableViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    
    lazy var fetchedResultsController: NSFetchedResultsController<Checklist> = {
      let fetchRequest = NSFetchRequest<Checklist>()

      let entity = Checklist.entity()
      fetchRequest.entity = entity

      let sort1 = NSSortDescriptor(key: "name", ascending: true)
      //let sort2 = NSSortDescriptor(key: "title", ascending: true)
      fetchRequest.sortDescriptors = [sort1]

      fetchRequest.fetchBatchSize = 20

      let fetchedResultsController = NSFetchedResultsController(
        fetchRequest: fetchRequest,
        managedObjectContext: self.managedObjectContext,
        sectionNameKeyPath: nil,
        cacheName: "Checklist")

      fetchedResultsController.delegate = self
      return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Enable large titles
        navigationController?.navigationBar.prefersLargeTitles = true
        addFakeList()
        performFetch()
    }
    
    deinit {
        self.fetchedResultsController.delegate = nil
    }
    
    // MARK: - Helper Methods
    func addFakeList(){
        let list = Checklist(context: managedObjectContext)
        list.name = "Birthdays"
        list.listIconName = "check"
        let newListItems: NSSet = []
        list.listOfItems = newListItems
        
        do {
            try self.managedObjectContext.save()
            
            print("*ADDED FAKE DATA!!!")
        } catch {
            //fatalError("Error: \(error)")
            fatalCoreDataError(error)
        }
        self.tableView.reloadData()
    }
    
    func performFetch() {
      do {
          try self.fetchedResultsController.performFetch()
      } catch {
        fatalCoreDataError(error)
      }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sectionInfo = self.fetchedResultsController.sections?[section]{
            return sectionInfo.numberOfObjects}
        else{
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllListsCell", for: indexPath) as! AllListsCell
        
        let list = self.fetchedResultsController.object(at:indexPath)
        
        cell.configure(for: list)
        return cell
    }
    
    //Set up segue on storyboard --> unnecessary?
    override func tableView(
      _ tableView: UITableView,
      didSelectRowAt indexPath: IndexPath
    ){
      performSegue(withIdentifier: "ShowChecklist", sender: nil)
    }
    
    override func tableView(
      _ tableView: UITableView,
      commit editingStyle: UITableViewCell.EditingStyle,
      forRowAt indexPath: IndexPath
    ) {
      if editingStyle == .delete {
        let list = fetchedResultsController.object(at: indexPath)
        managedObjectContext.delete(list)
        do {
          try managedObjectContext.save()
        } catch {
          fatalCoreDataError(error)
        }
      }
    }
  
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController
            controller.managedObjectContext = managedObjectContext
        } else if segue.identifier == "AddChecklist"{
            let controller = segue.destination as! ListDetailViewController
            controller.managedObjectContext = managedObjectContext
        } else if segue.identifier == "EditChecklist" {
            let controller = segue.destination as! ListDetailViewController
            controller.managedObjectContext = managedObjectContext
            if let indexPath = tableView.indexPath(
                for: sender as! UITableViewCell) {
                let list = fetchedResultsController.object(at: indexPath)
                controller.listToEdit = list
            }
        }
    }

}

extension AllListsViewController: NSFetchedResultsControllerDelegate {
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
          if let cell = self.tableView.cellForRow(at: indexPath!) as? AllListsCell {
              let item = controller.object(at: indexPath!) as! Checklist
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
