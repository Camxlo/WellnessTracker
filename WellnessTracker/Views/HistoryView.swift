import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var model: AppModel
    @State private var query = ""
    @State private var moodFilter: Mood? = nil
    @State private var fromDate: Date? = nil
    @State private var toDate: Date? = nil
    @State private var sortDesc = true

    private var filtered: [Entry] {
        model.entries
            .filter { e in
                query.isEmpty ||
                e.title.localizedCaseInsensitiveContains(query) ||
                e.notes.localizedCaseInsensitiveContains(query)
            }
            .filter { e in moodFilter == nil || e.mood == moodFilter }
            .filter { e in (fromDate == nil || e.date >= fromDate!) && (toDate == nil || e.date <= toDate!) }
            .sorted(by: { sortDesc ? $0.date > $1.date : $0.date < $1.date })
    }

    var body: some View {
        VStack {
            // Filtros compactos
            HStack(spacing: 8) {
                Menu(moodFilter == nil ? "Ánimo: Todos" : "Ánimo: \(moodFilter!.rawValue)") {
                    Button("Todos") { moodFilter = nil }
                    ForEach(Mood.allCases) { m in
                        Button(m.rawValue) { moodFilter = m }
                    }
                }

                // DatePicker iOS 16 con Date? usando Binding manual
                DatePicker(
                    "Desde",
                    selection: Binding<Date>(
                        get: { fromDate ?? Date() },
                        set: { fromDate = $0 }
                    ),
                    displayedComponents: .date
                )
                .labelsHidden()

                DatePicker(
                    "Hasta",
                    selection: Binding<Date>(
                        get: { toDate ?? Date() },
                        set: { toDate = $0 }
                    ),
                    displayedComponents: .date
                )
                .labelsHidden()

                Button(sortDesc ? "↓" : "↑") { sortDesc.toggle() }

                // Limpiar fechas (opcional)
                if fromDate != nil || toDate != nil {
                    Button("✕") { fromDate = nil; toDate = nil }
                        .accessibilityLabel("Limpiar rango de fechas")
                }
            }
            .padding(.horizontal)

            List {
                ForEach(filtered) { e in
                    NavigationLink(value: e) {
                        HStack {
                            Text(e.mood.rawValue.split(separator: " ").first.map(String.init) ?? "🙂")
                                .font(.title2)
                            VStack(alignment: .leading) {
                                Text(e.title).bold()
                                Text("Sueño: \(e.sleptHours, specifier: "%.1f") h • Energía: \(e.energy)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(e.date.formatted(date: .abbreviated, time: .omitted))
                                .font(.footnote)
                        }
                    }
                }
                .onDelete(perform: model.delete)
            }
            .searchable(text: $query, prompt: "Buscar título o notas")
            .navigationDestination(for: Entry.self) { e in EntryDetailView(entry: e) }
            .navigationTitle("Historial")
            .toolbar { EditButton() }
        }
    }
}
