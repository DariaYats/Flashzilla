 //
//  ContentView.swift
//  Flashzilla
//
//  Created by Дарья Яцынюк on 02.07.2024.
//
import SwiftData
import SwiftUI

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(y: offset * 10)
    }
}

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled
    
    @Environment(\.modelContext) var modelContext
    @Query var cards: [Card]
    @State private var showingEditScreen = false
    
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true

    var body: some View {
        ZStack {
            Image(decorative: "background")
                .resizable()
                .ignoresSafeArea()
            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(.capsule)
                
                ZStack {
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView(card: cards[index]) {
                            withAnimation {
                                deleteCard(at: index)
                            }
                        }
                            .stacked(at: index, in: cards.count)
                            .allowsHitTesting(index == cards.count - 1)
                            .accessibilityHidden(index < cards.count - 1)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)
                
                if cards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundStyle(.black)
                        .clipShape(.capsule)
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(.circle)
                    }
                }
                
                Spacer()
            }
            .foregroundStyle(.white)
            .font(.largeTitle)
            .padding()
            
            if accessibilityDifferentiateWithoutColor || accessibilityVoiceOverEnabled {
                VStack {
                    Spacer()
                    
                    HStack {
                        Button {
                            withAnimation {
                                deleteCard(at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Wraong")
                        .accessibilityHint("Mark your answer as beeing incorrect.")
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                deleteCard(at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as being correct.")
                    }
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer) { time in
            guard isActive else { return }
            
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                if cards.isEmpty == false {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards, content: EditCards.init)
        .onAppear(perform: resetCards)
    }
    
    func deleteCard(at index: Int) {
        guard index >= 0 else { return }
        let cardToDelete = cards[index]
        modelContext.delete(cardToDelete)
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context after deletion.")
        }
            
            if cards.isEmpty {
                isActive = false
            }
    }
    
    func resetCards() {
        timeRemaining = 100
        isActive = true
        loadData()
    }
 
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decodedCards = try? JSONDecoder().decode([Card].self, from: data) {
                for card in decodedCards {
                    modelContext.insert(card)
                }
                do {
                    try modelContext.save()
                } catch {
                    print("Error saving the context: \(error)")
                }
            }
        }
    }
    
//    func loadData() {
//        do {
//            guard let url = Bundle.main.url(forResource: "cards", withExtension: "json") else {
//                fatalError("Failed to find cards.json.")
//            }
//            
//            let data = try Data(contentsOf: url)
//            let cards = try JSONDecoder().decode([Card].self, from: data)
//            
//            for card in cards {
//                modelContext.insert(card)
//            }
//        } catch {
//                print("Failed to load card.")
//            }
//    }
}

#Preview {
    ContentView()
}
