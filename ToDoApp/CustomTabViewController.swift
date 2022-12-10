//
//  CustomTabViewController.swift
//  ToDoApp
//
//  Created by S I on 12/9/22.
//

import UIKit

class CustomTabViewController: UITabBarController, UITabBarControllerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        let num = UserDefaults.standard.integer(
            forKey: "TabBarIndex")
        self.changeIndex(index: num)

        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Tab Bar Delegates
    override func tabBar(_ tabBard:UITabBar, didSelect item: UITabBarItem){
        print("SELECTED TAB BAR ITEM \(item)")
    }
    
    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected view controller \(viewController)")
        print("\(tabBarController.selectedIndex)")
        
        UserDefaults.standard.set(tabBarController.selectedIndex, forKey: "TabBarIndex")
    }
    
    @objc func changeIndex(index: Int){
        self.selectedIndex = index
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
