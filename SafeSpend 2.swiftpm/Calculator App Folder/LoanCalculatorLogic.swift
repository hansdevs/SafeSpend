import Foundation
//math - HG
struct LoanCalculatorLogic {
    
    enum CompoundingPeriod: String {
        case daily = "Daily"
        case monthly = "Monthly"
    }
    
    static func calculateMonthlyMortgagePayment(principal: Double, annualInterestRate: Double, loanTermYears: Double, compoundingPeriod: CompoundingPeriod) -> Double {
        let loanTermMonths = loanTermYears * 12
        return calculateMonthlyPayment(principal: principal, annualInterestRate: annualInterestRate, loanTermMonths: loanTermMonths, compoundingPeriod: compoundingPeriod)
    }
    
    static func calculateMonthlyCarPayment(principal: Double, annualInterestRate: Double, loanTermMonths: Double, compoundingPeriod: CompoundingPeriod) -> Double {
        return calculateMonthlyPayment(principal: principal, annualInterestRate: annualInterestRate, loanTermMonths: loanTermMonths, compoundingPeriod: compoundingPeriod)
    }
    
    private static func calculateMonthlyPayment(principal: Double, annualInterestRate: Double, loanTermMonths: Double, compoundingPeriod: CompoundingPeriod) -> Double {
        let monthlyInterestRate = calculateEffectiveInterestRate(annualInterestRate: annualInterestRate, compoundingPeriod: compoundingPeriod)
        let numberOfPayments = loanTermMonths
        
        if monthlyInterestRate == 0 {
            return principal / numberOfPayments
        }
        
        let discountFactor = (pow(1 + monthlyInterestRate, numberOfPayments) - 1) / (monthlyInterestRate * pow(1 + monthlyInterestRate, numberOfPayments))
        return principal / discountFactor
    }
    
    private static func calculateEffectiveInterestRate(annualInterestRate: Double, compoundingPeriod: CompoundingPeriod) -> Double {
        let nominalRate = annualInterestRate / 100
        switch compoundingPeriod {
        case .daily:
            // Calculate the effective annual rate with daily compounding
            let effectiveAnnualRate = pow(1 + nominalRate / 365, 365) - 1
            // Convert the effective annual rate to an effective monthly rate
            return pow(1 + effectiveAnnualRate, 1/12) - 1
        case .monthly:
            // Calculate the effective annual rate with monthly compounding
            let effectiveAnnualRate = pow(1 + nominalRate / 12, 12) - 1
            // Convert the effective annual rate to an effective monthly rate
            return pow(1 + effectiveAnnualRate, 1/12) - 1
        }
    }
}
