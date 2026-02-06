//
//  AddNoteView.swift
//  WeatherNotes
//
//  Created by Maks on 06.02.26.
//

import SwiftUI

struct AddNoteView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var events: [Event]
    @StateObject private var vm = AddNoteViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            
            TextField("Enter note title", text: $vm.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Text("Weather: \(vm.weather)")
                .foregroundColor(.gray)
            
            Button(action: {
                vm.saveNote(events: &events) {
                    dismiss()
                }
            }) {
                if vm.isSaving {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                } else {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(vm.title.isEmpty ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .disabled(vm.title.isEmpty || vm.isSaving)
            
            Spacer()
        }
        .padding()
        .onAppear {
            vm.fetchWeather()
        }
    }
}
