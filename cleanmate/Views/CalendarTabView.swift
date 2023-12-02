//
//  RedTabView.swift
//  cleanmate
//
//  Created by 김선규 on 11/20/23.
//

import SwiftUI
import Combine

class CalendarController: ObservableObject {
    struct SelectedDateItem: Identifiable {
        let id = UUID()
        let date: Date
    }

    @Published var selectedDate: SelectedDateItem?
    @Published var currentMonth: Date = Date()
    private let numberOfYearsToShow = 2 // 표시할 연도 범위

    func monthsInYears() -> [Date] {
        var months: [Date] = []
        let calendar = Calendar.current
        let startYear = calendar.component(.year, from: Date())
        let endYear = startYear + numberOfYearsToShow - 1

        for year in startYear...endYear {
            for monthIndex in 1...12 {
                guard let date = calendar.date(bySetting: .year, value: year, of: calendar.date(bySetting: .month, value: monthIndex, of: currentMonth)!) else {
                    continue
                }
                months.append(date)
            }
        }

        return months
    }

    static func startDayOfMonth(_ month: Date) -> Int {
            guard let firstDayOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: month)) else {
                return 0
            }

            let dayOfWeek = Calendar.current.component(.weekday, from: firstDayOfMonth)
            return (dayOfWeek + 5) % 7
        }
    }

struct CalendarTabView: View {
    
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


