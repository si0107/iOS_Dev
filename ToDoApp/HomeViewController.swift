//
//  ViewController.swift
//  ToDoApp
//
//  Created by S I on 11/9/22.
//

import UIKit

import FSCalendar
import CoreLocation

class HomeViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet var weatherIcon: UIImageView!
    @IBOutlet var temperature: UILabel!
    //@IBOutlet weak var quote: UILabel!
    @IBOutlet var calendar: FSCalendar!
    @IBOutlet var cityLabel: UILabel!
    
    var formatter = DateFormatter()
    let locationManager = CLLocationManager()
    var location: CLLocation?
    var updatingLocation = false
    var lastLocationError: Error?
    
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
        
        getLocation()
        //TODO: updateCity()
        
    }
    
    
    //MARK: - Calendar Delegate
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        formatter.dateFormat = "dd-MM-yyyy"
        print("selected")
        print(Date())
    }
    
    
    // MARK: - Location Helper functions
    func getLocation() {
        //check authorization status
        let authStatus = locationManager.authorizationStatus
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(
      _ manager: CLLocationManager,
      didFailWithError error: Error
    ){
        print("didFailWithError \(error.localizedDescription)")
        if (error as NSError).code == CLError.locationUnknown.rawValue{
            return
        }
        lastLocationError = error
        stopLocationManager()
        //TODO: updateCity()
    }
    
    func locationManager(
      _ manager: CLLocationManager,
      didUpdateLocations locations: [CLLocation]
    ){
        let newLocation = locations.last!
        print("didUpdateLocations \(newLocation)")
        location = newLocation    // Add this
        //TODO: update city location here
        //TODO: updateCity()
    }
    
    // MARK: - Helper Methods
    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(
            title: "Location Services Disabled",
            message: "Please enable location services for this app in Settings.",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    //TODO: func updateCity(){cityLabel.text = newCity}
    
    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
        }
    }
    
    

}

