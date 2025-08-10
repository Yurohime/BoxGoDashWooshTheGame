//
//  Particles.swift
//  DSKSpriteKitVersion
//
//  Created by Alberto Halim Limantoro on 11/08/25.
//

import SpriteKit

extension GameScene {
    
    func setupBackgroundParticles() {
        if backgroundParticleTexture == nil {
            let circleNode = SKShapeNode(circleOfRadius: 1.5)
            circleNode.fillColor = .white
            circleNode.strokeColor = .clear
            if let tex = SKView().texture(from: circleNode) {
                backgroundParticleTexture = tex
            }
        }

        for s in backgroundSegments { s.removeFromParent() }
        backgroundSegments.removeAll()

        let segmentHeight = size.height * backgroundSegmentHeightMultiplier
        let firstY = frame.midY
        let secondY = firstY + segmentHeight - backgroundSegmentOverlap

        let segA = createBackgroundEmitter(atY: firstY)
        let segB = createBackgroundEmitter(atY: secondY)

        addChild(segA)
        addChild(segB)
        backgroundSegments.append(segA)
        backgroundSegments.append(segB)
    }
    
    func createBackgroundEmitter(atY y: CGFloat) -> SKEmitterNode {
        let emitter = SKEmitterNode()
        emitter.particleTexture = backgroundParticleTexture
        emitter.particleSize = CGSize(width: 3, height: 3)
        emitter.particleColor = .white
        emitter.particleAlpha = 0.45
        emitter.particleAlphaRange = 0.25
        emitter.particleAlphaSpeed = -0.02
        emitter.particleLifetime = 140
        emitter.particleLifetimeRange = 40
        emitter.particleBirthRate = 50
        emitter.particlePositionRange = CGVector(dx: size.width, dy: size.height * backgroundSegmentHeightMultiplier)
        emitter.zPosition = -2
        emitter.targetNode = self
        emitter.position = CGPoint(x: frame.midX, y: y)
        emitter.advanceSimulationTime(TimeInterval(emitter.particleLifetime + emitter.particleLifetimeRange))
        return emitter
    }
}


