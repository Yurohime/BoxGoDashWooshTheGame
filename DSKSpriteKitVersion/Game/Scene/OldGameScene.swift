////
////  OldGameScene.swift
////  DSKSpriteKitVersion
////
////  Created by Alberto Halim Limantoro on 11/08/25.
////
//
//
//import SpriteKit
//import SwiftUI
//
//class GameScene: SKScene, SKPhysicsContactDelegate {
//    
//    var box: SKShapeNode!
//    var dragStart: CGPoint?
//    var dragEnd: CGPoint?
//    var aimLine: SKShapeNode!
//    var hasLaunched = false
//    var highestCameraY: CGFloat = 0
//    var lastSpawnY: CGFloat = 0
//    var backgroundNode: SKSpriteNode!
//    var glowNode: SKShapeNode!
//    var trailEmitter: SKEmitterNode!
//    var onGameOver: (() -> Void)?
//    var backgroundSegments: [SKEmitterNode] = []
//    var backgroundParticleTexture: SKTexture?
//    let backgroundSegmentHeightMultiplier: CGFloat = 2.5
//    let backgroundSegmentOverlap: CGFloat = 300
//    let backgroundSpawnAheadThresholdMultiplier: CGFloat = 1.0
//    var lastCameraY: CGFloat = 0
//    
//    // --- NEW PROPERTIES FOR SCORE ---
//    var scoreLabel: SKLabelNode!
//    var currentScore: Int = 0
//    
//    override func didMove(to view: SKView) {
//        
//        //SoundManager.shared.playSFX(named: "Bounce", pitchVariation: 0.1)
//        //SoundManager.shared.playSFX(named: "Dash", pitchVariation: 0.1)
//        //SoundManager.shared.playSFX(named: "Lose", pitchVariation: 0.0)
//        
//        // The order here is important. Background must be set up before the camera.
//        backgroundColor = .white
//        
//        setupBackgroundGradient()
//        setupBackgroundParticles()
//        setupSideWalls()
//        setupBox()
//        setupAimLine()
//        setupCamera()
//        
//        // --- NEW: Set up the score label ---
//        setupScoreLabel()
//        
//        SoundManager.shared.playBGM(named: "BGM")
//        
//        physicsWorld.gravity = .zero
//        physicsWorld.contactDelegate = self
//        physicsWorld.speed = GameConstants.gameSpeedNormal // Set initial speed
//    }
//    
//    // --- NEW: Function to create and position the score label ---
//    func setupScoreLabel() {
//        // Use a thin, elegant font.
//        scoreLabel = SKLabelNode(fontNamed: "HelveticaNeue-UltraLight")
//        scoreLabel.fontSize = 62
//        scoreLabel.fontColor = UIColor.white.withAlphaComponent(0.9)
//        scoreLabel.text = "0"
//        scoreLabel.zPosition = 1000
//        if let cam = camera {
//            scoreLabel.position = CGPoint(x: 0, y: (view!.bounds.height / 2) - 190)
//            cam.addChild(scoreLabel)
//        }
//    }
//    
//    func setupBackgroundParticles() {
//        // prepare a tiny circle texture once
//        if backgroundParticleTexture == nil {
//            let circleNode = SKShapeNode(circleOfRadius: 1.5)
//            circleNode.fillColor = .white
//            circleNode.strokeColor = .clear
//            if let tex = SKView().texture(from: circleNode) {
//                backgroundParticleTexture = tex
//            }
//        }
//
//        // clear old segments if any
//        for s in backgroundSegments { s.removeFromParent() }
//        backgroundSegments.removeAll()
//
//        // create two initial stacked segments so there's immediate coverage
//        let segmentHeight = size.height * backgroundSegmentHeightMultiplier
//        let firstY = frame.midY
//        let secondY = firstY + segmentHeight - backgroundSegmentOverlap
//
//        let segA = createBackgroundEmitter(atY: firstY)
//        let segB = createBackgroundEmitter(atY: secondY)
//
//        addChild(segA)
//        addChild(segB)
//        backgroundSegments.append(segA)
//        backgroundSegments.append(segB)
//    }
//    
//    func createBackgroundEmitter(atY y: CGFloat) -> SKEmitterNode {
//        let emitter = SKEmitterNode()
//        emitter.particleTexture = backgroundParticleTexture
//        emitter.particleSize = CGSize(width: 3, height: 3)
//        emitter.particleColor = .white
//        emitter.particleAlpha = 0.45
//        emitter.particleAlphaRange = 0.25
//        emitter.particleAlphaSpeed = -0.02
//
//        // tune these to taste (longer lifetime + larger spawn band prevents outrunning)
//        emitter.particleLifetime = 140
//        emitter.particleLifetimeRange = 40
//        emitter.particleBirthRate = 50
//        emitter.particleSpeed = 0
//        emitter.particleSpeedRange = 0
//
//        let segmentHeight = size.height * backgroundSegmentHeightMultiplier
//        emitter.particlePositionRange = CGVector(dx: size.width, dy: segmentHeight)
//
//        emitter.zPosition = -2
//        emitter.targetNode = self
//
//        // --- FIX IS HERE ---
//        // 1. Set the emitter's final position first.
//        emitter.position = CGPoint(x: frame.midX, y: y)
//
//        // 2. Then, "warm up" the emitter in its correct place.
//        emitter.advanceSimulationTime(TimeInterval(emitter.particleLifetime + emitter.particleLifetimeRange))
//
//        return emitter
//    }
//    
//    func setupBackgroundGradient() {
//        let size = self.size
//        
//        let bottomColor = UIColor(red: 0x2E/255.0, green: 0xCF/255.0, blue: 0xCF/255.0, alpha: 1.0)
//        let topColor = UIColor(red: 0x1B/255.0, green: 0x3B/255.0, blue: 0x88/255.0, alpha: 1.0)
//        
//        UIGraphicsBeginImageContext(size)
//        guard let context = UIGraphicsGetCurrentContext() else { return }
//        
//        let colors = [topColor.cgColor, bottomColor.cgColor] as CFArray
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let colorLocations: [CGFloat] = [0.0, 1.0]
//        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: colorLocations) else { return }
//        
//        context.drawLinearGradient(
//            gradient,
//            start: CGPoint(x: size.width / 2, y: size.height),
//            end: CGPoint(x: size.width / 2, y: 0),
//            options: []
//        )
//        
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        if let image = image {
//            let texture = SKTexture(image: image)
//            backgroundNode = SKSpriteNode(texture: texture)
//            backgroundNode.size = size
//            backgroundNode.zPosition = -1
//        }
//    }
//    
//    func setupSideWalls() {
//        let leftWall = SKNode()
//        leftWall.position = CGPoint(x: frame.minX, y: 0)
//        leftWall.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: -GameConstants.wallHeight/2),
//                                             to: CGPoint(x: 0, y: GameConstants.wallHeight/2))
//        leftWall.physicsBody?.restitution = 1.0
//        leftWall.physicsBody?.categoryBitMask = PhysicsCategory.wall
//        leftWall.physicsBody?.collisionBitMask = PhysicsCategory.box
//        addChild(leftWall)
//        
//        let rightWall = SKNode()
//        rightWall.position = CGPoint(x: frame.maxX, y: 0)
//        rightWall.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: -GameConstants.wallHeight/2),
//                                              to: CGPoint(x: 0, y: GameConstants.wallHeight/2))
//        rightWall.physicsBody?.restitution = 1.0
//        rightWall.physicsBody?.categoryBitMask = PhysicsCategory.wall
//        rightWall.physicsBody?.collisionBitMask = PhysicsCategory.box
//        addChild(rightWall)
//    }
//    
//    func createSquareTexture(size: CGSize, color: UIColor) -> SKTexture {
//        let shape = SKShapeNode(rectOf: size)
//        shape.fillColor = color
//        shape.strokeColor = .clear
//        let view = SKView()
//        return view.texture(from: shape)!
//    }
//
//    func setupBox() {
//        let size = CGSize(width: GameConstants.boxSize, height: GameConstants.boxSize)
//        let hitbox = CGSize(width: GameConstants.boxHitboxSize, height: GameConstants.boxHitboxSize)
//
//        box = SKShapeNode(rectOf: size)
//        box.fillColor = .white
//        box.lineWidth = 0
//        box.position = CGPoint(x: frame.midX, y: frame.midY / 2.5)
//        box.zPosition = 10
//
//        box.physicsBody = SKPhysicsBody(rectangleOf: hitbox)
//        box.physicsBody?.affectedByGravity = false
//        box.physicsBody?.allowsRotation = false
//        box.physicsBody?.restitution = 1.0
//        box.physicsBody?.friction = 0
//        box.physicsBody?.linearDamping = 0
//        box.physicsBody?.categoryBitMask = PhysicsCategory.box
//        box.physicsBody?.contactTestBitMask = PhysicsCategory.obstacle | PhysicsCategory.wall
//        box.physicsBody?.collisionBitMask = PhysicsCategory.wall | PhysicsCategory.obstacle
//
//        glowNode = SKShapeNode(rectOf: CGSize(width: GameConstants.boxSize, height: GameConstants.boxSize))
//        glowNode.fillColor = UIColor.white.withAlphaComponent(0.6)
//        glowNode.strokeColor = .clear
//        glowNode.zPosition = -1
//
//        let blur = SKEffectNode()
//        blur.shouldRasterize = true
//        blur.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": 28])
//        blur.addChild(glowNode)
//        box.addChild(blur)
//
//        let trailSize = CGSize(width: size.width / 3, height: size.height / 3)
//        let trailTexture = createSquareTexture(size: trailSize, color: .white)
//
//        let trailEmitter = SKEmitterNode()
//        trailEmitter.particleTexture = trailTexture
//        trailEmitter.particleColor = .white
//        trailEmitter.particleSize = trailSize
//        trailEmitter.particleAlpha = 0.5
//        trailEmitter.particleAlphaSpeed = -1.2
//        trailEmitter.particleLifetime = 1.2
//        trailEmitter.particleBirthRate = 80
//        trailEmitter.particlePositionRange = CGVector(dx: 25, dy: 25)
//        trailEmitter.targetNode = self
//        trailEmitter.zPosition = 9
//        trailEmitter.particleRotation = CGFloat.pi
//        trailEmitter.particleRotationRange = CGFloat.pi / 8
//
//        box.addChild(trailEmitter)
//        addChild(box)
//    }
//    
//    func setupAimLine() {
//        aimLine = SKShapeNode() // No longer needed for line drawing, but keeping var for compatibility
//        aimLine.isHidden = true
//        
//        // Create arrow sprite instead of line
//        let arrowTexture = SKTexture(imageNamed: "Arrow")
//        let arrowNode = SKSpriteNode(texture: arrowTexture)
//        arrowNode.name = "aimArrow"
//        arrowNode.zPosition = 100
//        arrowNode.isHidden = true
//        addChild(arrowNode)
//    }
//    
//    func setupCamera() {
//        let cam = SKCameraNode()
//        camera = cam
//        if let bg = backgroundNode {
//            bg.position = .zero
//            cam.addChild(bg)
//        }
//        addChild(cam)
//        highestCameraY = frame.midY
//        cam.position = CGPoint(x: frame.midX, y: highestCameraY)
//    }
//    
//    func spawnRandomObstacle(at height: CGFloat) {
//        let maxExtra = height / GameConstants.obstacleSizeGrowthRate
//        let size = GameConstants.obstacleMinSize + CGFloat.random(in: 0...maxExtra)
//        
//        let obstacle = SKShapeNode(rectOf: CGSize(width: size, height: size))
//        obstacle.fillColor = .black
//        obstacle.strokeColor = .black
//        
//        let randomX = CGFloat.random(in: frame.minX + size/2 ... frame.maxX - size/2)
//        obstacle.position = CGPoint(x: randomX, y: height)
//        obstacle.zRotation = CGFloat.random(in: 0...(CGFloat.pi * 2))
//        obstacle.zPosition = 1
//        
//        obstacle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size * GameConstants.obstacleHitboxScale,
//                                                                 height: size * GameConstants.obstacleHitboxScale))
//        obstacle.physicsBody?.isDynamic = false
//        obstacle.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
//        obstacle.physicsBody?.contactTestBitMask = PhysicsCategory.box
//        obstacle.physicsBody?.collisionBitMask = 0
//        
//        addChild(obstacle)
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        dragStart = touch.location(in: self)
//        physicsWorld.speed = GameConstants.gameSpeedSlow
//        aimLine.isHidden = false
//    }
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first, let start = dragStart else { return }
//        dragEnd = touch.location(in: self)
//        
//        guard let arrow = childNode(withName: "aimArrow") as? SKSpriteNode else { return }
//        
//        // Calculate vector from box to drag point
//        let dx = start.x - dragEnd!.x
//        let dy = start.y - dragEnd!.y
//        let distance = hypot(dx, dy)
//        
//        arrow.position = box.position
//        arrow.anchorPoint = CGPoint(x: 0.5, y: 0) // tail pivot
//        arrow.zRotation = atan2(dy, dx) - (.pi / 2)
//        
//        // Uniform scale
//        let baseScale: CGFloat = 0.01
//        let scaleFactor = min(distance / 1000, 0.5)
//        let finalScale = baseScale + scaleFactor * 0.5
//        arrow.setScale(finalScale) // sets both xScale and yScale
//        
//        arrow.isHidden = false
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let start = dragStart, let end = dragEnd else {
//            resetDrag()
//            return
//        }
//        
//        let dx = start.x - end.x
//        let dy = start.y - end.y
//        
//        if !hasLaunched {
//            hasLaunched = true
//            physicsWorld.gravity = CGVector(dx: 0, dy: GameConstants.gravity / GameConstants.gameSpeedNormal)
//            box.physicsBody?.affectedByGravity = true
//            
//            SoundManager.shared.playSFX(named: "Dash", pitchVariation: 0.1)
//        }
//        
//        let compensatedDx = (dx * GameConstants.launchMultiplier) / GameConstants.gameSpeedNormal
//        let compensatedDy = (dy * GameConstants.launchMultiplier) / GameConstants.gameSpeedNormal
//        box.physicsBody?.velocity = CGVector(dx: compensatedDx, dy: compensatedDy)
//        
//        resetDrag()
//    }
//    
//    
//    func resetDrag() {
//        physicsWorld.speed = GameConstants.gameSpeedNormal
//        dragStart = nil
//        dragEnd = nil
//        aimLine.isHidden = true
//        if let arrow = childNode(withName: "aimArrow") {
//            arrow.isHidden = true
//        }
//    }
//    
//    //-----------------------------------------------------------------------------------
//    //------------------------------ UPDATOR IS HERE ------------------------------------
//    //-----------------------------------------------------------------------------------
//    
//    override func update(_ currentTime: TimeInterval) {
//        super.update(currentTime)
//        guard let cam = camera else { return }
//
//        // --- smooth parallax using camera delta ---
//        let dy = cam.position.y - lastCameraY
//        lastCameraY = cam.position.y
//
//        let parallaxFactor: CGFloat = 0.1 // smaller -> more parallax depth
//
//        // move every background segment by dy * parallaxFactor and lock X
//        for seg in backgroundSegments {
//            seg.position.y += dy * parallaxFactor
//            seg.position.x = cam.position.x
//        }
//
//        // --- spawn a new segment above when camera approaches top of top segment ---
//        if let highestSegCenterY = backgroundSegments.map({ $0.position.y }).max() {
//            let segmentHeight = size.height * backgroundSegmentHeightMultiplier
//            let highestSegTop = highestSegCenterY + (segmentHeight / 2)
//
//            // spawn when camera is within screenHeight * multiplier of the top
//            let spawnThreshold = highestSegTop - (size.height * backgroundSpawnAheadThresholdMultiplier)
//            if cam.position.y > spawnThreshold {
//                // compute new center Y (stacked, with overlap)
//                let newCenterY = highestSegCenterY + segmentHeight - backgroundSegmentOverlap
//                let newSeg = createBackgroundEmitter(atY: newCenterY)
//                addChild(newSeg)
//                backgroundSegments.append(newSeg)
//            }
//        }
//
//        // --- cull old segments that fell far below camera to free memory ---
//        backgroundSegments.removeAll { seg in
//            let tooFarBelow = (cam.position.y - seg.position.y) > (size.height * 3) // tune multiplier
//            if tooFarBelow {
//                seg.removeFromParent()
//            }
//            return tooFarBelow
//        }
//
//        // --- your existing box + camera logic (unchanged) ---
//        if let vel = box.physicsBody?.velocity {
//            let angle = atan2(vel.dy, vel.dx) + CGFloat.pi
//            if let emitter = box.children.compactMap({ $0 as? SKEmitterNode }).first {
//                emitter.emissionAngle = angle
//            }
//        }
//
//        if box.position.y > highestCameraY {
//            highestCameraY = box.position.y
//            cam.position.y = highestCameraY
//        }
//
//        cam.position.x = frame.midX
//
//        if highestCameraY > lastSpawnY - GameConstants.obstacleSpawnSpacing {
//            lastSpawnY += GameConstants.obstacleSpawnSpacing
//            spawnRandomObstacle(at: lastSpawnY + GameConstants.boxSize)
//        }
//        
//        // --- NEW: Update score based on height ---
//        if hasLaunched {
//            // Calculate score based on vertical distance traveled from the start.
//            // Dividing by 10 to make the score increment at a reasonable pace.
//            let calculatedScore = Int(highestCameraY - frame.midY) / 10
//            if calculatedScore > currentScore {
//                currentScore = calculatedScore
//                scoreLabel.text = "\(currentScore)"
//            }
//        }
//
//        if box.position.y < cam.position.y - GameConstants.cameraYOffsetRestart {
//            SoundManager.shared.playSFX(named: "Lose")
//            restartGame()
//        }
//
//        updateBoxShapeAndRotation()
//    }
//    
//    func updateBoxShapeAndRotation() {
//        guard let velocity = box.physicsBody?.velocity else { return }
//        let speed = hypot(velocity.dx, velocity.dy)
//        
//        if speed > 1 {
//            let angle = atan2(velocity.dy, velocity.dx)
//            box.zRotation = angle
//        }
//        
//        let baseSize: CGFloat = GameConstants.boxSize * 0.6
//        let stretchFactor = min(speed / 200, 1.0)
//        let stretchedWidth = baseSize * (1 + stretchFactor * GameConstants.boxStretchMultiplier)
//        let stretchedHeight = baseSize * (1 - stretchFactor * GameConstants.boxSquashMultiplier)
//        
//        box.path = CGPath(rect: CGRect(
//            x: -stretchedWidth/2,
//            y: -stretchedHeight/2,
//            width: stretchedWidth,
//            height: stretchedHeight
//        ), transform: nil)
//    }
//    
//    func didBegin(_ contact: SKPhysicsContact) {
//        let categories = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
//        
//        if categories == (PhysicsCategory.box | PhysicsCategory.wall) {
//            SoundManager.shared.playSFX(named: "Bounce", pitchVariation: 0.2)
//        }
//        
//        if categories == (PhysicsCategory.box | PhysicsCategory.obstacle) {
//            SoundManager.shared.playSFX(named: "Lose")
//            restartGame()
//        }
//    }
//    
//    func restartGame() {
//        // --- NEW: Save score before restarting ---
//        SaveManager.shared.saveHighScore(score: currentScore)
//        
//        removeAllChildren()
//        removeAllActions()
//        hasLaunched = false
//        currentScore = 0 // Reset score for the new game
//        physicsWorld.gravity = .zero
//        //didMove(to: view!)
//        triggerGameOver()
//    }
//    
//    func triggerGameOver() {
//        let overlay = SKSpriteNode(color: .white, size: self.size)
//        overlay.position = CGPoint(x: size.width / 2, y: size.height / 2)
//        overlay.zPosition = 999
//        overlay.alpha = 0
//        addChild(overlay)
//        
//        SoundManager.shared.stopMusic()
//    
//        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
//        let wait = SKAction.wait(forDuration: 0.5)
//        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
//        
//        let sequence = SKAction.sequence([
//            fadeIn,
//            wait,
//            SKAction.run { [weak self] in
//                self?.onGameOver?()
//            }
//        ])
//        
//        overlay.run(sequence)
//    }
//}
//
//#Preview {
//    RootView()
//}
