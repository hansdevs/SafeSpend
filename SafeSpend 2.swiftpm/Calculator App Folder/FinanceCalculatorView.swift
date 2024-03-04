import SwiftUI

struct FinanceCalculatorView: View {
    
    @State private var monthlyIncome: Double = 3000
    @State private var monthlyExpenses: Double = 1500
    @State private var mortgageInterestRate: Double = 3.5
    @State private var carLoanInterestRate: Double = 4.5
    @State private var mortgageLoanTermYears: Double = 15
    @State private var carLoanTermMonths: Double = 60
    @State private var mortgageLoanAmount: String = ""
    @State private var carLoanAmount: String = ""
    @State private var mortgagePaymentResult: String = ""
    @State private var carPaymentResult: String = ""
    @State private var mortgageCompoundingPeriod: String = "Monthly"
    @State private var carCompoundingPeriod: String = "Monthly"
    @State private var totalMortgageCost: Double = 0
    @State private var totalCarLoanCost: Double = 0
    @FocusState private var isInputFieldFocused: Bool
    
    private let compoundingOptions = ["Daily", "Monthly"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Financial Details")
                    .font(.headline)
                    .padding(.vertical)
                
                LabeledInputView(label: "Monthly Income $", value: $monthlyIncome, range: (0, 100000), step: 100)
                LabeledInputView(label: "Monthly Expenses $", value: $monthlyExpenses, range: (0, 50000), step: 50)
                
                Text("Loan Details")
                    .font(.headline)
                    .padding(.vertical)
                
                VStack(alignment: .leading) {
                    Text("Mortgage Loan Term (Years): \(Int(mortgageLoanTermYears))")
                    Slider(value: $mortgageLoanTermYears, in: 1...30, step: 1)
                        .accentColor(Color(hex: "#1ABC9C"))
                }
                .padding()
                
                VStack(alignment: .leading) {
                    Text("Car Loan Term (Months): \(Int(carLoanTermMonths))")
                    Slider(value: $carLoanTermMonths, in: 12...84, step: 1)
                        .accentColor(Color(hex: "#1ABC9C"))
                }
                .padding()
                
                LabeledInterestRateInputView(label: "Mortgage Interest Rate (%)", value: $mortgageInterestRate, range: (0, 10), step: 0.1)
                Picker("Compounding Period", selection: $mortgageCompoundingPeriod) {
                    ForEach(compoundingOptions, id: \.self) { option in
                        Text(option)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                LabeledInterestRateInputView(label: "Car Loan Interest Rate (%)", value: $carLoanInterestRate, range: (0, 10), step: 0.1)
                Picker("Compounding Period", selection: $carCompoundingPeriod) {
                    ForEach(compoundingOptions, id: \.self) { option in
                        Text(option)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                TextField("Mortgage Loan Amount", text: $mortgageLoanAmount)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .focused($isInputFieldFocused)
                
                TextField("Car Loan Amount", text: $carLoanAmount)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .focused($isInputFieldFocused)
                
                Button("Calculate", action: calculateLoans)
                    .buttonStyle(FilledRoundedButtonStyle())
                    .padding(.top, 20)
                
                if !mortgagePaymentResult.isEmpty {
                    Text(mortgagePaymentResult)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))           .cornerRadius(10)
                        .shadow(radius: 10)
                        .padding(.top, 20)
                    
                    Text("Total Mortgage Cost: \(totalMortgageCost, specifier: "%.2f")")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.bottom, 20)
                }
                
                if !carPaymentResult.isEmpty {
                    Text(carPaymentResult)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))            .cornerRadius(10)
                        .shadow(radius: 10)
                        .padding(.top, 20)
                    
                    Text("Total Car Loan Cost: \(totalCarLoanCost, specifier: "%.2f")")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.bottom, 20)
                }
            }
            .padding()
        }
        .background(BackgroundShapesView())
        .navigationBarTitle("Loan Calculator", displayMode: .inline)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isInputFieldFocused = false
                }
            }
        }
        .background(BackgroundShapesView())
        .navigationBarTitle("Loan Calculator", displayMode: .inline)
    }
    
    func calculateLoans() {
        // Convert mortgage and car loan amounts to Double, default to 0 if empty or not a valid number
        let mortgageAmount = Double(mortgageLoanAmount) ?? 0
        let carAmount = Double(carLoanAmount) ?? 0
        
        let mortgageCompounding = LoanCalculatorLogic.CompoundingPeriod(rawValue: mortgageCompoundingPeriod) ?? .monthly
        let carCompounding = LoanCalculatorLogic.CompoundingPeriod(rawValue: carCompoundingPeriod) ?? .monthly
        
        // Calculate mortgage payment
        let mortgagePayment = LoanCalculatorLogic.calculateMonthlyMortgagePayment(
            principal: mortgageAmount, 
            annualInterestRate: mortgageInterestRate, 
            loanTermYears: mortgageLoanTermYears, 
            compoundingPeriod: mortgageCompounding
        )
        totalMortgageCost = mortgagePayment * Double(mortgageLoanTermYears) * 12
        
        // Calculate car loan payment
        let carPayment = LoanCalculatorLogic.calculateMonthlyCarPayment(
            principal: carAmount, 
            annualInterestRate: carLoanInterestRate, 
            loanTermMonths: carLoanTermMonths, 
            compoundingPeriod: carCompounding
        )
        totalCarLoanCost = carPayment * carLoanTermMonths
        
        // Update result strings
        mortgagePaymentResult = mortgageAmount > 0 ? String(format: "Monthly Mortgage Payment: $%.2f", mortgagePayment) : "No mortgage loan amount entered"
        carPaymentResult = carAmount > 0 ? String(format: "Monthly Car Payment: $%.2f", carPayment) : "No car loan amount entered"
    }
    
    struct LabeledSliderView: View {
        var label: String
        @Binding var value: Double
        var range: (Double, Double)
        var step: Double
        
        var body: some View {
            VStack(alignment: .leading) {
                if label.contains("Rate") {
                    Text("\(label): \(value, specifier: "%.2f")%")
                } else {
                    Text("\(label): \(Int(value))")
                }
                Slider(value: $value, in: range.0...range.1, step: step)
                    .accentColor(Color(hex: "#1ABC9C"))
            }
            .padding(.vertical)
        }
    }
    
    struct LabeledInputView: View {
        var label: String
        @Binding var value: Double
        var range: (Double, Double)
        var step: Double
        
        var body: some View {
            HStack {
                Text(label)
                Spacer()
                Stepper(value: $value, in: range.0...range.1, step: step) {
                    Text("\(value, specifier: "%.0f")")
                }
            }
        }
    }
    
    struct FilledRoundedButtonStyle: ButtonStyle {
        func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "#1ABC9C"), Color(hex: "#2E4F46")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 10)
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        }
    }
    
    struct ResultView: View {
        @Binding var result: String
        @Environment(\.colorScheme) var colorScheme 
        var body: some View {
            Text(result)
                .padding()
                .frame(maxWidth: .infinity)
                .background(colorScheme == .dark ? Color.black : Color.white)
                .foregroundColor(colorScheme == .dark ? .white : .black) 
                .cornerRadius(10)
                .shadow(radius: colorScheme == .dark ? 0 : 10)
        }
    }
}
struct LabeledInterestRateInputView: View {
    var label: String
    @Binding var value: Double
    var range: (Double, Double)
    var step: Double
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            TextField("", value: $value, formatter: NumberFormatter.percentFormatter, prompt: Text("Enter Rate"))
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 100)
            Stepper("", value: $value, in: range.0...range.1, step: step)
        }
        .padding()
    }
}

// NumberFormatter Extension
extension NumberFormatter {
    static let percentFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}
