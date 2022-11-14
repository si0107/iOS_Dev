//
//  DataModel.swift
//  Checklists
//
//  Created by S I on 4/29/22.
//

//import Foundation
//
//class DataModel{
//    var lists = [Checklist]()
//
//    var indexOfSelectedChecklist: Int {
//        get {
//            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
//        } set {
//            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
//        }
//    }
//
//    init() {
//        loadChecklists()
//        registerDefaults()
//        handleFirstTime()
//    }
//
//    //MARK: - Data Persistence (Will be reimplemented with Core Data)
//    func documentsDirectory() -> URL {
//      let paths = FileManager.default.urls(
//        for: .documentDirectory,
//        in: .userDomainMask)
//      return paths[0]
//    }
//
//    func dataFilePath() -> URL {
//      return documentsDirectory().appendingPathComponent("Checklists.plist")
//    }
//
//
//    func saveChecklists() {
//      let encoder = PropertyListEncoder() //Encodes a list of items
//      do { //set up a block of code to catch errors
//          let data = try encoder.encode(lists)
//          try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
//      } catch { //Catch block produces error variable
//        print("Error encoding item array: \(error.localizedDescription)")
//      }
//    }
//
//    func loadChecklists() {
//      let path = dataFilePath()
//      if let data = try? Data(contentsOf: path) {
//        let decoder = PropertyListDecoder()
//        do {
//            lists = try decoder.decode([Checklist].self, from: data)
//            sortChecklists()
//        } catch {
//          print("Error decoding item array: \(error.localizedDescription)")
//        }
//      }
//    }
//
//    //Set a default value to UserDefaults
//    func registerDefaults() {
//      let dictionary = ["ChecklistIndex": -1,"FirstTime": true] as [String: Any]
//      UserDefaults.standard.register(defaults: dictionary)
//    }
//
//    func handleFirstTime() {
//        let userDefaults = UserDefaults.standard
//        let firstTime = userDefaults.bool(forKey: "FirstTime")
//        if firstTime {
//            let checklist = Checklist(name: "List")
//            lists.append(checklist)
//            indexOfSelectedChecklist = 0
//            userDefaults.set(false, forKey: "FirstTime")
//        }
//    }
//
//    //Sort data
//    func sortChecklists() {
//      lists.sort { list1, list2 in
//        return list1.name.localizedStandardCompare(list2.name) == .orderedAscending
//      }
//    }
//
//}
