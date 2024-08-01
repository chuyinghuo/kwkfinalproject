//
// ContentView.swift
// finalprojectkwk
//
// Created by Isha Acharya on 8/1/24.
//
import SwiftUI
struct ContentView: View {
  var body: some View {
    NavigationStack{
      NavigationLink(destination: Calendars()) {
        Text("Calendar")
      }
      .foregroundStyle(Color(red: 0.949, green: 0.514, blue: 0.714))
      .frame(width: 230.0, height: 40)
      .background(Color(red: 0.729, green: 0.959, blue: 0.782))
      .cornerRadius(100)
      .font(.title)
      .padding()
      NavigationLink(destination: ContentView2()) {
        Text("To-Do List")
      }
      .foregroundStyle(Color(red: 0.949, green: 0.514, blue: 0.714))
      .frame(width: 230.0, height: 40)
      .background(Color(red: 0.729, green: 0.959, blue: 0.782))
      .cornerRadius(100)
      .font(.title)
      .padding()
      NavigationLink(destination: TechBytes()) {
        Text("Daily TechByte")
      }
      .foregroundStyle(Color(red: 0.949, green: 0.514, blue: 0.714))
      .frame(width: 230.0, height: 40)
      .background(Color(red: 0.729, green: 0.959, blue: 0.782))
      .cornerRadius(100)
      .font(.title)
      .padding()
      NavigationLink(destination: Pomodoro()) {
        Text("Pomodoro")
      }
      .foregroundStyle(Color(red: 0.949, green: 0.514, blue: 0.714))
      .frame(width: 230.0, height: 40)
      .background(Color(red: 0.729, green: 0.959, blue: 0.782))
      .cornerRadius(100)
      .font(.title)
      .padding()
    }
  }
}
#Preview {
  ContentView()
}
