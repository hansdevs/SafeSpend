import SwiftUI

struct BudgetView: View {
    @EnvironmentObject var financialDetails: FinancialDetailsViewModel
    
    @State private var subscriptions = [Subscription]()
    @State private var incomes = [Income]()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background shapes
                BudgetBackgroundShapesView()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    Image("SafeSpend_HansGamlien")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                    
                    Spacer()
                    
                    // Expenses list
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Expenses")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        List {
                            ForEach(subscriptions) { subscription in
                                SubscriptionRow(subscription: subscription) {
                                    deleteSubscription(subscription)
                                }
                            }
                            .onDelete(perform: deleteSubscriptions)
                        }
                        .listStyle(PlainListStyle())
                    }
                    .padding()
                    .background(Color(hex: "#2E4F46").opacity(0.8))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    // Income list
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Sources of Income")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        List {
                            ForEach(incomes) { income in
                                IncomeRow(income: income) {
                                    deleteIncome(income)
                                }
                            }
                            .onDelete(perform: deleteIncomes)
                        }
                        .listStyle(PlainListStyle())
                    }
                    .padding()
                    .background(Color(hex: "#2E4F46").opacity(0.8))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    Spacer()
                    // Add New Expense button
                    NavigationLink(destination: NewSubscriptionView(subscriptions: $subscriptions)) {
                        Text("Add New Expense")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(BudgetAppIconGradient())
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding(.horizontal)
                    }
                    .padding(.bottom)
                    
                    // Add New Income button
                    NavigationLink(destination: NewIncomeView(incomes: $incomes)) {
                        Text("Add New Income")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(BudgetAppIconGradient())
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding(.horizontal)
                    }
                    .padding(.bottom)
                    
                    // Go to Loan Calculator button
                    NavigationLink(destination: FinanceCalculatorView().environmentObject(financialDetails)) {
                        Text("Loan Calculator")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(BudgetAppIconGradient())
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding(.horizontal)
                    }
                    .padding(.bottom)

                }
            }
            .navigationBarHidden(true)
        }
    }
    // Delete income function
    func deleteIncome(_ income: Income) {
        if let index = incomes.firstIndex(of: income) {
            // Update financial details before removing the income
            financialDetails.addIncome(-incomes[index].amount)
            incomes.remove(at: index)
        }
    }
    
    // Delete subscription function
    func deleteSubscription(_ subscription: Subscription) {
        if let index = subscriptions.firstIndex(of: subscription) {
            // Update financial details before removing the expense
            financialDetails.addExpense(-subscriptions[index].cost)
            subscriptions.remove(at: index)
        }
    }
    
    // Delete subscriptions function for List
    func deleteSubscriptions(at offsets: IndexSet) {
        for index in offsets {
            // Update financial details before removing the expense
            // tried to do this and it failed. left it in here to try to fix after Swift Student Challenge
            financialDetails.addExpense(-subscriptions[index].cost)
        }
        subscriptions.remove(atOffsets: offsets)
    }
    
    // Delete incomes function for List
    func deleteIncomes(at offsets: IndexSet) {
        for index in offsets {
            // Update financial details before removing the income
            financialDetails.addIncome(-incomes[index].amount)
        }
        incomes.remove(atOffsets: offsets)
    }
}
struct Subscription: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let cost: Double
}

struct Income: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let amount: Double
}

struct SubscriptionRow: View {
    var subscription: Subscription
    var onDelete: () -> Void
    
    var body: some View {
        HStack {
            Text(subscription.name)
            Spacer()
            Text("$\(subscription.cost, specifier: "%.2f")")
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
    }
}

struct IncomeRow: View {
    var income: Income
    var onDelete: () -> Void
    
    var body: some View {
        HStack {
            Text(income.name)
            Spacer()
            Text("$\(income.amount, specifier: "%.2f")")
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
    }
}

// Gradient for buttons, I thought they loooked nice :)
struct BudgetAppIconGradient: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(hex: "#1ABC9C"), Color(hex: "#2E4F46")]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

// Background shapes
struct BudgetBackgroundShapesView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .fill(Color(hex: "#1ABC9C").opacity(0.1)) // Lightest color for the shapes
                    .blur(radius: 20)
                    .scaleEffect(1.5)
                    .offset(x: geometry.size.width * 0.2, y: geometry.size.height * -0.3)
                
                Circle()
                    .fill(Color(hex: "#2E4F46").opacity(0.1)) // Darkest color for the shapes
                    .blur(radius: 20)
                    .scaleEffect(1.8)
                    .offset(x: geometry.size.width * -0.1, y: geometry.size.height * 0.1)
            }
        }
    }
}
