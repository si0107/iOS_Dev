//
//  ViewController.swift
//  ToDoApp
//
//  Created by S I on 11/9/22.
//

import UIKit

import FSCalendar

class HomeViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet var weatherIcon: UIImageView!
    @IBOutlet var temperature: UILabel!
    //@IBOutlet weak var quote: UILabel!
    @IBOutlet var calendar: FSCalendar!
    var formatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        calendar.delegate = self
        calendar.dataSource = self
        
        //set today's date
        let date = Date()
        formatter.dateFormat = "yyyy"
        let currentYear = formatter.string(from: date)
        self.yearLabel.text = currentYear
        formatter.dateFormat = "E, MMM d"
        let currentDate = formatter.string(from: date)
        self.dateLabel.text = currentDate
        
        calendar.appearance.todayColor = UIColor(red: 0.82, green: 0.46, blue: 0.56, alpha: 1.0)
        
        calendar.appearance.headerTitleColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        calendar.appearance.weekdayTextColor = .systemGray
        
        
        //self.quote.text = "Hello my name is sarika islam. Hello my name is sarika islam. Hello my name is sarika islam. Hello my name is sarika islam. Hello my name is sarika islam. Hello my name is sarika islam. Hello my name is sarika islam. Hello my name is sarika islam. "
        
    }
    
    
    //MARK:- Calendar Delegate
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        formatter.dateFormat = "dd-MM-yyyy"
        print("selected")
        print(Date())
    }
    
    


}

