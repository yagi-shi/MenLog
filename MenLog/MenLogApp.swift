import SwiftUI
import SwiftData

@main
struct MenLogApp: App {
    var body: some Scene {
        WindowGroup {
            SplashView()
        }
        .modelContainer(for: RamenEntry.self)
    }
}
