import SwiftUI

struct NewSubscriptionView: View {
    @Binding var subscriptions: [Subscription]
    @EnvironmentObject var financialDetails: FinancialDetailsViewModel
    @State private var name = ""
    @State private var costString = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextField("Cost", text: $costString)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Add") {
                if let cost = Double(costString), !name.isEmpty {
                    let newSubscription = Subscription(name: name, cost: cost)
                    subscriptions.append(newSubscription)
                    financialDetails.addExpense(cost)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding()
        }
        .padding()
    }
}
