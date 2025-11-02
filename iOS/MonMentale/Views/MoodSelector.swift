import SwiftUI

// MARK: - Mood Selector View
// Sélecteur d'humeur avec barre latérale ovale et couleurs dynamiques

struct MoodSelector: View {
    @Binding var selectedMood: MoodLevel
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging = false
    
    private let moods: [MoodLevel] = MoodLevel.allCases
    private let barHeight: CGFloat = 300
    private let barWidth: CGFloat = 60
    private let thumbSize: CGFloat = 40
    
    var body: some View {
        VStack(spacing: 20) {
            // Titre et description
            headerSection
            
            // Barre de sélection d'humeur
            moodBarSection
            
            // Indicateur de l'humeur sélectionnée
            moodIndicatorSection
            
            // Actions rapides
            quickActionsSection
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 30)
        .background(MonMentaleColors.backgroundCard)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .shadow(color: MonMentaleColors.textPrimary.opacity(0.1), radius: 15, x: 0, y: 8)
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 12) {
            Text("Comment vous sentez-vous ?")
                .title2Style()
                .multilineTextAlignment(.center)
            
            Text("Glissez le curseur pour indiquer votre humeur actuelle")
                .subheadlineStyle()
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Mood Bar Section
    private var moodBarSection: some View {
        HStack(spacing: 30) {
            // Barre de sélection ovale
            ZStack(alignment: .top) {
                // Fond de la barre
                RoundedRectangle(cornerRadius: barWidth / 2)
                    .fill(MonMentaleColors.neutralGray)
                    .frame(width: barWidth, height: barHeight)
                    .overlay(
                        // Gradient de couleurs selon l'humeur
                        RoundedRectangle(cornerRadius: barWidth / 2)
                            .fill(moodGradient)
                    )
                
                // Curseur ovale
                Circle()
                    .fill(selectedMood.color)
                    .frame(width: thumbSize, height: thumbSize)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 4)
                    )
                    .overlay(
                        // Icône de l'humeur
                        Image(systemName: selectedMood.icon)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                    )
                    .offset(y: thumbPosition)
                    .scaleEffect(isDragging ? 1.2 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isDragging)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                isDragging = true
                                let newOffset = min(max(value.translation.y, -barHeight/2 + thumbSize/2), barHeight/2 - thumbSize/2)
                                dragOffset = newOffset
                                updateMoodFromOffset()
                            }
                            .onEnded { _ in
                                isDragging = false
                                snapToNearestMood()
                            }
                    )
                    .shadow(color: selectedMood.color.opacity(0.4), radius: 8, x: 0, y: 4)
            }
            
            // Labels des humeurs
            moodLabelsSection
        }
    }
    
    // MARK: - Mood Labels Section
    private var moodLabelsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(moods.enumerated()), id: \.offset) { index, mood in
                HStack {
                    Text(mood.displayName)
                        .calloutStyle()
                        .foregroundColor(selectedMood == mood ? mood.color : MonMentaleColors.textSecondary)
                        .fontWeight(selectedMood == mood ? .semibold : .regular)
                    
                    Spacer()
                }
                .frame(height: barHeight / CGFloat(moods.count))
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        selectedMood = mood
                        dragOffset = 0
                    }
                }
            }
        }
        .frame(height: barHeight)
    }
    
    // MARK: - Mood Indicator Section
    private var moodIndicatorSection: some View {
        VStack(spacing: 16) {
            // Cercle d'humeur avec animation
            ZStack {
                Circle()
                    .fill(selectedMood.color.opacity(0.2))
                    .frame(width: 120, height: 120)
                    .scaleEffect(isDragging ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: isDragging)
                
                Circle()
                    .fill(selectedMood.color)
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: selectedMood.icon)
                            .font(.system(size: 32, weight: .medium))
                            .foregroundColor(.white)
                    )
            }
            
            // Description de l'humeur
            VStack(spacing: 8) {
                Text(selectedMood.displayName)
                    .title3Style()
                    .foregroundColor(selectedMood.color)
                
                Text(selectedMood.description)
                    .bodyStyle()
                    .multilineTextAlignment(.center)
                    .foregroundColor(MonMentaleColors.textSecondary)
            }
        }
    }
    
    // MARK: - Quick Actions Section
    private var quickActionsSection: some View {
        HStack(spacing: 16) {
            // Bouton de journal
            Button(action: {
                // Action pour ouvrir le journal
            }) {
                VStack(spacing: 8) {
                    Image(systemName: "book.fill")
                        .font(.title2)
                        .foregroundColor(MonMentaleColors.therapy)
                    
                    Text("Journal")
                        .captionStyle()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(MonMentaleColors.therapy.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            // Bouton de méditation
            Button(action: {
                // Action pour méditation
            }) {
                VStack(spacing: 8) {
                    Image(systemName: "leaf.fill")
                        .font(.title2)
                        .foregroundColor(MonMentaleColors.calm)
                    
                    Text("Méditer")
                        .captionStyle()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(MonMentaleColors.calm.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            // Bouton de respiration
            Button(action: {
                // Action pour exercices de respiration
            }) {
                VStack(spacing: 8) {
                    Image(systemName: "wind")
                        .font(.title2)
                        .foregroundColor(MonMentaleColors.wellness)
                    
                    Text("Respirer")
                        .captionStyle()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(MonMentaleColors.wellness.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var thumbPosition: CGFloat {
        let moodIndex = CGFloat(moods.firstIndex(of: selectedMood) ?? 0)
        let totalMoods = CGFloat(moods.count - 1)
        let position = (moodIndex / totalMoods) * (barHeight - thumbSize) - barHeight/2 + thumbSize/2
        return position + dragOffset
    }
    
    private var moodGradient: LinearGradient {
        LinearGradient(
            colors: moods.map { $0.color },
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    // MARK: - Helper Methods
    
    private func updateMoodFromOffset() {
        let normalizedOffset = (dragOffset + barHeight/2 - thumbSize/2) / (barHeight - thumbSize)
        let moodIndex = Int(round(normalizedOffset * CGFloat(moods.count - 1)))
        let clampedIndex = max(0, min(moodIndex, moods.count - 1))
        
        if selectedMood != moods[clampedIndex] {
            selectedMood = moods[clampedIndex]
        }
    }
    
    private func snapToNearestMood() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            dragOffset = 0
        }
    }
}

// MARK: - Mood Level Enum
enum MoodLevel: String, CaseIterable, Codable {
    case terrible = "terrible"
    case bad = "bad"
    case okay = "okay"
    case good = "good"
    case great = "great"
    case excellent = "excellent"
    
    var displayName: String {
        switch self {
        case .terrible:
            return "Terrible"
        case .bad:
            return "Mauvais"
        case .okay:
            return "Correct"
        case .good:
            return "Bien"
        case .great:
            return "Très bien"
        case .excellent:
            return "Excellent"
        }
    }
    
    var description: String {
        switch self {
        case .terrible:
            return "Je me sens vraiment mal aujourd'hui"
        case .bad:
            return "Ce n'est pas un bon jour"
        case .okay:
            return "Je vais bien, sans plus"
        case .good:
            return "Je me sens plutôt bien"
        case .great:
            return "Je me sens vraiment bien"
        case .excellent:
            return "Je me sens au top de ma forme"
        }
    }
    
    var icon: String {
        switch self {
        case .terrible:
            return "face.dashed.fill"
        case .bad:
            return "face.dashed"
        case .okay:
            return "minus.circle.fill"
        case .good:
            return "face.smiling"
        case .great:
            return "face.smiling.fill"
        case .excellent:
            return "star.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .terrible:
            return MonMentaleColors.error
        case .bad:
            return MonMentaleColors.warning
        case .okay:
            return MonMentaleColors.neutralGrayDark
        case .good:
            return MonMentaleColors.complementaryGreen
        case .great:
            return MonMentaleColors.primaryBlue
        case .excellent:
            return MonMentaleColors.accentPurple
        }
    }
    
    var emoji: String {
        switch self {
        case .terrible:
            return "😢"
        case .bad:
            return "😔"
        case .okay:
            return "😐"
        case .good:
            return "🙂"
        case .great:
            return "😊"
        case .excellent:
            return "🤩"
        }
    }
}

// MARK: - Mood Selector Modal
struct MoodSelectorModal: View {
    @Binding var isPresented: Bool
    @State private var selectedMood: MoodLevel = .okay
    @State private var showingConfirmation = false
    
    var body: some View {
        ZStack {
            // Fond avec blur
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }
            
            // Contenu du modal
            VStack(spacing: 0) {
                // Handle pour glisser
                RoundedRectangle(cornerRadius: 2)
                    .fill(MonMentaleColors.neutralGray)
                    .frame(width: 40, height: 4)
                    .padding(.top, 8)
                
                MoodSelector(selectedMood: $selectedMood)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                
                // Boutons d'action
                HStack(spacing: 16) {
                    Button("Passer") {
                        isPresented = false
                    }
                    .calloutStyle()
                    .foregroundColor(MonMentaleColors.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(MonMentaleColors.neutralGray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    Button("Enregistrer") {
                        saveMood()
                    }
                    .calloutStyle()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(MonMentaleColors.primaryGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .background(MonMentaleColors.backgroundPrimary)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .padding(.horizontal, 20)
            .offset(y: showingConfirmation ? 0 : 0)
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isPresented)
    }
    
    private func saveMood() {
        // Logique pour sauvegarder l'humeur
        withAnimation {
            showingConfirmation = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isPresented = false
        }
    }
}

// MARK: - Preview
struct MoodSelector_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MoodSelector(selectedMood: .constant(.good))
        }
        .padding()
        .background(MonMentaleColors.backgroundGradient)
    }
}

