// FirestoreService.swift
import Foundation
import FirebaseFirestore

final class FirestoreService {
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    @discardableResult
    func listenEntries(onChange: @escaping ([Entry]) -> Void) -> ListenerRegistration {
        return db.collection("entries")
            .order(by: "date", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("❗️Firestore listen error:", error)
                    onChange([])
                    return
                }
                let items: [Entry] = snapshot?.documents.compactMap { doc in
                    let d = doc.data()

                    // date (Timestamp -> Date)
                    let date = (d["date"] as? Timestamp)?.dateValue() ?? Date()

                    // básicos
                    let title = d["title"] as? String ?? "Entrada"
                    let notes = d["notes"] as? String ?? ""

                    // enum Mood desde rawValue
                    let moodRaw = d["mood"] as? String ?? Mood.ok.rawValue
                    let mood = Mood(rawValue: moodRaw) ?? .ok

                    // numéricos tolerantes (pueden venir como Int o Double)
                    let energy = (d["energy"] as? Int) ?? Int((d["energy"] as? Double) ?? 0)
                    let sleptHours = (d["sleptHours"] as? Double) ?? Double((d["sleptHours"] as? Int) ?? 0)
                    let wakeups = (d["wakeups"] as? Int) ?? Int((d["wakeups"] as? Double) ?? 0)

                    return Entry(
                        id: doc.documentID,
                        date: date,
                        title: title,
                        mood: mood,
                        energy: energy,
                        sleptHours: sleptHours,
                        wakeups: wakeups,
                        notes: notes
                    )
                } ?? []
                onChange(items)
            }
    }

    func add(_ e: Entry) {
        let data: [String: Any] = [
            "id": e.id,
            "date": Timestamp(date: e.date),
            "title": e.title,
            "mood": e.mood.rawValue,
            "energy": e.energy,
            "sleptHours": e.sleptHours,
            "wakeups": e.wakeups,
            "notes": e.notes
        ]
        db.collection("entries").document(e.id).setData(data) { error in
            if let error = error { print("❗️Error guardando:", error) }
        }
    }

    func delete(id: String) {
        db.collection("entries").document(id).delete { err in
            if let err = err { print("❗️Error eliminando:", err) }
        }
    }
    func update(_ e: Entry) {
           do {
               try db.collection("entries").document(e.id).setData(from: e, merge: true)
           } catch {
               print("⚠️ Error actualizando:", error)
           }
       }

       // Consulta por rango de fechas (para filtros):
       func fetch(from: Date?, to: Date?, completion: @escaping ([Entry]) -> Void) {
           var q: Query = db.collection("entries").order(by: "date", descending: true)
           if let from = from { q = q.whereField("date", isGreaterThanOrEqualTo: Timestamp(date: from)) }
           if let to = to { q = q.whereField("date", isLessThanOrEqualTo: Timestamp(date: to)) }
           q.getDocuments { snap, err in
               if let err = err { print("⚠️ Fetch error:", err); completion([]); return }
               let items: [Entry] = snap?.documents.compactMap { try? $0.data(as: Entry.self) } ?? []
               completion(items)
           }
       }
}

