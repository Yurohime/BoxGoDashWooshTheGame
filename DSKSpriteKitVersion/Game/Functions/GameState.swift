//
//  GameState.swift
//  DSKSpriteKitVersion
//
//  Created by Alberto Halim Limantoro on 11/08/25.
//

import SpriteKit

extension GameScene {
    
    func restartGame() {
        SaveManager.shared.saveHighScore(score: currentScore)
        removeAllChildren()
        removeAllActions()
        hasLaunched = false
        currentScore = 0
        physicsWorld.gravity = .zero
        triggerGameOver()
    }
    
    func triggerGameOver() {
        let overlay = SKSpriteNode(color: .white, size: self.size)
        overlay.position = CGPoint(x: size.width / 2, y: size.height / 2)
        overlay.zPosition = 999
        overlay.alpha = 0
        addChild(overlay)
        
        SoundManager.shared.stopMusic()
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        let wait = SKAction.wait(forDuration: 0.5)
        
        let sequence = SKAction.sequence([
            fadeIn,
            wait,
            SKAction.run { [weak self] in
                self?.onGameOver?()
            }
        ])
        
        overlay.run(sequence)
    }
}


