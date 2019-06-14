//
//  Webservice.swift
//  Weather
//
//  Created by Romit on 14/06/19.
//  Copyright © 2019 Romit. All rights reserved.
//

import Foundation
import CoreLocation

struct Sys : Codable {
	var sunrise:TimeInterval?
	var sunset:TimeInterval?
}


struct Weather : Codable {
	var id:Int?
	var main:String?
	var description:String?
	var icon:String?
}

struct Wind : Codable {
	var deg:Float?
	var speed:Float?
}

struct MainData : Codable {
	var grnd_level:Double?
	var humidity:Int?
	var pressure:Double?
	var sea_level:Double?
	var temp:Double?
	var temp_max:Double?
	var temp_min:Double?
}

struct Coordinate : Codable {
	var lat:Double?
	var lon:Double?
}

struct Clouds : Codable {
	var all:Int?
}


struct LocationWeather : Codable {
	var dt : TimeInterval?
	var visibility : Int?
	var id : Int?
	var cod : Int?
	var coord : Coordinate?
	var clouds : Clouds?
	var main : MainData?
	var wind : Wind?
	var name : String?
	var weather : [Weather]?
	var sys : Sys?
}

struct LocationList : Codable {
	var list = [LocationWeather]()
}


class Webservice {

	private let url = "http://api.openweathermap.org/data/2.5/group"
	private let APIKey = "9cae4fd15c20b995700a46a8a5211e70"

	func getWeather(ids: String, responseHandler: @escaping (LocationList) -> Void, responseFailHandler: @escaping (Error) -> Void) {

//		http://api.openweathermap.org/data/2.5/group?id=1850147,6058560&units=metric&appid=9cae4fd15c20b995700a46a8a5211e70

		let requestUrl = URL(string: self.url + "?id=" + ids + "&units=metric&appid=" + APIKey)!

		print(requestUrl)
		
		// This is a pretty simple networking task, so the shared session will do.
		let session = URLSession.shared
		session.configuration.timeoutIntervalForRequest = 3

		let dataTask = session.dataTask(with: requestUrl) { (data: Data?, response: URLResponse?, error: Error?) in

			if error != nil {
				responseFailHandler(error!);
			}
			else {

				do {
					let json = try JSONSerialization.jsonObject(with: data!,options: .mutableContainers) as! [String: Any]
					print(json)
				}
				catch let error {

					DispatchQueue.main.async {
						responseFailHandler(error);
					}
				}

				let weather : LocationList = try! JSONDecoder().decode(LocationList.self, from: data!)
				print(weather.list)

				if(weather.list.count > 0)
				{
					DispatchQueue.main.async {
						responseHandler(weather);
					}
				}
				else{
					DispatchQueue.main.async {
						responseFailHandler(NSError.init(domain: "Something went wrong", code: 0, userInfo: [:]));
					}
				}
			}
		}
		dataTask.resume()
	}
}


extension TimeInterval {

	func getTime(formate : String = "hh:mm a") -> String
	{
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = formate
		return dateFormatter.string(from: Date.init(timeIntervalSince1970: self))
	}
}
