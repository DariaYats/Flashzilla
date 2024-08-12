//
//  EditCards.swift
//  Flashzilla
//
//  Created by Дарья Яцынюк on 15.07.2024.
//

import SwiftUI

struct EditCards: View {
    @Environment(\.dismiss) var dismiss 
    @State private var cards = [Card]()
    @State private var newPromt = ""
    @State private var newAnswer = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section("Add new card") {
                    TextField("Promt", text: $newPromt)
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
                            Text(cards[index].promt)
                                .font(.headline)
                            Text(cards[index].answer)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: removeCards)
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
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                let cards = decoded
            }
        }
    }
    
    func saveData() {
        if let data = try? JSONEncoder().encode(cards) {
            UserDefaults.standard.set(data, forKey: "Cards")
        }
    }
    
    func addCards() {
        let trimmedPromt = newPromt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        guard trimmedPromt.isEmpty == false && trimmedAnswer.isEmpty == false else { return }
        
        let card = Card(promt: trimmedPromt, answer: trimmedAnswer)
        cards.insert(card, at: 0)
        saveData()
        cleanTextField()
    }
    
    func removeCards(at offsets: IndexSet) {
        cards.remove(atOffsets: offsets)
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
