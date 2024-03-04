import SwiftUI
//this had more potential with more time
class FinancialDetailsViewModel: ObservableObject {
    @Published var monthlyIncome: Double = 0
    @Published var monthlyExpenses: Double = 0
    
    func addIncome(_ income: Double) {
        monthlyIncome += income
    }
    
    func addExpense(_ expense: Double) {
        monthlyExpenses += expense
    }
}
