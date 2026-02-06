//
//  AddViewModel.swift
//  WeatherNotes
//
//  Created by Maks on 06.02.26.
//

import SwiftUI
import Combine

final class AddNoteViewModel: ObservableObject {
    
    @Published var title: String = ""
    @Published var weather: String = "Loading..."
    @Published var iconURL: URL? = nil
    @Published var isSaving: Bool = false
        
    func fetchWeather() {
        let request = WeatherNotesRequest.GetWeather(lat: 50.45, lon: 30.52)
        ServerManager.shared.request(request) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    guard let firstWeather = response.weather.first else {
                        self?.weather = "Нема данних про погоду "
                        return
                    }
                    
                    let condition = firstWeather.description.capitalized
                    let temp = Int(response.main.temp)
                    self?.weather = "\(condition), \(temp)°C"
                    
                    let iconCode = firstWeather.icon
                    self?.iconURL = URL(string: "https://openweathermap.org/img/wn/\(iconCode)@2x.png")
                case .failure(let error):
                    print(error)
                    self?.weather = "Failed to load"
                }
            }
        }
    }
    
    func saveNote(events: inout [Event], completion: @escaping () -> Void) {
        isSaving = true
        let newEvent = Event(title: title, iconURLString: iconURL?.absoluteString, weather: weather, data: Date(),)
        events.append(newEvent)
        UserDefaults.standard.saveEvents(events)
        isSaving = false
        completion()
    }
}
