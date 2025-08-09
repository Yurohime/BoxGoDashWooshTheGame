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
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        
        setupSideWalls()
        setupBox()
        setupAimLine()
        setupCamera()
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
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
    
    func setupBox() {
        let size = CGSize(width: GameConstants.boxSize, height: GameConstants.boxSize)
        let hitbox = CGSize(width: GameConstants.boxHitboxSize, height: GameConstants.boxHitboxSize)
        
        box = SKShapeNode(rectOf: size, cornerRadius: GameConstants.boxCornerRadius)
        box.fillColor = .white
        box.strokeColor = .black
        box.lineWidth = 2
        box.position = CGPoint(x: frame.midX, y: frame.midY/3)
        
        box.physicsBody = SKPhysicsBody(rectangleOf: hitbox)
        box.physicsBody?.affectedByGravity = false
        box.physicsBody?.allowsRotation = false
        box.physicsBody?.restitution = 1.0
        box.physicsBody?.friction = 0
        box.physicsBody?.linearDamping = 0
        box.physicsBody?.categoryBitMask = PhysicsCategory.box
        box.physicsBody?.contactTestBitMask = PhysicsCategory.obstacle
        box.physicsBody?.collisionBitMask = PhysicsCategory.wall | PhysicsCategory.obstacle
        
        addChild(box)
    }
    
    func setupAimLine() {
        aimLine = SKShapeNode()
        aimLine.strokeColor = .red
        aimLine.lineWidth = 2
        aimLine.isHidden = true
        addChild(aimLine)
    }
    
    func setupCamera() {
        let cam = SKCameraNode()
        camera = cam
        addChild(cam)
        
        highestCameraY = frame.midY
        cam.position = CGPoint(x: frame.midX, y: highestCameraY)
    }
    
    func spawnRandomObstacle(at height: CGFloat) {
        let maxExtra = height / GameConstants.obstacleSizeGrowthRate
        let size = GameConstants.obstacleMinSize + CGFloat.random(in: 0...maxExtra)
        let obstacle = SKShapeNode(rectOf: CGSize(width: size, height: size))
        obstacle.fillColor = .black
        
        let randomX = CGFloat.random(in: frame.minX + size/2 ... frame.maxX - size/2)
        obstacle.position = CGPoint(x: randomX, y: height)
        obstacle.zRotation = CGFloat.random(in: 0...(CGFloat.pi * 2)) // random rotation
        
        obstacle.physicsBody = SKPhysicsBody(
            rectangleOf: CGSize(
                width: size * GameConstants.obstacleHitboxScale,
                height: size * GameConstants.obstacleHitboxScale
            )
        )
        
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
        obstacle.physicsBody?.contactTestBitMask = PhysicsCategory.box
        obstacle.physicsBody?.collisionBitMask = 0
        
        addChild(obstacle)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        dragStart = touch.location(in: self)
        physicsWorld.speed = 0.2
        aimLine.isHidden = false
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let start = dragStart else { return }
        dragEnd = touch.location(in: self)
        
        let path = CGMutablePath()
        path.move(to: box.position)
        path.addLine(to: CGPoint(
            x: box.position.x - (dragEnd!.x - start.x),
            y: box.position.y - (dragEnd!.y - start.y)
        ))
        aimLine.path = path
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
            physicsWorld.gravity = CGVector(dx: 0, dy: GameConstants.gravity)
            box.physicsBody?.affectedByGravity = true
        }
        
        box.physicsBody?.velocity = CGVector(dx: dx * GameConstants.launchMultiplier, dy: dy * GameConstants.launchMultiplier)
        
        resetDrag()
    }
    
    func resetDrag() {
        physicsWorld.speed = 1.0
        dragStart = nil
        dragEnd = nil
        aimLine.isHidden = true
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard let cam = camera else { return }

        if box.position.y > highestCameraY {
            highestCameraY = box.position.y
            cam.position.y = highestCameraY
        }
        
        cam.position.x = frame.midX
        
        if highestCameraY > lastSpawnY - GameConstants.obstacleSpawnSpacing {
            lastSpawnY += GameConstants.obstacleSpawnSpacing
            spawnRandomObstacle(at: lastSpawnY + GameConstants.boxSize)
        }
        
        if box.position.y < cam.position.y - GameConstants.cameraYOffsetRestart {
            restartGame()
        }
        
        print(cam.position.y)
        
        updateBoxShapeAndRotation()
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
        
        box.path = CGPath(roundedRect: CGRect(
            x: -stretchedWidth/2,
            y: -stretchedHeight/2,
            width: stretchedWidth,
            height: stretchedHeight
        ), cornerWidth: GameConstants.boxCornerRadius, cornerHeight: GameConstants.boxCornerRadius, transform: nil)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let categories = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if categories == (PhysicsCategory.box | PhysicsCategory.obstacle) {
            restartGame()
        }
    }
    
    func restartGame() {
        removeAllChildren()
        removeAllActions()
        hasLaunched = false
        physicsWorld.gravity = .zero
        didMove(to: view!)
    }
}

#Preview {
    GameView()
}
