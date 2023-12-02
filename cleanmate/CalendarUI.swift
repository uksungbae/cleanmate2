import SwiftUI
import Combine

struct CalendarUI: View {
    @ObservedObject var calendarController = CalendarController()

    var body: some View {
        NavigationView {
            TabView(selection: $calendarController.currentMonth) {
                ForEach(calendarController.monthsInYears(), id: \.self) { month in
                    MonthView(month: month, selectedDate: $calendarController.selectedDate)
                        .tag(month)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .onAppear {
                UIScrollView.appearance().isPagingEnabled = true
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(action: {
                    calendarController.currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: calendarController.currentMonth) ?? calendarController.currentMonth
                }) {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.blue)
                },
                trailing: Button(action: {
                    calendarController.currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: calendarController.currentMonth) ?? calendarController.currentMonth
                }) {
                    Image(systemName: "chevron.right")
                        .imageScale(.large)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.blue)
                }
            )
            .onChange(of: calendarController.currentMonth) { newMonth in
                calendarController.selectedDate = nil
            }
        }
    }
}

struct MonthView: View {
    let id = UUID()
    let month: Date
    @Binding var selectedDate: CalendarController.SelectedDateItem?

    var body: some View {
        VStack {
            Text(month, formatter: monthFormatter)
                .font(.title)
                .padding()

            Text(selectedDate.map { formatDate($0.date) } ?? "No date selected")
                .padding()

            LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 15) {
                ForEach(0..<CalendarController.startDayOfMonth(month), id: \.self) { _ in
                    Text("")
                        .frame(width: 30, height: 30)
                        .hidden()
                }

                ForEach(daysInMonth(month), id: \.self) { day in
                    Button(action: {
                        selectedDate = CalendarController.SelectedDateItem(date: day)
                    }) {
                        Text("\(day, formatter: dayOfMonthFormatter)")
                            .frame(width: 30, height: 30)
                            .padding(5)
                            .background(
                                Circle()
                                    .fill(selectedDate?.date == day ? Color.blue : Color.clear)
                            )
                    }
                }
            }
            .padding()
        }
        .sheet(item: $selectedDate) { selectedDate in
            Text("Selected Date: \(formatDate(selectedDate.date))")
                .padding()
        }
    }


    private func daysInMonth(_ month: Date) -> [Date] {
        guard let range = Calendar.current.range(of: .day, in: .month, for: month),
              let firstDayOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: month))
        else {
            return []
        }

        let days = (0..<range.count).compactMap { Calendar.current.date(byAdding: .day, value: $0, to: firstDayOfMonth) }
        return days
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }

    private var dayOfMonthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }
}

struct CalendarUI_Previews: PreviewProvider {
    static var previews: some View {
        CalendarUI()
    }
}
