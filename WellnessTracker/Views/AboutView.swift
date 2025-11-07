import SwiftUI


struct AboutView: View {
    private let description = """
WellnessTracker es una app de ejemplo hecha en SwiftUI para registrar hábitos de bienestar: estado de ánimo, energía, horas de sueño y despertares nocturnos. Incluye historial, resumen y estadísticas.


Créditos: Camilo Andrés Llantén Castrillón y Alejandro Prieto Cardona.
Repositorio: pegue aquí la URL del repo.
"""
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Descripción y créditos").font(.title2).bold()
                    Text(description)
                    GroupBox("Cómo se construyó") {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("SwiftUI • NavigationStack • TabView", systemImage: "swift")
                            Label("Form con TextField, DatePicker, Picker, Slider, Stepper", systemImage: "square.and.pencil")
                            Label("Gestión de estado con @State / @EnvironmentObject", systemImage: "externaldrive.badge.icloud")
                            Label("Persistencia JSON local (extra)", systemImage: "tray.full.fill")
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Acerca de")
        }
    }
}
