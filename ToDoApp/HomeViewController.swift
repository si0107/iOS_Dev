//
//  ViewController.swift
//  ToDoApp
//
//  Created by S I on 11/9/22.
//


// TO-DO: 583 - change start location manager ()
import UIKit

import FSCalendar
import CoreLocation

class HomeViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var quote: UITextView!
    @IBOutlet var calendar: FSCalendar!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var getButton: UIButton!
    @IBOutlet weak var authorLabel: UILabel!
    
    var formatter = DateFormatter()
    let locationManager = CLLocationManager()
    var location: CLLocation?
    var updatingLocation = false
    var lastLocationError: Error?
    
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var lastPlace: CLPlacemark?
    var performingReverseGeocoding = false
    var lastGeocodingError: Error?
    
    var locationTimer: Timer?
    
    //Load images
    var downloadTask: URLSessionDownloadTask?
    
    //Weather API variables
    var dataTask: URLSessionDataTask?
    var isLoading = false
    var currentTemperature: String?
    var weatherIconString: String?
    
    //Quote API variables
    var quoteContext: String!
    var authorName: String!
    var isGettingQuote = false
    
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
        
        
        //Placeholder image
        self.weatherIcon.image = UIImage(systemName: "square")
        self.quote.text = "Retrieving daily quote!"
        self.authorLabel.text = ""
        self.getQuote()
        
        //time interval in seconds
        //every 10 minutes, it will update the weather
        Timer.scheduledTimer(withTimeInterval: 600, repeats: true){ (_) in
            print("TIMER TICKING")
            //getLocation()
            //updateCity()
        }
        
        
        getLocation()
        updateCity()
        
        //TEST WEATHER API
        //findWeather(lat: "40.712776", long: "-74.005974")
        
    }
    
    // MARK: - Actions
    @IBAction func getLocButton(){
        getLocation()
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
        
        if updatingLocation {
            stopLocationManager()
        } else {
            location = nil
            lastLocationError = nil
            placemark = nil
            lastGeocodingError = nil
            startLocationManager()
        }
        updateCity()
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(
      _ manager: CLLocationManager,
      didFailWithError error: Error
    ){
        print("didFailWithError \(error.localizedDescription)")
        if (error as NSError).code == CLError.locationUnknown.rawValue {
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
        
        var distance = CLLocationDistance(Double.greatestFiniteMagnitude)
        if let location = location {
            distance = newLocation.distance(from: location)
        }
        
        //check if nil before force unwrapping
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy {
            lastLocationError = nil
            location = newLocation
            
            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
                print("*** We're done!")
                stopLocationManager()
                
                if distance > 0 {
                        performingReverseGeocoding = false
                }
            }
            
            if !performingReverseGeocoding {
                print("*** Going to geocode")
                performingReverseGeocoding = true
                geocoder.reverseGeocodeLocation(newLocation) {placemarks, error in
                    self.lastGeocodingError = error
                    if error == nil, let places = placemarks, !places.isEmpty {
                        self.placemark = places.last!
                    } else {
                      self.placemark = nil
                    }
                    self.performingReverseGeocoding = false
                    print("*** End geocode")
                    self.updateCity()
                }
            }
            
            if !isLoading {
                //isLoading = true
                print("***Going into findWeather")
                if let location = location {
                    let latit = String(
                        format: "%.4f",
                        location.coordinate.latitude)
                    let longit = String(
                        format: "%.4f",
                        location.coordinate.longitude)
                    
                    print("LATITUDE: \(latit)")
                    print("LONGITUDE: \(longit)")
                    //findWeather(lat: latit, long: longit)
                    print("***End of findWeather")
                }
                //isLoading = false
            }
            updateCity()
        } else if distance < 1 {       //accuracy in distance doesn't change significantly + more than 10 seconds to find new distance
            let timeInterval = newLocation.timestamp.timeIntervalSince(location!.timestamp)
            if timeInterval > 10 {
              print("*** Force done!")
              stopLocationManager()
              updateCity()
            }
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
            handler: { _ in
                self.updateCity()
              })
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    //563
    func updateCity() {
        if location != nil {
            getButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
            
            if let placemark = placemark {
                cityLabel.text = string(from: placemark)
                cityLabel.textAlignment = NSTextAlignment.center
                cityLabel.adjustsFontSizeToFitWidth = true
            } else if performingReverseGeocoding {
                cityLabel.text = "Searching..."
            } else if lastGeocodingError != nil {
                cityLabel.text = "Error"
            } else {
                cityLabel.text = "Not Found"
            }
            
            if currentTemperature != nil {
                currentTemperature! += " °F"
                temperature.text = currentTemperature
                cityLabel.textAlignment = NSTextAlignment.center
                cityLabel.adjustsFontSizeToFitWidth = true
            } else if isLoading{
                self.temperature.text = "..."
            } else {
                self.temperature.text = "N/A"
            }
            
            if isLoading{
                downloadTask?.cancel()
                downloadTask = nil
            } else if weatherIconString == nil {
                self.weatherIcon.image = UIImage(systemName: "square")
            } else {
                let tempImageUrl = weatherIconUrl(iconString: weatherIconString ?? "")
                downloadTask = weatherIcon.loadImage(url: tempImageUrl)
            }
                
                
        }  else {
            let statusMessage: String
            if let error = lastLocationError as NSError? {
                if error.domain == kCLErrorDomain && error.code == CLError.denied.rawValue {
                    statusMessage = "Location Service Disabled"
                    getButton.setImage(UIImage(systemName: "exclamationmark.triangle.fill"), for: .normal)
                } else {
                    statusMessage = "Error Getting Location"
                    getButton.setImage(UIImage(systemName: "exclamationmark.triangle.fill"), for: .normal)
                }
            } else if !CLLocationManager.locationServicesEnabled() {
                statusMessage = "Location Service Disabled"
                getButton.setImage(UIImage(systemName: "exclamationmark.triangle.fill"), for: .normal)
            } else if updatingLocation {
                statusMessage = "Searching..."
                getButton.setImage(UIImage(systemName: "location.slash.fill"), for: .normal)
            } else {
                if (lastLocationError != nil) {
                        statusMessage = "Error Getting Location"
                        getButton.setImage(UIImage(systemName: "exclamationmark.triangle.fill"), for: .normal)
                } else {
                    statusMessage = "Retry"
                    getButton.setImage(UIImage(systemName: "exclamationmark.arrow.circlepath"), for: .normal)
                }
            }
            cityLabel.textAlignment = NSTextAlignment.center
            cityLabel.adjustsFontSizeToFitWidth = true
            cityLabel.text = statusMessage
            //configureGetButton()
            
        }
    }
    
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            //locationManager.desiredAccuracy = kCLLocationAccuracyReduced
            locationManager.startUpdatingLocation()
            updatingLocation = true
            
            locationTimer = Timer.scheduledTimer(
                timeInterval: 60,
                target: self,
                selector: #selector(didTimeOut),
                userInfo: nil,
                repeats: false)
        }
    }
    
    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
            updateCity()
            
            if let locationTimer = locationTimer {
                locationTimer.invalidate()
            }
        }
    }
    
