//
//  SaveManager.swift
//  Lolz's DnD Helper
//
//  Created by Alberto Halim Limantoro on 04/08/25.
//

import Foundation

public struct ExpTask: Codable, Identifiable {
    public let id: UUID
    public var name: String
    public var expValue: Int
}

public struct Player: Codable, Identifiable {
    public let id: UUID
    public var name: String
    public var exp: Int
    public var completedTasks: [UUID: Bool]
}


public class SaveManager {
    
    public static let shared = SaveManager()
    
    private let playersFilename = "players.json"
    private let tasksFilename = "tasks.json"
    
    private func getURL(for filename: String) -> URL {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return directory.appendingPathComponent(filename)
    }
    
    private init() {}
    
    // MARK: - Player Data Functions
    
    public func save(players: [Player]) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(players)
            try data.write(to: getURL(for: playersFilename), options: [.atomicWrite])
            print("Players saved successfully.")
        } catch {
            print("Failed to save players: \(error.localizedDescription)")
        }
    }
    
    public func loadPlayers() -> [Player] {
        do {
            let data = try Data(contentsOf: getURL(for: playersFilename))
            let decoder = JSONDecoder()
            let players = try decoder.decode([Player].self, from: data)
            print("Players loaded successfully.")
            return players
        } catch {
            print("Failed to load players, returning empty array: \(error.localizedDescription)")
            return []
        }
    }
    
    // MARK: - ExpTask Data Functions
    
    public func save(tasks: [ExpTask]) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(tasks)
            try data.write(to: getURL(for: tasksFilename), options: [.atomicWrite])
            print("Tasks saved successfully.")
        } catch {
            print("Failed to save tasks: \(error.localizedDescription)")
        }
    }
    
    public func loadTasks() -> [ExpTask] {
        do {
            let data = try Data(contentsOf: getURL(for: tasksFilename))
            let decoder = JSONDecoder()
            let tasks = try decoder.decode([ExpTask].self, from: data)
            print("Tasks loaded successfully.")
            return tasks
        } catch {
            print("Failed to load tasks, returning empty array: \(error.localizedDescription)")
            return []
        }
    }
}

