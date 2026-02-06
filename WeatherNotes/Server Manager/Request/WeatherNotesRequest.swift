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
            
            let language: String = "ukr"
            let units: String = "metric"
            
            let page: Int
        }
    }
    
    struct GetWeather: NetworkReqest {
        
        typealias Response = WeatherNotesResponce.Weather
        typealias Request = WeatherNotesRequest.WeatherRequest.Request
        
        var method: String
        var parameters: WeatherNotesRequest.WeatherRequest.Request
        
        init(method: String, parameters: WeatherNotesRequest.WeatherRequest.Request) {
            self.method = method
            self.parameters = WeatherRequest.Request.init(lat: 0, lon: 0, page: 1)
        }
    }
}
