import SwiftUI

struct NewEntryView: View {
    @EnvironmentObject var model: AppModel
    @Environment(\.dismiss) private var dismiss

    let original: Entry?
    let isModal: Bool

    // ---- Estado del formulario ----
    @State private var title: String = ""
    @State private var date: Date = Date()
    @State private var mood: Mood = .ok
    @State private var energy: Int = 5
    @State private var sleepHours: Double = 7.0
    @State private var wakeups: Int = 0
    @State private var notes: String = ""

    // banner de confirmación
    @State private var showSavedBanner = false

    init(original: Entry? = nil, isModal: Bool = false) {
        self.original = original
        self.isModal = isModal
    }

    var body: some View {
        Form {
            Section("GENERAL") {
                TextField("Título", text: $title)
                DatePicker("Fecha", selection: $date, displayedComponents: .date)
                Picker("Estado de ánimo", selection: $mood) {
                    ForEach(Mood.allCases) { m in
                        Text(m.rawValue).tag(m)
                    }
                }
            }

            Section("SALUD") {
                HStack {
                    Text("Energía: \(energy)")
                    Slider(value: Binding(get: { Double(energy) },
                                          set: { energy = Int($0) }),
                           in: 1...10, step: 1)
                }
                Stepper("Horas de sueño: \(sleepHours, specifier: "%.1f") h",
                        value: $sleepHours, in: 0...16, step: 0.5)

                Stepper("Despertares nocturnos: \(wakeups)",
                        value: $wakeups, in: 0...10, step: 1)
            }

            Section("NOTAS") {
                TextEditor(text: $notes)
                    .frame(minHeight: 140)
                    .foregroundStyle(.primary)
            }
        }
        .navigationTitle(original == nil ? "Nueva entrada" : "Editar entrada")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancelar") { cancel() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Guardar") { save() }.bold()
            }
        }
        .onAppear { loadIfEditing() }
        .overlay(alignment: .top) {
            if showSavedBanner {
                Text("Guardado ✅")
                    .padding(.horizontal, 16).padding(.vertical, 8)
                    .background(.thinMaterial)
                    .clipShape(Capsule())
                    .padding(.top, 12)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: showSavedBanner)
    }

    // MARK: - Helpers

    private func loadIfEditing() {
        guard let e = original else { return }
        title      = e.title
        date       = e.date
        mood       = e.mood
        energy     = e.energy
        sleepHours = e.sleptHours
        wakeups    = e.wakeups
        notes      = e.notes
    }

    private func save() {
        // Crea o actualiza respetando el orden del init de Entry:
        var e = original ?? Entry(
            id: UUID().uuidString,
            date: date,                                 // <- date ANTES que title
            title: title.isEmpty ? "Entrada" : title,
            mood: mood,
            energy: energy,
            sleptHours: sleepHours,                     // usa 'sleptHours'
            wakeups: wakeups,
            notes: notes
        )

        if original != nil {
            e.title = title.isEmpty ? "Entrada" : title
            e.date = date
            e.mood = mood
            e.energy = energy
            e.sleptHours = sleepHours
            e.wakeups = wakeups
            e.notes = notes
            model.update(e)
        } else {
            model.add(e)
        }

        if isModal {
            dismiss()          // si es hoja, ciérrala
        } else {
            resetForm()        // si es el tab, limpia
            flashSavedBanner()
        }
    }

    private func cancel() {
        if isModal { dismiss() } else { resetForm() }
    }

    private func resetForm() {
        title = ""
        date = Date()
        mood = .ok
        energy = 5
        sleepHours = 7.0
        wakeups = 0
        notes = ""
    }

    private func flashSavedBanner() {
        showSavedBanner = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            showSavedBanner = false
        }
    }
}
