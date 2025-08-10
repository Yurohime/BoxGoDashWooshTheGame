//
//  GameScene.swift
//  RoboGame
//
//  Created by Alberto Halim Limantoro on 09/07/25.
//

import SpriteKit
import SwiftUI

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var box: SKShapeNode!
    var dragStart: CGPoint?
    var dragEnd: CGPoint?
    var aimLine: SKShapeNode!
    var hasLaunched = false
    var highestCameraY: CGFloat = 0
    var lastSpawnY: CGFloat = 0
    var backgroundNode: SKSpriteNode!
    var glowNode: SKShapeNode!
    var trailEmitter: SKEmitterNode!
    var onGameOver: (() -> Void)?
    var backgroundSegments: [SKEmitterNode] = []
    var backgroundParticleTexture: SKTexture?
    let backgroundSegmentHeightMultiplier: CGFloat = 2.5
    let backgroundSegmentOverlap: CGFloat = 300
    let backgroundSpawnAheadThresholdMultiplier: CGFloat = 1.0
    var lastCameraY: CGFloat = 0
    
    // --- NEW PROPERTIES FOR SCORE ---
    var scoreLabel: SKLabelNode!
    var currentScore: Int = 0
    
    override func didMove(to view: SKView) {
        
        //SoundManager.shared.playSFX(named: "Bounce", pitchVariation: 0.1)
        //SoundManager.shared.playSFX(named: "Dash", pitchVariation: 0.1)
        //SoundManager.shared.playSFX(named: "Lose", pitchVariation: 0.0)
        
        // The order here is important. Background must be set up before the camera.
        backgroundColor = .white
        
        setupBackgroundGradient()
        setupBackgroundParticles()
        setupSideWalls()
        setupBox()
        setupAimLine()
        setupCamera()
        
        // --- NEW: Set up the score label ---
        setupScoreLabel()
        
        SoundManager.shared.playBGM(named: "BGM")
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        physicsWorld.speed = GameConstants.gameSpeedNormal // Set initial speed
    }
}

#Preview {
    RootView()
}
