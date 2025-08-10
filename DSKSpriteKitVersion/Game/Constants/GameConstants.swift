//
//  GameConstants.swift
//  DSKSpriteKitVersion
//
//  Created by Alberto Halim Limantoro on 11/08/25.
//
import Foundation
import SpriteKit
import SwiftUI

struct GameConstants {
    // Box
    static let boxSize: CGFloat = 50
    static let boxHitboxSize: CGFloat = 20
    static let boxCornerRadius: CGFloat = 4
    static let boxStretchMultiplier: CGFloat = 0.02
    static let boxSquashMultiplier: CGFloat = 0.01
    
    // Walls
    static let wallHeight: CGFloat = 100000
    
    // Obstacles
    static let obstacleMinSize: CGFloat = 30
    static let obstacleSizeGrowthRate: CGFloat = 60
    static let obstacleHitboxScale: CGFloat = 0.8
    static let obstacleSpawnSpacing: CGFloat = 200
    
    // Physics
    static let gravity: CGFloat = -2.8
    static let launchMultiplier: CGFloat = 3.0
    static let gameSpeedNormal: CGFloat = 2.5
    static let gameSpeedSlow: CGFloat = 0.5
    
    // Camera
    static let cameraYOffsetRestart: CGFloat = 450
}

#Preview {
    RootView()
}

