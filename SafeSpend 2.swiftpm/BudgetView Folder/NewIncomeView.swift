import SwiftUI

struct NewIncomeView: View {
    @Binding var incomes: [Income]
    @EnvironmentObject var financialDetails: FinancialDetailsViewModel
    @State private var name = ""
    @State private var amountString = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextField("Amount", text: $amountString)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Add") {
                if let amount = Double(amountString), !name.isEmpty {
                    let newIncome = Income(name: name, amount: amount)
                    incomes.append(newIncome)
                    financialDetails.addIncome(amount)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding()
        }
        .padding()
    }
}
