//
//  Update.swift
//  DSKSpriteKitVersion
//
//  Created by Alberto Halim Limantoro on 11/08/25.
//

import SpriteKit

extension GameScene {
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        guard let cam = camera else { return }

        let dy = cam.position.y - lastCameraY
        lastCameraY = cam.position.y

        let parallaxFactor: CGFloat = 0.1
        for seg in backgroundSegments {
            seg.position.y += dy * parallaxFactor
            seg.position.x = cam.position.x
        }

        if let highestSegCenterY = backgroundSegments.map({ $0.position.y }).max() {
            let segmentHeight = size.height * backgroundSegmentHeightMultiplier
            let highestSegTop = highestSegCenterY + (segmentHeight / 2)
            let spawnThreshold = highestSegTop - (size.height * backgroundSpawnAheadThresholdMultiplier)
            if cam.position.y > spawnThreshold {
                let newCenterY = highestSegCenterY + segmentHeight - backgroundSegmentOverlap
                let newSeg = createBackgroundEmitter(atY: newCenterY)
                addChild(newSeg)
                backgroundSegments.append(newSeg)
            }
        }

        backgroundSegments.removeAll { seg in
            let tooFarBelow = (cam.position.y - seg.position.y) > (size.height * 3)
            if tooFarBelow { seg.removeFromParent() }
            return tooFarBelow
        }

        if let vel = box.physicsBody?.velocity {
            let angle = atan2(vel.dy, vel.dx) + CGFloat.pi
            if let emitter = box.children.compactMap({ $0 as? SKEmitterNode }).first {
                emitter.emissionAngle = angle
            }
        }

        if box.position.y > highestCameraY {
            highestCameraY = box.position.y
            cam.position.y = highestCameraY
        }

        cam.position.x = frame.midX

        if highestCameraY > lastSpawnY - GameConstants.obstacleSpawnSpacing {
            lastSpawnY += GameConstants.obstacleSpawnSpacing
            spawnRandomObstacle(at: lastSpawnY + GameConstants.boxSize)
        }
        
        if hasLaunched {
            let calculatedScore = Int(highestCameraY - frame.midY) / 10
            if calculatedScore > currentScore {
                currentScore = calculatedScore
                scoreLabel.text = "\(currentScore)"
            }
        }

        if box.position.y < cam.position.y - GameConstants.cameraYOffsetRestart {
            SoundManager.shared.playSFX(named: "Lose")
            restartGame()
        }

        updateBoxShapeAndRotation()
    }
}
