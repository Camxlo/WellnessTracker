import SwiftUI

struct EntryDetailView: View {
    @EnvironmentObject var model: AppModel
    let entry: Entry
    @State private var showEdit = false

    var body: some View {
        List {
            Section {
                HStack(spacing: 12) {
                    Text(entry.mood.rawValue.split(separator: " ").first ?? "🙂")
                        .font(.largeTitle)
                    VStack(alignment: .leading) {
                        Text(entry.title).font(.title3).bold()
                        Text(entry.date.formatted(date: .long, time: .omitted))
                            .font(.caption).foregroundStyle(.secondary)
                    }
                }
            }

            Section("Detalles") {
                LabeledContent("Ánimo", value: entry.mood.rawValue)
                LabeledContent("Energía", value: "\(entry.energy)")
                LabeledContent("Horas de sueño", value: String(format: "%.1f h", entry.sleptHours)) // ← sleptHours
                LabeledContent("Despertares", value: "\(entry.wakeups)")
            }

            if !entry.notes.isEmpty {
                Section("Notas") { Text(entry.notes) }
            }
        }
        .navigationTitle("Detalle")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Editar") { showEdit = true }
            }
        }
        .sheet(isPresented: $showEdit) {
            NavigationStack {
                NewEntryView(original: entry)
                    .environmentObject(model)
            }
        }
    }
}

