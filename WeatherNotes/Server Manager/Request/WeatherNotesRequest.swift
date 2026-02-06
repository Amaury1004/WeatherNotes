//
//  WeatherRequest.swift
//  WeatherNotes
//
//  Created by Maks on 06.02.26.
//

import Foundation

struct WeatherNotesRequest {
    
    struct WeatherRequest: Encodable {
        
        let  request: Request
            
        struct Request: Encodable {
            
            let lat: Double
            let lon: Double
            let lang: String = "ua"
            let units: String = "metric"
        }
    }
    
    struct GetWeather: NetworkReqest {
        
        typealias Response = WeatherNotesResponce.WeatherResponce
        typealias Request = WeatherNotesRequest.WeatherRequest.Request
        
        var method: String
        var parameters: WeatherNotesRequest.WeatherRequest.Request?
        
        init(lat: Double, lon: Double) {
            self.method = "weather/"
            self.parameters = WeatherRequest.Request(lat: lat, lon: lon)
        }
    }
}
