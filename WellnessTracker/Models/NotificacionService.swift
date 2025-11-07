import Foundation
import UserNotifications

final class NotificationService {
    static let shared = NotificationService()
    private init() {}
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { ok, err in
            if let err = err { print("🔔 Permiso notif error:", err) }
            else { print("🔔 Permiso notif:", ok) }
        }
    }
    
    func scheduleDaily(hour: Int, minute: Int) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["dailyReminder"])
        
        var date = DateComponents()
        date.hour = hour; date.minute = minute
        
        let content = UNMutableNotificationContent()
        content.title = "Registra tu día"
        content.body = "Añade tu energía y horas de sueño de hoy."
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let req = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)
        center.add(req)
    }
}
