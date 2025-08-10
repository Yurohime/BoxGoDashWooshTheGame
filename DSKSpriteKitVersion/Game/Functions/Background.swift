//
//  Background.swift
//  DSKSpriteKitVersion
//
//  Created by Alberto Halim Limantoro on 11/08/25.
//

import SpriteKit

extension GameScene {
    
    func setupBackgroundGradient() {
        let size = self.size
        
        let bottomColor = UIColor(red: 0x2E/255.0, green: 0xCF/255.0, blue: 0xCF/255.0, alpha: 1.0)
        let topColor = UIColor(red: 0x1B/255.0, green: 0x3B/255.0, blue: 0x88/255.0, alpha: 1.0)
        
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let colors = [topColor.cgColor, bottomColor.cgColor] as CFArray
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 1.0]
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: colorLocations) else { return }
        
        context.drawLinearGradient(
            gradient,
            start: CGPoint(x: size.width / 2, y: size.height),
            end: CGPoint(x: size.width / 2, y: 0),
            options: []
        )
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let image = image {
            let texture = SKTexture(image: image)
            backgroundNode = SKSpriteNode(texture: texture)
            backgroundNode.size = size
            backgroundNode.zPosition = -1
        }
    }
    
    func setupSideWalls() {
        let leftWall = SKNode()
        leftWall.position = CGPoint(x: frame.minX, y: 0)
        leftWall.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: -GameConstants.wallHeight/2),
                                             to: CGPoint(x: 0, y: GameConstants.wallHeight/2))
        leftWall.physicsBody?.restitution = 1.0
        leftWall.physicsBody?.categoryBitMask = PhysicsCategory.wall
        leftWall.physicsBody?.collisionBitMask = PhysicsCategory.box
        addChild(leftWall)
        
        let rightWall = SKNode()
        rightWall.position = CGPoint(x: frame.maxX, y: 0)
        rightWall.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: -GameConstants.wallHeight/2),
                                              to: CGPoint(x: 0, y: GameConstants.wallHeight/2))
        rightWall.physicsBody?.restitution = 1.0
        rightWall.physicsBody?.categoryBitMask = PhysicsCategory.wall
        rightWall.physicsBody?.collisionBitMask = PhysicsCategory.box
        addChild(rightWall)
    }
}