//    func configureGetButton() {
//      if updatingLocation {
//          getButton.setImage(UIImage(systemName: "location.slash.fill"), for: .normal)
//      } else {
//          getButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
//       }
//     }
    
    func string(from placemark: CLPlacemark) -> String {
      var line = ""
        //city
      if let tmp = placemark.locality {
        line = tmp // ", "
      }
        //state
//      if let tmp = placemark.administrativeArea {
//        line += tmp
//      }
      return line  //city
    }
    
    //@objc to make it accesible for objC so that the selector can identify it
    @objc func didTimeOut() {
      print("*** Time out")
      if location == nil {
        stopLocationManager()
        lastLocationError = NSError(
          domain: "MyLocationsErrorDomain",
          code: 1,
          userInfo: nil)
        updateCity()
      }
    }
    
    // MARK: - Weather API Request
    
    func weatherURL(lat: String, long: String) -> URL {
        //create the url for the weather API
        
        let apiKey = "4d7f55cb1f3326b2c1d1ba245082f07d"
        //units are in Farenheit
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&exclude=minutely,hourly,daily,alerts&appid=\(apiKey)&units=imperial"
        let url = URL(string: urlString)
        return url!
        
        //Example url
        //https://api.openweathermap.org/data/2.5/weather?lat=40.712776&lon=-74.005974&exclude=minutely,hourly,daily,alerts&appid=4d7f55cb1f3326b2c1d1ba245082f07d&units=imperial
    }
    
    func weatherIconUrl(iconString: String) -> URL {
        let urlString = "https://openweathermap.org/img/wn/\(iconString)@2x.png"
        let url = URL(string: urlString)
        return url!
    }
    
    func findWeather(lat: String, long: String){
        
        dataTask?.cancel()
        isLoading = true
        updateCity()
        
        
        let url = weatherURL(lat: lat, long: long)
        
        //asynchronous session
        let session = URLSession.shared
        
        dataTask = session.dataTask(with: url) { [self]data, response, error in
            
            if let error = error as NSError?, error.code == -999 {
                self.currentTemperature = nil
                self.weatherIconString = nil
                print("Failure! \(error.localizedDescription)")
                return //Search was canceled
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    //use if let to check value of an optional
                    print("Success!")
                    if let data = data {
                        let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        //weather is an Array of 2 dictionarys
                        let weather = dataDictionary["weather"] as! [Any]
                        //main is a dictionary of temps, pressure and humidity
                        //let weather
                        let main = dataDictionary["main"] as! [String: Any]
                        let currentTemp = main["temp"] as! Double
                        let iconArray = weather[0] as! [String: Any]
                        let iconString = iconArray["icon"] as! String
                        
                        print("WEATHER: \(iconArray)")
                        print("ICON: \(iconString)")
                        print("MAIN: \(main)")
                        print("CURRENTTEMP: \(currentTemp)")
                        
                        //set temp + image icon
                        let tempInt = Int(currentTemp.rounded()) //Round the temperature
                        self.currentTemperature = String(tempInt)
                        self.weatherIconString = iconString
                        
                        DispatchQueue.main.async {
                            self.isLoading = false
                            self.updateCity()
                        }
                        return
                    }
            } else {
                print("Failure! \(response!)")
                self.currentTemperature = nil
                self.weatherIconString = nil
            }
            
            DispatchQueue.main.async {
              self.isLoading = false
              self.updateCity()
              //self.showNetworkError()
            }
        }
        
        dataTask?.resume()
    }
    
    // MARK: - Quote API Request
    
    func getQuote() {
        print("***START GETTING QUOTE")
        
        isGettingQuote = true
        updateQuote()
        
        let headers = [
            "X-RapidAPI-Key": "c43e3bdb48msh3e4d204f2e61c48p1a34a6jsn9316521d821b",
            "X-RapidAPI-Host": "quotes15.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://quotes15.p.rapidapi.com/quotes/random/")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let error = error as NSError?{
                print("QUOTE Error! \(error)")
                self.quoteContext = "N/A"
                self.authorName = "N/A"
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("QUOTE Success!")
                if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    print("DICTIONARY: \(dataDictionary)")
                    let content = dataDictionary["content"] as! String
                    let originator = dataDictionary["originator"] as! [String: Any]
                    let author = originator["name"] as! String
                    
                    
                    print("quoteContext: \(content)")
                    print("authorName: \(author)")
                    self.quoteContext = content
                    self.authorName = author
                    
                }
            } else {
                print("QUOTE Failure! \(response!)")
                self.quoteContext = "N/A"
                self.authorName = "N/A"
            }
            
            DispatchQueue.main.async {
              self.isGettingQuote = false
              self.updateQuote()
            }
        })
        
        print("***END GETTING QUOTE")
        dataTask.resume()
        
    }
    
    func updateQuote(){
        if isGettingQuote{
            quote.text = "Retrieving daily quote!"
        } else if quoteContext == "N/A" {
            quote.text = "Sorry, could not retrieve quote today."
        } else if quoteContext != "N/A" {
            if authorName == "N/A" {
                authorName = "unknown"
            }
            //let finalquote = quoteContext + "\n" + "\t" + "\t" + "- " + authorName
            quote.text = quoteContext
            
            authorLabel.text = authorName
        }
    }
    
    
    

}

