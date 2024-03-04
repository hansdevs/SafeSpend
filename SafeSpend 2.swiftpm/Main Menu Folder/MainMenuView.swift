import SwiftUI

struct MainMenuView: View {
    @State private var isAnimating = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Static background shapes
                BackgroundShapesView()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    // Logo with loop animation
                    Image("SafeSpend_HansGamlien")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .shadow(radius: 10)
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                        .onAppear {
                            withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: true)) {
                                isAnimating = true
                            }
                        }
                    
                    Text("Welcome to Safe Spend!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#92CD95"))
                        .padding(.bottom, 8)
                    
                    Text("Your personal finance assistant")
                        .font(.title2)
                        .foregroundColor(Color(hex: "#2E4F46")) 
                        .padding(.bottom, 30)
                    
                    // Start Button
                    StartCalculatingButton()
                    
                    Spacer()
                }
            }
        }
    }
}

struct StartCalculatingButton: View {
    @EnvironmentObject var financialDetails: FinancialDetailsViewModel
    
    var body: some View {
        NavigationLink(destination: BudgetView().environmentObject(financialDetails)) {
            Text("Start Calculating")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 280, height: 50)
                .background(AppIconGradient())
                .cornerRadius(10)
                .shadow(radius: 5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
struct AppIconGradient: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(hex: "#1ABC9C"), Color(hex: "#2E4F46")]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}
struct BackgroundShapesView: View {
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
                    .offset(x: geometry.size.width * -0.1, y: geometry.size.height * 0.1)}
        }
    }
}
//Color Extension
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
