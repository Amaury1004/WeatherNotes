//
//  WeatherNotesResponce.swift
//  WeatherNotes
//
//  Created by Maks on 06.02.26.
//

struct WeatherNotesResponce {
    
    struct Weatherresponce: Decodable {
        let weather: [Weather]
        let main: Main
    }
    struct Weather: Codable {
        let main: String
        let description: String
        let icon: String
    }
    struct Main: Codable {
        let temp: Double
    }
}
