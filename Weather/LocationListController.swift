//
//  LocationListController.swift
//  Weather
//
//  Created by Romit on 14/06/19.
//  Copyright © 2019 Rumbum Software Service Private Limited. All rights reserved.
//

import UIKit
import CoreLocation

class LocationListController: UITableViewController {

	private var _array : [String]?
	var array : [String]
	{
		get{
			if(_array == nil)
			{
				_array = self.loadJson()
			}
			return _array!
		}
		set{
			_array = newValue
		}
	}

	private var locationManager = CLLocationManager()

	private var locationArray : LocationList?

    override func viewDidLoad() {
        super.viewDidLoad()

		self.title = "Weather"
		self.getCurrentLocation()
    }

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	func getCurrentLocation()
	{
		self.locationManager.distanceFilter = 300
		self.locationManager.delegate = self
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
		self.locationManager.requestAlwaysAuthorization()

		if CLLocationManager.locationServicesEnabled(){
			self.locationManager.startUpdatingLocation()
		}
	}

	func loadLocation()
	{
		Webservice.init().getWeather(ids: self.array.joined(separator: ","), responseHandler: { (locationList) in

			print(locationList)

			self.locationArray = locationList
			self.tableView.reloadData()

		}) { (error) in

			print(error)
		}
	}

	func getCityID(city : String) -> String?
	{
		if let path = Bundle.main.path(forResource: "city.list", ofType: "json") {
			do {
				let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
				let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
				if let jsonResult = jsonResult as? [[String : Any]]{

					if let index = jsonResult.firstIndex(where: {$0["name"] as? String == city}) {
						print(jsonResult[index])

						if let value : NSNumber = jsonResult[index]["id"] as? NSNumber
						{
							return value.stringValue
						}

					}
				}
			} catch {}
		}
		return nil
	}

	func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
		-> Void ) {
		// Use the last reported location.
		if let lastLocation = self.locationManager.location {
			let geocoder = CLGeocoder()

			// Look up the location and pass it to the completion handler
			geocoder.reverseGeocodeLocation(lastLocation,
											completionHandler: { (placemarks, error) in
												if error == nil {
													let firstLocation = placemarks?[0]
													completionHandler(firstLocation)
												}
												else {
													// An error occurred during geocoding.
													completionHandler(nil)
												}
			})
		}
		else {
			// No location was available.
			completionHandler(nil)
		}
	}

	func loadJson() -> [String]
	{
		if let path = Bundle.main.path(forResource: "location", ofType: "json") {
			do {
				let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
				let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
				if let jsonResult = jsonResult as? Dictionary<String, AnyObject>{

					return (jsonResult["locations"] as? [String])!
				}
			} catch {}
		}
		return []
	}

	// MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

		guard self.locationArray != nil else {
			return 0
		}
		return (self.locationArray?.list.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell : LocationCell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationCell
	
		cell.dataObject = self.locationArray?.list[indexPath.row]
        return cell
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		let viewController : WeatherDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "weatherDetailsViewController") as! WeatherDetailsViewController
		viewController.weatherDetails = self.locationArray?.list[indexPath.row]
		self.navigationController?.pushViewController(viewController, animated: true)
	}
}


extension LocationListController : CLLocationManagerDelegate
{
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

		manager.stopUpdatingLocation()

		self.lookUpCurrentLocation { (placemark) in

			if(placemark?.locality != nil)
			{
				let currentCityID = self.getCityID(city: (placemark?.locality)!)

				self.array.insert(currentCityID!, at: 0)
			}
			self.loadLocation()
		}
	}

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error)

		let lblError = UILabel.init()
		lblError.text = error.localizedDescription
		lblError.numberOfLines = 0
		lblError.sizeThatFits(CGSize.init(width: self.tableView.frame.width - 32, height: self.tableView.frame.height))
		lblError.textColor = UIColor.white
		lblError.textAlignment = .center
		self.tableView.backgroundView = lblError
	}
}
