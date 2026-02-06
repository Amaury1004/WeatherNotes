//
//  NotesListView.swift
//  WeatherNotes
//
//  Created by Maks on 06.02.26.
//

import SwiftUI

struct Event: Identifiable, Codable {
    var id = UUID()
    var title: String
    var iconURLString: String?
    var weather: String
    var data: Date = Date()
}

import SwiftUI

struct NotesListView: View {
    
    @State private var events: [Event] = UserDefaults.standard.loadEvents()
    @State private var showingAddNote = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach($events, id: \.id) { $event in
                        HStack(alignment: .center, spacing: 10) {
                            // Иконка
                            if let url = event.iconURL {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 50, height: 50)
                                }
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 50, height: 50)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(event.title)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                Text(event.weather)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text(event.data, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(6)
                        .cornerRadius(8)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            handleTap(event: $event)
                        }
                    }
                }
                
                Button(action: {
                    showingAddNote = true
                }) {
                    Text("Add Note")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .sheet(isPresented: $showingAddNote) {
                    AddNoteView(events: $events)
                }
            }
            .navigationTitle("Notes")
        }
    }
    func handleTap(event: Binding<Event>) {
        print("Tapped on: \(event.title)")
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

extension Event {
    var iconURL: URL? {
        guard let str = iconURLString else { return nil }
        return URL(string: str)
    }
}
