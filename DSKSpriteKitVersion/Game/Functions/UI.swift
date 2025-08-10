//
//  UI.swift
//  DSKSpriteKitVersion
//
//  Created by Alberto Halim Limantoro on 11/08/25.
//

import SpriteKit

extension GameScene {
    
    func setupBox() {
        let size = CGSize(width: GameConstants.boxSize, height: GameConstants.boxSize)
        let hitbox = CGSize(width: GameConstants.boxHitboxSize, height: GameConstants.boxHitboxSize)

        box = SKShapeNode(rectOf: size)
        box.fillColor = .white
        box.lineWidth = 0
        box.position = CGPoint(x: frame.midX, y: frame.midY / 2.5)
        box.zPosition = 10

        box.physicsBody = SKPhysicsBody(rectangleOf: hitbox)
        box.physicsBody?.affectedByGravity = false
        box.physicsBody?.allowsRotation = false
        box.physicsBody?.restitution = 1.0
        box.physicsBody?.friction = 0
        box.physicsBody?.linearDamping = 0
        box.physicsBody?.categoryBitMask = PhysicsCategory.box
        box.physicsBody?.contactTestBitMask = PhysicsCategory.obstacle | PhysicsCategory.wall
        box.physicsBody?.collisionBitMask = PhysicsCategory.wall | PhysicsCategory.obstacle

        glowNode = SKShapeNode(rectOf: CGSize(width: GameConstants.boxSize, height: GameConstants.boxSize))
        glowNode.fillColor = UIColor.white.withAlphaComponent(0.6)
        glowNode.strokeColor = .clear
        glowNode.zPosition = -1

        let blur = SKEffectNode()
        blur.shouldRasterize = true
        blur.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": 28])
        blur.addChild(glowNode)
        box.addChild(blur)

        let trailSize = CGSize(width: size.width / 3, height: size.height / 3)
        let trailTexture = createSquareTexture(size: trailSize, color: .white)

        let trailEmitter = SKEmitterNode()
        trailEmitter.particleTexture = trailTexture
        trailEmitter.particleColor = .white
        trailEmitter.particleSize = trailSize
        trailEmitter.particleAlpha = 0.5
        trailEmitter.particleAlphaSpeed = -1.2
        trailEmitter.particleLifetime = 1.2
        trailEmitter.particleBirthRate = 80
        trailEmitter.particlePositionRange = CGVector(dx: 25, dy: 25)
        trailEmitter.targetNode = self
        trailEmitter.zPosition = 9
        trailEmitter.particleRotation = CGFloat.pi
        trailEmitter.particleRotationRange = CGFloat.pi / 8

        box.addChild(trailEmitter)
        addChild(box)
    }
    
    
        func setupAimLine() {
            aimLine = SKShapeNode() // No longer needed for line drawing, but keeping var for compatibility
            aimLine.isHidden = true
    
            // Create arrow sprite instead of line
            let arrowTexture = SKTexture(imageNamed: "Arrow")
            let arrowNode = SKSpriteNode(texture: arrowTexture)
            arrowNode.name = "aimArrow"
            arrowNode.zPosition = 100
            arrowNode.isHidden = true
            addChild(arrowNode)
        }
    
    func createSquareTexture(size: CGSize, color: UIColor) -> SKTexture {
        let shape = SKShapeNode(rectOf: size)
        shape.fillColor = color
        shape.strokeColor = .clear
        let view = SKView()
        return view.texture(from: shape)!
    }
    
    
    func setupScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "HelveticaNeue-UltraLight")
        scoreLabel.fontSize = 62
        scoreLabel.fontColor = UIColor.white.withAlphaComponent(0.9)
        scoreLabel.text = "0"
        scoreLabel.zPosition = 1000
        if let cam = camera {
            scoreLabel.position = CGPoint(x: 0, y: (view!.bounds.height / 2) - 190)
            cam.addChild(scoreLabel)
        }
    }
    
    func setupCamera() {
        let cam = SKCameraNode()
        camera = cam
        if let bg = backgroundNode {
            bg.position = .zero
            cam.addChild(bg)
        }
        addChild(cam)
        highestCameraY = frame.midY
        cam.position = CGPoint(x: frame.midX, y: highestCameraY)
    }
    
    func updateBoxShapeAndRotation() {
        guard let velocity = box.physicsBody?.velocity else { return }
        let speed = hypot(velocity.dx, velocity.dy)
        
        if speed > 1 {
            let angle = atan2(velocity.dy, velocity.dx)
            box.zRotation = angle
        }
        
        let baseSize: CGFloat = GameConstants.boxSize * 0.6
        let stretchFactor = min(speed / 200, 1.0)
        let stretchedWidth = baseSize * (1 + stretchFactor * GameConstants.boxStretchMultiplier)
        let stretchedHeight = baseSize * (1 - stretchFactor * GameConstants.boxSquashMultiplier)
        
        box.path = CGPath(rect: CGRect(
            x: -stretchedWidth/2,
            y: -stretchedHeight/2,
            width: stretchedWidth,
            height: stretchedHeight
        ), transform: nil)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let categories = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if categories == (PhysicsCategory.box | PhysicsCategory.wall) {
            SoundManager.shared.playSFX(named: "Bounce", pitchVariation: 0.2)
        }
        
        if categories == (PhysicsCategory.box | PhysicsCategory.obstacle) {
            SoundManager.shared.playSFX(named: "Lose")
            restartGame()
        }
    }
}

