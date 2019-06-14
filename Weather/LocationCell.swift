//
//  LocationCell.swift
//  Weather
//
//  Created by Romit on 14/06/19.
//  Copyright © 2019 Rumbum Software Service Private Limited. All rights reserved.
//

import UIKit



class LocationCell: UITableViewCell {

	private let baseImageURL = "http://openweathermap.org/img/w/%@.png"

	@IBOutlet weak var imgView: UIImageView?
	@IBOutlet weak var lblTitle: UILabel?
	@IBOutlet weak var lblDescription: UILabel?

	@IBOutlet weak var lblTemperature: UILabel?

	var tempCelsius: Double {
		get {
			return self.dataObject!.main!.temp!
		}
	}

	var dataObject : LocationWeather?
	{
		didSet{
			self.lblTitle?.text = self.dataObject?.name
			self.lblDescription?.text = self.dataObject?.weather?.first?.description

			do{
				let data : Data = try Data.init(contentsOf: URL.init(string: String(format: self.baseImageURL, (self.dataObject?.weather?.first!.icon)!))!)
				self.imgView?.image = UIImage.init(data: data)
			}
			catch{}

			self.lblTemperature?.text = String(self.tempCelsius) + " °C"
		}
	}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
