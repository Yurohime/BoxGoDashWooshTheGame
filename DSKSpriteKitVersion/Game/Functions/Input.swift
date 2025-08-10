//
//  Input.swift
//  DSKSpriteKitVersion
//
//  Created by Alberto Halim Limantoro on 11/08/25.
//

import SpriteKit

extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        dragStart = touch.location(in: self)
        physicsWorld.speed = GameConstants.gameSpeedSlow
        aimLine.isHidden = false
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let start = dragStart else { return }
        dragEnd = touch.location(in: self)
        
        guard let arrow = childNode(withName: "aimArrow") as? SKSpriteNode else { return }
        
        let dx = start.x - dragEnd!.x
        let dy = start.y - dragEnd!.y
        let distance = hypot(dx, dy)
        
        arrow.position = box.position
        arrow.anchorPoint = CGPoint(x: 0.5, y: 0)
        arrow.zRotation = atan2(dy, dx) - (.pi / 2)
        
        let baseScale: CGFloat = 0.01
        let scaleFactor = min(distance / 1000, 0.5)
        let finalScale = baseScale + scaleFactor * 0.5
        arrow.setScale(finalScale)
        
        arrow.isHidden = false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let start = dragStart, let end = dragEnd else {
            resetDrag()
            return
        }
        
        let dx = start.x - end.x
        let dy = start.y - end.y
        
        if !hasLaunched {
            hasLaunched = true
            physicsWorld.gravity = CGVector(dx: 0, dy: GameConstants.gravity / GameConstants.gameSpeedNormal)
            box.physicsBody?.affectedByGravity = true
            SoundManager.shared.playSFX(named: "Dash", pitchVariation: 0.1)
        }
        
        let compensatedDx = (dx * GameConstants.launchMultiplier) / GameConstants.gameSpeedNormal
        let compensatedDy = (dy * GameConstants.launchMultiplier) / GameConstants.gameSpeedNormal
        box.physicsBody?.velocity = CGVector(dx: compensatedDx, dy: compensatedDy)
        
        resetDrag()
    }
    
    func resetDrag() {
        physicsWorld.speed = GameConstants.gameSpeedNormal
        dragStart = nil
        dragEnd = nil
        aimLine.isHidden = true
        if let arrow = childNode(withName: "aimArrow") {
            arrow.isHidden = true
        }
    }
}


