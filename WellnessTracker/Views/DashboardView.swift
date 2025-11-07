import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var model: AppModel
    @State private var showNew = false

    var body: some View {
        NavigationStack {
            List {
                if model.entries.isEmpty {
                    Section { EmptyStateView(title: "No entries", message: "Tap + to add your first entry.") }
                } else {
                    ForEach(model.entries) { entry in
                        NavigationLink {
                            EntryDetailView(entry: entry)
                        } label: {
                            HStack {
                                Text(String(entry.mood.rawValue.prefix(2))) // emoji
                                VStack(alignment: .leading) {
                                    Text(entry.title).font(.headline)
                                    Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                                        .font(.caption).foregroundColor(.secondary)
                                }
                                Spacer()
                                Text("\(entry.energy)/10").font(.subheadline)
                            }
                        }
                    }
                    .onDelete(perform: model.delete)
                }
            }
            .navigationTitle("Home")
            
            .sheet(isPresented: $showNew) {
                NewEntryView().environmentObject(model)
            }
        }
    }
}

