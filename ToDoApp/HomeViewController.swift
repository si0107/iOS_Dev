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
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    //@IBOutlet weak var quote: UILabel!
    @IBOutlet var calendar: FSCalendar!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var getButton: UIButton!
    
    // MARK: - Actions
    @IBAction func getLocButton(){
        getLocation()
    }
    
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
        updateCity()
        
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
        
        startLocationManager()
        updateCity()
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
        updateCity()
    }
    
    func locationManager(
      _ manager: CLLocationManager,
      didUpdateLocations locations: [CLLocation]
    ){
        let newLocation = locations.last!
        print("didUpdateLocations \(newLocation)")
        
        //take too long - cached location
        if newLocation.timestamp.timeIntervalSinceNow < -5 {
            return
        }
        
        // invalid location
        if newLocation.horizontalAccuracy < 0 {
              return
        }
        
        //check if nil before force unwrapping
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy {
            lastLocationError = nil
            location = newLocation
            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
                print("*** We're done!")
                stopLocationManager()
            }
            updateCity()
        }
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
    
    //563
    func updateCity() {
        if let location = location {
            cityLabel.text = String(
            format: "%.2f",
            location.coordinate.latitude)
        } else {
              //cityLabel.text = "N/A"
              let statusMessage: String
              if let error = lastLocationError as NSError? {
                  if error.domain == kCLErrorDomain && error.code == CLError.denied.rawValue{
                      statusMessage = "Loc Service Disabled"
                  } else {
                      statusMessage = "Error 4 loc"
                  }
              } else if !CLLocationManager.locationServicesEnabled() {
                    statusMessage = "Loc Serv Disabled"
              } else if updatingLocation {
                    statusMessage = "Searching..."
              } else {
                    statusMessage = "Retry"
              }
            cityLabel.textAlignment = NSTextAlignment.center
            cityLabel.adjustsFontSizeToFitWidth = true
            cityLabel.text = statusMessage
            //cityLabel.text = "error"
        }
        
    }
    
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updatingLocation = true
            //getButton.setImage(UIImage(systemName: String), for: .normal)
        }
    }
    
    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
        }
    }
    
    

}

