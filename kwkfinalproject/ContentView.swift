import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}

struct ContentView: View {
    @State private var selectedDate = Date()
    @State private var events: [Date: [String]] = [:]
    @State private var shouldShowEventEntry = false

    let backgroundColor = Color(hex: "#F283B6") // Pink background color
    let textColor = Color(hex: "#F283B6") // Pink text color for events
    let arrowColor = Color(hex: "#00FF00") // Green color for arrows

    var body: some View {
        VStack {
            FormattedDateView(selectedDate: selectedDate, omitTime: true)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding()

            Divider().frame(height: 1)

            // Custom DatePicker
            CustomDatePicker(selectedDate: $selectedDate, shouldShowEventEntry: $shouldShowEventEntry)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding()

            Divider()

            let normalizedDate = normalizeDate(selectedDate)
            if let dayEvents = events[normalizedDate] {
                List(dayEvents, id: \.self) { event in
                    Text(event)
                        .foregroundColor(textColor) // Pink text color for events
                }
                .background(backgroundColor)
            } else {
                Text("No events")
                    .foregroundColor(textColor) // Pink text color for "No events"
                    .background(backgroundColor)
            }
        }
        .background(backgroundColor.ignoresSafeArea())
        .sheet(isPresented: $shouldShowEventEntry) {
            EventEntryView(date: selectedDate, events: $events, isPresented: $shouldShowEventEntry)
        }
        .onChange(of: selectedDate) { newDate in
            // Only trigger the sheet if the date is explicitly selected by the user
            // Avoid triggering when changing months
            if isExplicitDateSelection(newDate) {
                shouldShowEventEntry = true
            }
        }
    }

    private func normalizeDate(_ date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return calendar.date(from: components)!
    }

    private func isExplicitDateSelection(_ date: Date) -> Bool {
        // Check if the date change is due to explicit selection and not month navigation
        let calendar = Calendar.current
        return calendar.component(.day, from: date) != calendar.component(.day, from: selectedDate)
    }
}

struct EventEntryView: View {
    var date: Date
    @Binding var events: [Date: [String]]
    @Binding var isPresented: Bool
    @Environment(\.presentationMode) var presentationMode
    @State private var newEventTitle = ""

    let backgroundColor = Color(hex: "#F283B6") // Pink background color
    let textColor = Color.white // White text color for event header and button
    let textFieldTextColor = Color.black // Black text color for event title text field

    var body: some View {
        VStack {
            Text("Add Event for \(formattedDate(for: date))")
                .foregroundColor(textColor) // White text color for header
                .font(.headline)
                .padding()

            TextField("Event Title", text: $newEventTitle)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(backgroundColor)
                .foregroundColor(textFieldTextColor) // Black text color for text field
                .padding()

            Button(action: saveEvent) {
                Text("Save")
                    .font(.headline)
                    .padding()
                    .background(textColor)
                    .foregroundColor(backgroundColor) // Set button text color to white
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding()

            Spacer()
        }
        .padding()
        .background(backgroundColor.ignoresSafeArea())
    }

    private func saveEvent() {
        let normalizedDate = normalizeDate(date)
        if !newEventTitle.isEmpty {
            if events[normalizedDate] == nil {
                events[normalizedDate] = []
            }
            events[normalizedDate]?.append(newEventTitle)
            newEventTitle = ""
        }
        // Dismiss the sheet
        isPresented = false
    }

    private func formattedDate(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }

    private func normalizeDate(_ date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return calendar.date(from: components)!
    }
}

struct FormattedDateView: View {
    var selectedDate: Date
    var omitTime: Bool = false

    let backgroundColor = Color(hex: "#F283B6") // Pink background color
    let textColor = Color.white // White text color for selected date

    var body: some View {
        Text(formattedSelectedDate)
            .font(.headline)
            .padding()
            .background(backgroundColor)
            .foregroundColor(textColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private var formattedSelectedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = omitTime ? .none : .short
        return formatter.string(from: selectedDate)
    }
}

struct CustomDatePicker: View {
    @Binding var selectedDate: Date
    @Binding var shouldShowEventEntry: Bool
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()

    let arrowColor = Color(hex: "#00FF00") // Green color for arrows

    var body: some View {
        VStack {
            // Header with month and year
            HStack {
                Button(action: {
                    // Update the selected date to the previous month
                    selectedDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(arrowColor) // Green arrows
                        .padding()
                }
                Spacer()
                Text(dateFormatter.string(from: selectedDate))
                    .font(.headline)
                    .foregroundColor(.white) // White color for month and year
                Spacer()
                Button(action: {
                    // Update the selected date to the next month
                    selectedDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(arrowColor) // Green arrows
                        .padding()
                }
            }
            .padding()

            // Days of the week
            HStack {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .foregroundColor(.white) // White color for days of the week
                        .frame(maxWidth: .infinity)
                }
            }

            // Calendar grid
            let days = calendar.range(of: .day, in: .month, for: selectedDate)!
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate))!
            let firstDayOfMonth = calendar.component(.weekday, from: startOfMonth)
            let numberOfDays = days.count
            let totalCells = numberOfDays + (firstDayOfMonth - 1)

            let rows = (totalCells / 7) + (totalCells % 7 > 0 ? 1 : 0)

            VStack(spacing: 4) {
                ForEach(0..<rows, id: \.self) { row in
                    HStack(spacing: 4) {
                        ForEach(0..<7, id: \.self) { column in
                            let dayIndex = (row * 7) + column - (firstDayOfMonth - 1)
                            if dayIndex >= 1 && dayIndex <= numberOfDays {
                                Text("\(dayIndex)")
                                    .foregroundColor(.white) // White text for calendar days
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(self.selectedDateComponentsEqual(day: dayIndex) ? Color.gray : Color.clear)
                                    .clipShape(Circle())
                                    .onTapGesture {
                                        let dateComponents = DateComponents(year: calendar.component(.year, from: selectedDate), month: calendar.component(.month, from: selectedDate), day: dayIndex)
                                        selectedDate = calendar.date(from: dateComponents) ?? selectedDate
                                        // Trigger sheet display only when a date is explicitly selected
                                        shouldShowEventEntry = true
                                    }
                            } else {
                                Text("")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                        }
                    }
                }
            }
        }
    }

    private func selectedDateComponentsEqual(day: Int) -> Bool {
        let components = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        return components.day == day
    }
}

struct DatePickerCalendar_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

