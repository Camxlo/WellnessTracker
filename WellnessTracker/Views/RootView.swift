import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {

            // 🏠 Inicio / Dashboard
            NavigationStack {
                DashboardView()
            }
            .tabItem { Label("Inicio", systemImage: "house.fill") }

            // 📋 Historial
            NavigationStack {
                HistoryView()
            }
            .tabItem { Label("Historial", systemImage: "list.bullet") }

            // ➕ Nueva entrada
            NavigationStack {
                NewEntryView()
                
            }   // isModal = false por defecto
            .tabItem { Label("Nueva", systemImage: "plus.circle") }

            // 📊 Estadísticas
            NavigationStack {
                StatsView()
            }
            .tabItem { Label("Estadísticas", systemImage: "chart.bar.fill") }

            // ⚙️ Ajustes
            NavigationStack {
                SettingsView()
            }
            .tabItem { Label("Ajustes", systemImage: "gearshape") }

            // ℹ️ Acerca de
            NavigationStack {
                AboutView()
            }
            .tabItem { Label("Acerca de", systemImage: "info.circle.fill") }
        }
        .onAppear {
            // ✅ Verifica el Bundle ID (útil para Firebase)
            print("BUNDLE ID:", Bundle.main.bundleIdentifier ?? "nil")
        }
    }
}

