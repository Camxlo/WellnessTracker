import SwiftUI
import Charts

struct StatsView: View {
    @EnvironmentObject var model: AppModel

    // Conteo de entradas por estado de ánimo
    private var moodCounts: [(mood: Mood, count: Int)] {
        Dictionary(grouping: model.entries, by: { $0.mood })
            .map { ($0.key, $0.value.count) }
            .sorted { $0.count > $1.count }
    }

    // Entradas ordenadas por fecha (para series de tiempo)
    private var entriesByDate: [Entry] {
        model.entries.sorted { $0.date < $1.date }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // 1) Distribución de ánimo (barras horizontales)
                GroupBox("Distribución de ánimo") {
                    Chart(moodCounts, id: \.mood) { item in
                        BarMark(
                            x: .value("Cantidad", item.count),
                            y: .value("Ánimo", item.mood.rawValue)
                        )
                        .annotation(position: .trailing) {
                            Text("\(item.count)")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .chartXAxisLabel("Cantidad")
                    .frame(height: 220)
                }

                // 2) Energía a lo largo del tiempo (línea)
                GroupBox("Energía (últimas entradas)") {
                    Chart(entriesByDate, id: \.id) { e in
                        LineMark(
                            x: .value("Fecha", e.date),
                            y: .value("Energía", e.energy)
                        )
                        PointMark(
                            x: .value("Fecha", e.date),
                            y: .value("Energía", e.energy)
                        )
                    }
                    .chartYScale(domain: 1...10)
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                    .frame(height: 220)
                }

                // 3) Horas de sueño por día (barras)
                GroupBox("Horas de sueño por día") {
                    Chart(entriesByDate, id: \.id) { e in
                        // Usamos startOfDay para agrupar visualmente por día
                        BarMark(
                            x: .value("Día", Calendar.current.startOfDay(for: e.date)),
                            y: .value("Horas", e.sleptHours)
                        )
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                    .frame(height: 220)
                }
            }
            .padding()
        }
        .navigationTitle("Estadísticas")
    }
}
