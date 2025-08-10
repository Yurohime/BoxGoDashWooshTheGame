//
//  SaveManager.swift
//  DSKSpriteKitVersion
//
//  Created by Alberto Halim Limantoro on 10/08/25.
//


import Foundation

/// A simple struct to hold the game data that we want to save.
struct GameData: Codable {
    var highScore: Int
}

/// A singleton class to manage saving and loading game data.
class SaveManager {
    /// The shared singleton instance of the SaveManager.
    static let shared = SaveManager()
    
    /// The URL to the JSON file where the game data is stored.
    private let fileURL: URL

    private init() {
        // Find the app's documents directory and create a path for our save file.
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unable to access document directory.")
        }
        fileURL = url.appendingPathComponent("gameData.json")
    }

    /// Saves the player's score, but only if it's a new high score.
    /// - Parameter score: The score to be saved.
    func saveHighScore(score: Int) {
        let currentHighScore = loadHighScore()
        
        // We only overwrite the file if the new score is better.
        guard score > currentHighScore else { return }
        
        let gameData = GameData(highScore: score)
        do {
            // Encode the GameData struct into JSON data.
            let data = try JSONEncoder().encode(gameData)
            // Write the data to the file.
            try data.write(to: fileURL)
        } catch {
            print("Error saving high score: \(error.localizedDescription)")
        }
    }

    /// Loads the high score from the JSON file.
    /// - Returns: The saved high score, or 0 if no score has been saved yet.
    func loadHighScore() -> Int {
        do {
            // Read the data from the file.
            let data = try Data(contentsOf: fileURL)
            // Decode the JSON data back into our GameData struct.
            let gameData = try JSONDecoder().decode(GameData.self, from: data)
            return gameData.highScore
        } catch {
            // If the file doesn't exist or there's a decoding error, it means no high score is set.
            // We'll just return 0 and not log an error, as this is expected on the first run.
            return 0
        }
    }
}
