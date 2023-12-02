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
