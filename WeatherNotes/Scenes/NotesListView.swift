//
//  NotesListView.swift
//  WeatherNotes
//
//  Created by Maks on 06.02.26.
//


import SwiftUI

// Модель события
struct Event: Identifiable, Codable {
    var id = UUID()
    var title: String
    var weather: String
    var data: Date = Date()
}
struct NotesListView: View {
    
    // Моковые данные
    @State private var events: [Event] = UserDefaults.standard.loadEvents().isEmpty ? [
        Event(title: "Прогулянка в парку", weather: "Сонячно"),
        Event(title: "Зустріч з друзями", weather: "Хмарно"),
        Event(title: "Уроки по SwiftUI", weather: "Дощ")
    ] : UserDefaults.standard.loadEvents()
    
    var body: some View {
        NavigationView {
            VStack {
                List(events) { event in
                    VStack(alignment: .leading) {
                        Text(event.title)
                            .font(.headline)
                        Text(event.weather)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                }
                
                Button(action: {
                    let new = Event(title: "Нова нотатка", weather: "Без опадів")
                    events.append(new)
                    UserDefaults.standard.saveEvents(events)
                }) {
                    Text("Add Note")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                }
            }
            .onDisappear { UserDefaults.standard.saveEvents(events) }
            .navigationTitle("Notes")
        }
    }
}
extension UserDefaults {
    
    private static let eventsKey = "events"
    
    func saveEvents(_ events: [Event]) {
        if let data = try? JSONEncoder().encode(events) {
            set(data, forKey: Self.eventsKey)
        }
    }
    
    func loadEvents() -> [Event] {
        if let data = data(forKey: Self.eventsKey),
           let events = try? JSONDecoder().decode([Event].self, from: data) {
            return events
        }
        return []
    }
}

