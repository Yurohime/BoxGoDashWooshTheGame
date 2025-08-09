//
//  Constants.swift
//  DSKSpriteKitVersion
//
//  Created by Alberto Halim Limantoro on 09/08/25.
//

import SpriteKit
import SwiftUI

struct GameConstants {
    
    // Our Thingy
    static let boxSize: CGFloat = 50
    static let boxHitboxSize: CGFloat = 30
    static let boxCornerRadius: CGFloat = 4
    static let boxStretchMultiplier: CGFloat = 0.2
    static let boxSquashMultiplier: CGFloat = 0.1
    
    // Wall / Score
    static let wallHeight: CGFloat = 100000
    
    // The Blacks
    static let obstacleMinSize: CGFloat = 30
    static let obstacleSizeGrowthRate: CGFloat = 60 // higher = slower growth
    static let obstacleHitboxScale: CGFloat = 0.8
    static let obstacleSpawnSpacing: CGFloat = 200
    
    // Physics
    static let gravity: CGFloat = -4.8
    static let launchMultiplier: CGFloat = 2.0
    
    // Camera
    static let cameraYOffsetRestart: CGFloat = 450
}

#Preview {
    GameView()
}
