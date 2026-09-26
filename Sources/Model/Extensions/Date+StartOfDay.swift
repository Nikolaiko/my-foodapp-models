import Foundation

extension Date {
    /// Начало дня (00:00:00) по UTC — одинаково на сервере и на любом устройстве,
    /// не зависит от `Calendar.current` и часового пояса.
    var startOfDayUTC: Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar.startOfDay(for: self)
    }
}
