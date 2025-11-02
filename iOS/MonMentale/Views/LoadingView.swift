import SwiftUI

// MARK: - Loading View avec icône Psi
// Écran de chargement avec l'icône Psi (Ψ) et animation

struct LoadingView: View {
    @State private var isAnimating = false
    @State private var showContent = false
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        ZStack {
            // Arrière-plan avec dégradé pastel
            LinearGradient(
                gradient: Gradient(colors: [
                    MonMentaleColors.primaryBlue.opacity(0.1),
                    MonMentaleColors.secondaryPink.opacity(0.1),
                    MonMentaleColors.accentPurple.opacity(0.1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Icône Psi (Ψ) animée
                ZStack {
                    // Cercle de fond avec animation de pulsation
                    Circle()
                        .fill(MonMentaleColors.primaryBlue.opacity(0.1))
                        .frame(width: 200, height: 200)
                        .scaleEffect(isAnimating ? 1.2 : 1.0)
                        .opacity(isAnimating ? 0.3 : 0.6)
                        .animation(
                            .easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                    
                    // Cercle intérieur
                    Circle()
                        .fill(MonMentaleColors.primaryBlue.opacity(0.2))
                        .frame(width: 150, height: 150)
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                        .animation(
                            .easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                    
                    // Icône Psi (Ψ) principale
                    PsiIconView()
                        .frame(width: 80, height: 80)
                        .scaleEffect(isAnimating ? 1.05 : 1.0)
                        .animation(
                            .easeInOut(duration: 1.0)
                            .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                }
                
                // Texte de chargement
                VStack(spacing: 16) {
                    Text("Mon Mentale")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(MonMentaleColors.textPrimary)
                        .opacity(showContent ? 1 : 0)
                        .animation(.easeInOut(duration: 0.8).delay(0.5), value: showContent)
                    
                    Text("Votre compagnon de santé mentale")
                        .font(.headline)
                        .foregroundColor(MonMentaleColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .opacity(showContent ? 1 : 0)
                        .animation(.easeInOut(duration: 0.8).delay(0.8), value: showContent)
                    
                    // Indicateur de chargement
                    HStack(spacing: 8) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(MonMentaleColors.primaryBlue)
                                .frame(width: 8, height: 8)
                                .scaleEffect(isAnimating ? 1.2 : 0.8)
                                .animation(
                                    .easeInOut(duration: 0.6)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.2),
                                    value: isAnimating
                                )
                        }
                    }
                    .opacity(showContent ? 1 : 0)
                    .animation(.easeInOut(duration: 0.8).delay(1.0), value: showContent)
                }
                
                Spacer()
                
                // Version de l'app
                Text("Version 1.0.0")
                    .font(.caption)
                    .foregroundColor(MonMentaleColors.textTertiary)
                    .opacity(showContent ? 1 : 0)
                    .animation(.easeInOut(duration: 0.8).delay(1.2), value: showContent)
                    .padding(.bottom, 40)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation {
            isAnimating = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation {
                showContent = true
            }
        }
    }
}

// MARK: - Psi Icon View
// Vue personnalisée pour dessiner l'icône Psi (Ψ)

struct PsiIconView: View {
    var body: some View {
        ZStack {
            // Dessin de la lettre Psi (Ψ) avec des formes SwiftUI
            
            // Tige verticale centrale
            RoundedRectangle(cornerRadius: 2)
                .fill(MonMentaleColors.primaryBlue)
                .frame(width: 12, height: 60)
                .offset(y: 5)
            
            // Bras gauche (courbe supérieure gauche)
            Path { path in
                let centerX: CGFloat = 0
                let centerY: CGFloat = -15
                let radius: CGFloat = 25
                
                path.addArc(
                    center: CGPoint(x: centerX, y: centerY),
                    radius: radius,
                    startAngle: .degrees(180),
                    endAngle: .degrees(270),
                    clockwise: false
                )
            }
            .stroke(MonMentaleColors.primaryBlue, style: StrokeStyle(lineWidth: 12, lineCap: .round))
            
            // Bras droit (courbe supérieure droite)
            Path { path in
                let centerX: CGFloat = 0
                let centerY: CGFloat = -15
                let radius: CGFloat = 25
                
                path.addArc(
                    center: CGPoint(x: centerX, y: centerY),
                    radius: radius,
                    startAngle: .degrees(270),
                    endAngle: .degrees(360),
                    clockwise: false
                )
            }
            .stroke(MonMentaleColors.primaryBlue, style: StrokeStyle(lineWidth: 12, lineCap: .round))
        }
        .frame(width: 50, height: 50)
    }
}

// MARK: - Alternative Psi Icon (plus simple)
struct SimplePsiIconView: View {
    var body: some View {
        ZStack {
            // Version simplifiée avec des rectangles
            VStack(spacing: 0) {
                // Bras supérieurs
                HStack(spacing: 0) {
                    // Bras gauche
                    RoundedRectangle(cornerRadius: 6)
                        .fill(MonMentaleColors.primaryBlue)
                        .frame(width: 20, height: 8)
                        .rotationEffect(.degrees(-30))
                        .offset(x: -5, y: 2)
                    
                    // Bras droit
                    RoundedRectangle(cornerRadius: 6)
                        .fill(MonMentaleColors.primaryBlue)
                        .frame(width: 20, height: 8)
                        .rotationEffect(.degrees(30))
                        .offset(x: 5, y: 2)
                }
                
                // Tige verticale
                RoundedRectangle(cornerRadius: 2)
                    .fill(MonMentaleColors.primaryBlue)
                    .frame(width: 12, height: 50)
            }
        }
        .frame(width: 50, height: 50)
    }
}

// MARK: - Loading View avec différentes variantes

struct LoadingViewWithProgress: View {
    @State private var progress: Double = 0
    @State private var isAnimating = false
    @State private var showContent = false
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        ZStack {
            // Arrière-plan
            MonMentaleColors.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Icône Psi avec barre de progression
                VStack(spacing: 30) {
                    ZStack {
                        // Cercle de progression
                        Circle()
                            .stroke(MonMentaleColors.neutralGrayLight, lineWidth: 8)
                            .frame(width: 120, height: 120)
                        
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        MonMentaleColors.primaryBlue,
                                        MonMentaleColors.secondaryPink
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 8, lineCap: .round)
                            )
                            .frame(width: 120, height: 120)
                            .rotationEffect(.degrees(-90))
                            .animation(.easeInOut(duration: 0.5), value: progress)
                        
                        // Icône Psi au centre
                        PsiIconView()
                            .frame(width: 50, height: 50)
                    }
                    
                    // Texte de progression
                    VStack(spacing: 8) {
                        Text("Chargement...")
                            .font(.headline)
                            .foregroundColor(MonMentaleColors.textPrimary)
                        
                        Text("\(Int(progress * 100))%")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(MonMentaleColors.primaryBlue)
                    }
                    .opacity(showContent ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5), value: showContent)
                }
                
                Spacer()
            }
        }
        .onAppear {
            startLoading()
        }
    }
    
    private func startLoading() {
        showContent = true
        
        // Animation de la barre de progression
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            withAnimation(.easeInOut(duration: 0.1)) {
                progress += 0.02
                
                if progress >= 1.0 {
                    timer.invalidate()
                }
            }
        }
    }
}

// MARK: - Preview
struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoadingView()
                .environmentObject(LocalizationManager.shared)
            
            LoadingViewWithProgress()
                .environmentObject(LocalizationManager.shared)
        }
    }
}

