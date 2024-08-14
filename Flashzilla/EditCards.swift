//
//  EditCards.swift
//  Flashzilla
//
//  Created by Дарья Яцынюк on 15.07.2024.
//
import SwiftData
import SwiftUI

struct EditCards: View {
    @Environment(\.dismiss) var dismiss 
    @Environment(\.modelContext) var modelContext
    @Query var cards: [Card]
    @State private var newPromt = ""
    @State private var newAnswer = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section("Add new card") {
                    TextField("Prompt", text: $newPromt)
                    TextField("Answer", text: $newAnswer)
                    Button {
                        addCards()
                    } label: {
                        Text("Add card")
                            .font(.headline)
                    }
                }
                
                Section {
                    ForEach(0..<cards.count, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(cards[index].prompt)
                                .font(.headline)
                            Text(cards[index].answer)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: deleteCard)
                }
            }
            .navigationTitle("Edit Cards")
            .toolbar {
                Button("Done", action: done)
            }
            .onAppear(perform: loadData)
        }
    }
    
    func done() {
        dismiss()
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

    
    func saveData() {
        if let data = try? JSONEncoder().encode(cards) {
            UserDefaults.standard.set(data, forKey: "Cards")
        }
    }
    
    func addCards() {
        let trimmedPromt = newPromt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        guard trimmedPromt.isEmpty == false && trimmedAnswer.isEmpty == false else { return }
        
        let card = Card(prompt: trimmedPromt, answer: trimmedAnswer)
        modelContext.insert(card)
        saveData()
        cleanTextField()
    }
    
    func deleteCard(at offsets: IndexSet) {
        for index in offsets {
            let cardToDelete = cards[index]
            modelContext.delete(cardToDelete)
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context after deletion.")
        }
        
        saveData()
    }
    
    func cleanTextField() {
        newPromt = ""
        newAnswer = ""
    }
}

#Preview {
    EditCards()
}
