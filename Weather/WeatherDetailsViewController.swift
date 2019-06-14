//
//  WeatherDetailsViewController.swift
//  Weather
//
//  Created by Romit on 14/06/19.
//  Copyright © 2019 Rumbum Software Service Private Limited. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherDetailsViewController: UIViewController {

	private let baseImageURL = "http://openweathermap.org/img/w/%@.png"

	@IBOutlet weak var lblArea : UILabel!
	@IBOutlet weak var lblAtmosphere : UILabel!
	@IBOutlet weak var lblTemperature : UILabel!
	@IBOutlet weak var lblLowestTemperature : UILabel!
	@IBOutlet weak var lblHighestTemperature : UILabel!
	@IBOutlet weak var lblSunrise : UILabel!
	@IBOutlet weak var lblSunset : UILabel!
	@IBOutlet weak var lblHumidity : UILabel!
	@IBOutlet weak var lblPressure : UILabel!
	@IBOutlet weak var lblCloud : UILabel!
	@IBOutlet weak var lblWind : UILabel!

	@IBOutlet weak var imgView : UIImageView!

	var coordinates : CLLocationCoordinate2D?

	var tempCelsius: Double {
		get {
			return (self.weatherDetails!.main?.temp)!
		}
	}

	var lowTempCelsius: Double {
		get {
			return (self.weatherDetails!.main?.temp_min)!
		}
	}

	var highTempCelsius: Double {
		get {
			return (self.weatherDetails!.main?.temp_max)!
		}
	}

	var weatherDetails : LocationWeather?

	private var _webservice : Webservice?
	var webservice : Webservice?
	{
		get{
			if(_webservice == nil)
			{
				_webservice = Webservice()
			}
			return _webservice
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		self.updateUI()
	}

	func updateUI()
	{
		DispatchQueue.global(qos: .background).async {

			do{
				let data : Data = try Data.init(contentsOf: URL.init(string: String(format: self.baseImageURL, (self.weatherDetails?.weather?.first!.icon)!))!)

				DispatchQueue.main.async {
					self.imgView?.image = UIImage.init(data: data)
				}
			}
			catch{}
		}


		self.lblArea.text = self.weatherDetails?.name
		self.lblTemperature.text = String(format:"%.0f °C", self.tempCelsius)
		self.lblAtmosphere.text = self.weatherDetails?.weather?.first?.description
		self.lblLowestTemperature.text = String(format:"%.0f °C", self.lowTempCelsius)
		self.lblHighestTemperature.text = String(format:"%.0f °C", self.highTempCelsius)

		self.lblSunrise.text = self.weatherDetails?.sys?.sunrise?.getTime()
		self.lblSunset.text = self.weatherDetails?.sys?.sunset?.getTime()

		self.lblHumidity.text = String(format:"%d %%",(self.weatherDetails?.main?.humidity)!)
		self.lblPressure.text = String(format:"%.2f mb",(self.weatherDetails?.main?.pressure)!)

		self.lblCloud.text = String(format:"%d %%",(self.weatherDetails?.clouds?.all)!)
		self.lblWind.text = String(format:"%.1f m/s",(self.weatherDetails?.wind?.speed)!)

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
