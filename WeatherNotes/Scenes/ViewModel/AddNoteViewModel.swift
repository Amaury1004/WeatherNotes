final class AddNoteViewModel: ObservableObject {

    @Published var title: String = ""

    // Weather fields
    @Published var description: String = ""
    @Published var temperature: Double = 0
    @Published var feelsLike: Double = 0
    @Published var humidity: Int = 0
    @Published var pressure: Int = 0
    @Published var windSpeed: Double = 0
    @Published var iconCode: String = ""

    @Published var isSaving: Bool = false

    func fetchWeather() {
        let request = WeatherNotesRequest.GetWeather(lat: 50.45, lon: 30.52)

        ServerManager.shared.request(request) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }

                switch result {
                case .success(let response):
                    guard let weather = response.weather.first else { return }

                    self.description = weather.description.capitalized
                    self.temperature = response.main.temp
                    self.feelsLike = response.main.feels_like
                    self.humidity = response.main.humidity
                    self.pressure = response.main.pressure
                    self.windSpeed = response.wind.speed
                    self.iconCode = weather.icon

                case .failure:
                    print("Failed to load weather")
                }
            }
        }
    }

    func saveNote(events: inout [Event], completion: @escaping () -> Void) {
        isSaving = true

        let newEvent = Event(
            title: title,
            description: description,
            temperature: temperature,
            feelsLike: feelsLike,
            humidity: humidity,
            pressure: pressure,
            windSpeed: windSpeed,
            iconCode: iconCode,
            date: Date()
        )

        events.append(newEvent)
        UserDefaults.standard.saveEvents(events)

        isSaving = false
        completion()
    }
}