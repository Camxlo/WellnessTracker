import SwiftUI

struct SettingsView: View {
    @AppStorage("useDark") private var useDark: Bool = false
    @AppStorage("reminderHour") private var reminderHour: Int = 21
    @AppStorage("reminderMinute") private var reminderMinute: Int = 0
    
    var body: some View {
        Form {
            Section("Apariencia") {
                Toggle("Usar tema oscuro", isOn: $useDark)
            }
            Section("Recordatorio diario") {
                DatePicker("Hora", selection: Binding(
                    get: { Calendar.current.date(from: DateComponents(hour: reminderHour, minute: reminderMinute)) ?? Date() },
                    set: { let c = Calendar.current.dateComponents([.hour,.minute], from: $0)
                        reminderHour = c.hour ?? 21; reminderMinute = c.minute ?? 0
                        NotificationService.shared.scheduleDaily(hour: reminderHour, minute: reminderMinute)
                    }), displayedComponents: .hourAndMinute)
            }
            Section("Acerca de") {
                LabeledContent("Versión", value: (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "1.0")
                LabeledContent("Bundle ID", value: Bundle.main.bundleIdentifier ?? "-")
            }
        }
        .navigationTitle("Ajustes")
        .onAppear { NotificationService.shared.requestAuthorization() }
        .preferredColorScheme(useDark ? .dark : nil)
    }
}
