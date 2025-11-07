# WellnessTracker

SwiftUI + Firebase Firestore. Registro diario de ánimo, sueño, energía, notas; historial, estadísticas y ajustes.

## Requisitos
- Xcode 14+
- iOS 16.4+
- CocoaPods: no usado (Swift Package Manager)
- Firebase (GoogleService-Info.plist en el target iOS)

## Configuración rápida
1. Abrir `WellnessTracker.xcodeproj` en Xcode.
2. Seleccionar el esquema *WellnessTracker* (iPhone 14+ sim recomendado).
3. Asegurar que el `Bundle Identifier` coincide con el del `GoogleService-Info.plist`.
4. Build & Run (⌘R).

## Estructura
- `Models/` (Entry, AppModel)
- `Views/` (Dashboard, History, NewEntry, Stats, Settings, About, Root)
- `FirestoreService/` (CRUD con snapshots)

## Colaboradores (ramas)
- @Camxlo — rama `camxlo/feature-...`
- @AlejandroPC0428 — rama `alejandropc0428/feature-...`
