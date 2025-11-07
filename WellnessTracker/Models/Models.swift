import Foundation
import FirebaseFirestore


enum Mood: String, CaseIterable, Codable, Identifiable, Hashable {
    case happy = "😊 Happy", ok = "🙂 Okay", tired = "😴 Tired", stressed = "😖 Stressed"
    var id: String { rawValue }
}

struct Entry: Identifiable, Codable, Equatable, Hashable {
    var id: String = UUID().uuidString
    var date: Date = Date()
    var title: String
    var mood: Mood
    var energy: Int
    var sleptHours: Double
    var wakeups: Int
    var notes: String
}


final class AppModel: ObservableObject {
    @Published var entries: [Entry] = []
    private let store = FirestoreService()
    private var listener: ListenerRegistration?
    
    
    init() {
        // Suscripción en tiempo real a Firestore
        listener = store.listenEntries { [weak self] items in
            DispatchQueue.main.async { self?.entries = items }
        }
    }
    
    
    func add(_ e: Entry) { store.add(e) }
    
    
    func delete(at offsets: IndexSet) {
        for i in offsets { store.delete(id: entries[i].id) }
    }
    func update(_ e: Entry) { store.update(e) } 

}


enum SampleData { // opcional: útil si Firestore está vacío
    static let samples: [Entry] = [
        Entry(title: "Gym + estudio", mood: .happy, energy: 8, sleptHours: 7.5, wakeups: 1, notes: "Día productivo"),
        Entry(title: "Parcial pesado", mood: .stressed, energy: 4, sleptHours: 5.0, wakeups: 3, notes: "Mucho café"),
        Entry(title: "Domingo chill", mood: .ok, energy: 6, sleptHours: 8.0, wakeups: 0, notes: "Familia y descanso"),
    ]
}
