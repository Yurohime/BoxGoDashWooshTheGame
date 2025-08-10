//
//  Obstacle.swift
//  DSKSpriteKitVersion
//
//  Created by Alberto Halim Limantoro on 11/08/25.
//


import SpriteKit

extension GameScene {
    func spawnRandomObstacle(at height: CGFloat) {
        let maxExtra = height / GameConstants.obstacleSizeGrowthRate
        let size = GameConstants.obstacleMinSize + CGFloat.random(in: 0...maxExtra)
        
        let obstacle = SKShapeNode(rectOf: CGSize(width: size, height: size))
        obstacle.fillColor = .black
        obstacle.strokeColor = .black
        
        let randomX = CGFloat.random(in: frame.minX + size/2 ... frame.maxX - size/2)
        obstacle.position = CGPoint(x: randomX, y: height)
        obstacle.zRotation = CGFloat.random(in: 0...(CGFloat.pi * 2))
        obstacle.zPosition = 1
        
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size * GameConstants.obstacleHitboxScale,
                                                                 height: size * GameConstants.obstacleHitboxScale))
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
        obstacle.physicsBody?.contactTestBitMask = PhysicsCategory.box
        obstacle.physicsBody?.collisionBitMask = 0
        
        addChild(obstacle)
    }
}




