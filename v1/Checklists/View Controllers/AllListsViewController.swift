//
//  AllListsViewController.swift
//  Checklists
//
//  Created by S I on 4/19/22.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    
    //Checklist list initialized when created and data is loaded
    //var dataModel: DataModel! //temporarily nil
    
    let cellIdentifier = "ChecklistCell"
    var lists = [Checklist]()
    
    override func viewDidLoad() {
        navigationController?.navigationBar.prefersLargeTitles = true
        super.viewDidLoad()
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        
        //find path of saved items
        //print("Documents folder is \(documentsDirectory())")
        //print("Data file path is \(dataFilePath())")
        
        // Load checklist removed
        
        // Hardcoded data removed
        var list = Checklist(name: "Birthdays", iconName: "check")
        lists.append(list)

        list = Checklist(name: "Groceries", iconName: "check")
        lists.append(list)

        list = Checklist(name: "Cool Apps", iconName: "check")
        lists.append(list)

        list = Checklist(name: "To Do", iconName: "check")
        lists.append(list)
    }
    
    //Load changed checklist counts
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return dataModel.lists.count
        return lists.count
    }

    //define cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //set cell type
        let cell: UITableViewCell!
        if let tmp = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = tmp
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        
        //let checklist = dataModel.lists[indexPath.row]
        let checklist = lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        
        //set list counts
        let count = checklist.countUncheckedItems()
        //if checklist.items.count == 0{
        if count == 0{
            cell.detailTextLabel!.text = "[No Items]"
        } else{
            cell.detailTextLabel!.text = count == 0 ? "Completed" : "\(count) Remaining" //Conditional statement
        }
        
        //set image
        cell.imageView!.image = UIImage(named: checklist.iconName)
        
        return cell
    }
    
    //select row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //let checklist = dataModel.lists[indexPath.row]
        let checklist = lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        //dataModel.indexOfSelectedChecklist = indexPath.row //set index
        
    }
    
    //delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        //dataModel.lists.remove(at: indexPath.row)
        lists.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    //edit checklist
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath){
        let controller = storyboard!.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController
        controller.delegate = self
        //let checklist = dataModel.lists[indexPath.row]
        let checklist = lists[indexPath.row]
        controller.checklistToEdit = checklist
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as? Checklist
        }  else if segue.identifier == "AddChecklist" {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }
    }
    
    
    //MARK: - List Detail View Controller Delegates
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        //dataModel.lists.append(checklist)
        lists.append(checklist)
        //dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        //dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    //Data persistence removed to DataModel
    
    // MARK: - Navigation Controller Delegates - Save UserDefaults
//    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool ){
//        // Was the back button tapped?
//        if viewController === self {    //refers to same object
//            //UserDefaults.standard.set(-1, forKey: "ChecklistIndex")
//            dataModel.indexOfSelectedChecklist = -1
//        }
//    }
    
    
    //open up to last opened list
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        navigationController?.delegate = self
//        //let index = UserDefaults.standard.integer(forKey: "ChecklistIndex")
//        let index = dataModel.indexOfSelectedChecklist  //get index
//        if index >= 0 && index < dataModel.lists.count { //Not the home screen and a valid index
//            let checklist = dataModel.lists[index]
//            performSegue(withIdentifier: "ShowChecklist",sender: checklist)
//        }
//    }

}
