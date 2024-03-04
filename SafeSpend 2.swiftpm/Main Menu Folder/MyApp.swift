import SwiftUI

@main
struct MyApp: App {
    var financialDetailsViewModel = FinancialDetailsViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(financialDetailsViewModel)
        }
    }
}
// Hello Apple :) 
// Made my Hans Gamlien
