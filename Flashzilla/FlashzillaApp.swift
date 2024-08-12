//
//  FlashzillaApp.swift
//  Flashzilla
//
//  Created by Дарья Яцынюк on 02.07.2024.
//
import SwiftData
import SwiftUI

@main
struct FlashzillaApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Card.self)
    }
}
