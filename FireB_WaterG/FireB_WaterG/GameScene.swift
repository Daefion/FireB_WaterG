import SpriteKit
import GameplayKit


struct Categoria {
    static let none: UInt32 = 0
    static let all: UInt32 = UInt32.max
    static let player1: UInt32 = 0b1
    static let player2: UInt32 = 0b10
    static let deathPool1: UInt32 = 0b100
    static let deathPool2: UInt32 = 0b1000
    static let greenPool: UInt32 = 0b10000
    static let ground: UInt32 = 0b100000
    static let lever: UInt32 = 0b1000000
    static let button1: UInt32 = 0b10000000
    static let button2: UInt32 = 0b100000000
    static let platform: UInt32 = 0b1000000000
    static let door1: UInt32 = 0b10000000000
    static let door2: UInt32 = 0b100000000000
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - Nodes
    var player1: SKSpriteNode!
    var player2: SKSpriteNode!
    var initialPlayer1Position = CGPoint.zero
    var initialPlayer2Position = CGPoint.zero
    
    var greenPool: SKSpriteNode!
    var deathPool1: SKSpriteNode!
    var deathPool2: SKSpriteNode!

    // Player 1 controls
    var leftButton1: SKSpriteNode!
    var rightButton1: SKSpriteNode!
    var jumpButton1: SKSpriteNode!
    
    // Player 2 controls
    var leftButton2: SKSpriteNode!
    var rightButton2: SKSpriteNode!
    var jumpButton2: SKSpriteNode!
    
    var lever: SKSpriteNode!
    var platform1: SKSpriteNode!
    var platform2: SKSpriteNode!
    var platform2InitialPosition: CGPoint!
    var button1: SKSpriteNode!
    var button2: SKSpriteNode!
    
    var door1: SKSpriteNode!
    var door2: SKSpriteNode!
    
    // Movement flags
    var moveLeft1 = false
    var moveRight1 = false
    var moveLeft2 = false
    var moveRight2 = false
    
    // Button animations
    let scaleButton = SKAction.scaleY(to: 0.5, duration: 1.0)
    let scaleButtonUp = SKAction.scaleY(to: 1.0, duration: 1.0)
    
    // MARK: - Scene Setup
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
                background.position = CGPoint(x: frame.midX, y: frame.midY)
                background.zPosition = -1
                background.size = self.size
                addChild(background)
        
        let backgroundMusic = SKAudioNode(fileNamed: "adv.mp3")
            backgroundMusic.autoplayLooped = true
            addChild(backgroundMusic)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
        
        createPlayers()
        createMap()
        createDeathPools()
        createControls()
        createLever()
        createPlatform()
        createGreenPool()
        createButton()
        createDoor()
        
        platform2InitialPosition = platform2.position
    }
    
    func createPlayers() {
            // Player 1 (original player)
            player1 = SKSpriteNode(color: .red, size: CGSize(width: 20, height: 20))
            initialPlayer1Position = CGPoint(x: frame.minX + 20, y: frame.minY + 40)
            player1.position = initialPlayer1Position
            player1.name = "player1"
            
            player1.physicsBody = SKPhysicsBody(rectangleOf: player1.size)
            player1.physicsBody?.affectedByGravity = true
            player1.physicsBody?.allowsRotation = false
            player1.physicsBody?.restitution = 0
            player1.physicsBody?.friction = 0.2
            
            player1.physicsBody?.categoryBitMask = Categoria.player1
            player1.physicsBody?.contactTestBitMask = Categoria.deathPool2 | Categoria.greenPool
        player1.physicsBody?.collisionBitMask = Categoria.ground | Categoria.lever | Categoria.platform
            addChild(player1)
            
            // Player 2 (new player)
            player2 = SKSpriteNode(color: .blue, size: CGSize(width: 20, height: 20))
            initialPlayer2Position = CGPoint(x: frame.minX + 20, y: frame.minY + 80)
            player2.position = initialPlayer2Position
            player2.name = "player2"
            
            player2.physicsBody = SKPhysicsBody(rectangleOf: player2.size)
            player2.physicsBody?.affectedByGravity = true
            player2.physicsBody?.allowsRotation = false
            player2.physicsBody?.restitution = 0
            player2.physicsBody?.friction = 0.2
            
            player2.physicsBody?.categoryBitMask = Categoria.player2
            player2.physicsBody?.contactTestBitMask = Categoria.deathPool1 | Categoria.greenPool
        player2.physicsBody?.collisionBitMask = Categoria.ground | Categoria.lever | Categoria.platform
            addChild(player2)
        }
    
    func createMap() {
        let staticBodies: [(SKSpriteNode, CGSize, CGPoint)] = [
            (SKSpriteNode(color: .gray, size: CGSize(width: frame.width, height: 10)), CGSize(width: frame.width, height: 10), CGPoint(x: frame.midX, y: frame.minY + 20)),
            (SKSpriteNode(color: .gray, size: CGSize(width: 20, height: frame.height)), CGSize(width: 20, height: frame.height), CGPoint(x: frame.minX, y: frame.midY)),
            (SKSpriteNode(color: .gray, size: CGSize(width: 20, height: frame.height)), CGSize(width: 20, height: frame.height), CGPoint(x: frame.maxX, y: frame.midY)),
            (SKSpriteNode(color: .gray, size: CGSize(width: frame.width, height: 10)), CGSize(width: frame.width, height: 10), CGPoint(x: frame.midX, y: frame.maxY - 20)),
            (SKSpriteNode(color: .gray, size: CGSize(width: 400, height: 5)), CGSize(width: 400, height: 5), CGPoint(x: frame.minX, y: frame.minY + 75)),
            (SKSpriteNode(color: .gray, size: CGSize(width: 800, height: 5)), CGSize(width: 800, height: 5), CGPoint(x: frame.minX, y: frame.minY + 130)),
            (SKSpriteNode(color: .gray, size: CGSize(width: 320, height: 5)), CGSize(width: 320, height: 5), CGPoint(x: frame.minX + 560, y: frame.minY + 100)),
            (SKSpriteNode(color: .gray, size: CGSize(width: 100, height: 70)), CGSize(width: 100, height: 70), CGPoint(x: frame.maxX - 30, y: frame.minY + 30)),
            (SKSpriteNode(color: .gray, size: CGSize(width: 750, height: 5)), CGSize(width: 750, height: 5), CGPoint(x: frame.midX + 50, y: frame.minY + 200)),
            (SKSpriteNode(color: .gray, size: CGSize(width: 750, height: 5)), CGSize(width: 750, height: 5), CGPoint(x: frame.midX - 50, y: frame.minY + 250)),
            (SKSpriteNode(color: .gray, size: CGSize(width: 100, height: 50)), CGSize(width: 100, height: 50), CGPoint(x: frame.minX, y: frame.minY + 270)),
            (SKSpriteNode(color: .gray, size: CGSize(width: 750, height: 5)), CGSize(width: 750, height: 5), CGPoint(x: frame.midX + 40, y: frame.minY + 300)),
        ]
        
        for (node, size, position) in staticBodies {
            node.position = position
            node.physicsBody = SKPhysicsBody(rectangleOf: size)
            node.physicsBody?.isDynamic = false
            node.physicsBody?.categoryBitMask = Categoria.ground
            node.physicsBody?.contactTestBitMask = Categoria.none
            node.physicsBody?.collisionBitMask = Categoria.player1 | Categoria.player2
            addChild(node)
        }
    }
    
    func createDeathPools() {
            // Pool1 (kills player2)
            deathPool1 = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 10))
        deathPool1.position = CGPoint(x: frame.midX + 200, y: frame.minY + 25)
        deathPool1.name = "deathPool1"
        deathPool1.alpha = 0.7
        deathPool1.physicsBody = SKPhysicsBody(rectangleOf: deathPool1.size)
        deathPool1.physicsBody?.isDynamic = false
        deathPool1.physicsBody?.categoryBitMask = Categoria.deathPool1
        deathPool1.physicsBody?.contactTestBitMask = Categoria.player2
        deathPool1.physicsBody?.collisionBitMask = Categoria.none
            addChild(deathPool1)
            
            // Pool2 (kills player1)
            deathPool2 = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 10))
        deathPool2.position = CGPoint(x: frame.midX, y: frame.minY + 25)
        deathPool2.name = "deathPool2"
        deathPool2.alpha = 0.7
        deathPool2.physicsBody = SKPhysicsBody(rectangleOf: deathPool2.size)
        deathPool2.physicsBody?.isDynamic = false
        deathPool2.physicsBody?.categoryBitMask = Categoria.deathPool2
        deathPool2.physicsBody?.contactTestBitMask = Categoria.player1
        deathPool2.physicsBody?.collisionBitMask = Categoria.none
            addChild(deathPool2)
        }
    
    func createGreenPool(){
        greenPool = SKSpriteNode(color: .init(red: 0, green: 0.65, blue: 0, alpha: 1), size: CGSize(width: 50, height: 10))
        greenPool.position = CGPoint(x: frame.midX + 100, y: frame.minY + 105)
        greenPool.name = "GreenPool"
        greenPool.alpha = 0.7
        greenPool.physicsBody = SKPhysicsBody(rectangleOf: greenPool.size)
        greenPool.physicsBody?.isDynamic = false
        greenPool.physicsBody?.categoryBitMask = Categoria.greenPool
        greenPool.physicsBody?.contactTestBitMask = Categoria.player1 | Categoria.player2
        greenPool.physicsBody?.collisionBitMask = Categoria.none
        addChild(greenPool)
    }
    
    func createLever() {
        lever = SKSpriteNode(color: .yellow, size: CGSize(width: 6, height: 27))
        lever.position = CGPoint(x: frame.midX - 100, y: frame.minY + 142)
        lever.name = "lever"
        
        lever.physicsBody = SKPhysicsBody(rectangleOf: lever.size)
        lever.physicsBody?.isDynamic = false // Para não se mover
        lever.physicsBody?.categoryBitMask = Categoria.lever
        lever.physicsBody?.contactTestBitMask = Categoria.player1 | Categoria.player2
        lever.physicsBody?.collisionBitMask = Categoria.player1 | Categoria.player2
        addChild(lever)
    }
    
    func createButton(){
        button1 = SKSpriteNode(color: .purple , size: CGSize(width: 20, height: 10))
        button1.position = CGPoint(x: frame.midX - 200, y: frame.midY + 10)
        button1.name = "button1"
        
        button1.physicsBody = SKPhysicsBody(rectangleOf: lever.size)
        button1.physicsBody?.isDynamic = false // Para não se mover
        button1.physicsBody?.categoryBitMask = Categoria.button1
        button1.physicsBody?.contactTestBitMask = Categoria.player1 | Categoria.player2
        button1.physicsBody?.collisionBitMask = Categoria.player1 | Categoria.player2
        addChild(button1)
        
        //button 2
        button2 = SKSpriteNode(color: .purple, size: CGSize(width: 20, height: 10))
        button2.position = CGPoint(x: frame.midX + 100, y: frame.midY + 60)
        button2.name = "button2"
        
        
        button2.physicsBody = SKPhysicsBody(rectangleOf: lever.size)
        button2.physicsBody?.isDynamic = false // Para não se mover
        button2.physicsBody?.categoryBitMask = Categoria.button2
        button2.physicsBody?.contactTestBitMask = Categoria.player1 | Categoria.player2
        button2.physicsBody?.collisionBitMask = Categoria.player1 | Categoria.player2
        addChild(button2)
        
    }
    
    func createPlatform() {
        platform1 = SKSpriteNode(color: .white, size: CGSize(width: 80, height: 10))
        platform1.position = CGPoint(x: frame.minX + 54, y: frame.midY + 10)
        platform1.name = "platform"
        
        platform1.physicsBody = SKPhysicsBody(rectangleOf: platform1.size)
        platform1.physicsBody?.isDynamic = false
        platform1.physicsBody?.categoryBitMask = Categoria.platform
        platform1.physicsBody?.contactTestBitMask = Categoria.player1 | Categoria.player2
        platform1.physicsBody?.collisionBitMask = Categoria.player1 | Categoria.player2
        addChild(platform1)
        
        //platform2
        platform2 = SKSpriteNode(color: .purple, size: CGSize(width: 60, height: 10))
        platform2.position = CGPoint(x: frame.maxX - 60, y: frame.midY + 58)
        platform2.name = "platform"
        
        platform2.physicsBody = SKPhysicsBody(rectangleOf: platform2.size)
        platform2.physicsBody?.isDynamic = false
        platform2.physicsBody?.categoryBitMask = Categoria.platform
        platform2.physicsBody?.contactTestBitMask = Categoria.player1 | Categoria.player2
        platform2.physicsBody?.collisionBitMask = Categoria.player1 | Categoria.player2
        addChild(platform2)
    }
    
    func createDoor() {
        // Door 1 (for player1)
        door1 = SKSpriteNode(color: .orange, size: CGSize(width: 20, height: 40))
        door1.position = CGPoint(x: frame.maxX - 50, y: frame.maxY - 70)
        door1.name = "door1"
        
        door1.physicsBody = SKPhysicsBody(rectangleOf: door1.size)
        door1.physicsBody?.isDynamic = false
        door1.physicsBody?.categoryBitMask = Categoria.door1
        door1.physicsBody?.contactTestBitMask = Categoria.player1
        door1.physicsBody?.collisionBitMask = Categoria.player1
        addChild(door1)
        
        // Door 2 (for player2)
        door2 = SKSpriteNode(color: .cyan, size: CGSize(width: 20, height: 40))
        door2.position = CGPoint(x: frame.maxX - 100, y: frame.maxY - 70)
        door2.name = "door2"
        
        door2.physicsBody = SKPhysicsBody(rectangleOf: door2.size)
        door2.physicsBody?.isDynamic = false
        door2.physicsBody?.categoryBitMask = Categoria.door2
        door2.physicsBody?.contactTestBitMask = Categoria.player2
        door2.physicsBody?.collisionBitMask = Categoria.player2
        addChild(door2)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
            let categoriaA = contact.bodyA.categoryBitMask
            let categoriaB = contact.bodyB.categoryBitMask
        
            
            // Player1 death conditions
            if (categoriaA == Categoria.player1 && categoriaB == Categoria.deathPool2) ||
               (categoriaB == Categoria.player1 && categoriaA == Categoria.deathPool2) ||
               (categoriaA == Categoria.player1 && categoriaB == Categoria.greenPool) ||
               (categoriaB == Categoria.player1 && categoriaA == Categoria.greenPool) {
                resetPlayer()
                
                print("AAAAAAA")
            }
            
            // Player2 death conditions
            if (categoriaA == Categoria.player2 && categoriaB == Categoria.deathPool1) ||
               (categoriaB == Categoria.player2 && categoriaA == Categoria.deathPool1) ||
               (categoriaA == Categoria.player2 && categoriaB == Categoria.greenPool) ||
               (categoriaB == Categoria.player2 && categoriaA == Categoria.greenPool) {
                resetPlayer()
            }
            
            // Lever and button interactions (same as before but check which player is interacting)
            if (categoriaA == Categoria.player1 && categoriaB == Categoria.lever) ||
               (categoriaB == Categoria.player1 && categoriaA == Categoria.lever) ||
                (categoriaA == Categoria.player2 && categoriaB == Categoria.lever) ||
                (categoriaB == Categoria.player2 && categoriaA == Categoria.lever) {
                let rotateAction = SKAction.rotate(byAngle: .pi / -4, duration: 0.2)
                lever.run(rotateAction)
                lever.physicsBody?.contactTestBitMask = Categoria.none

                let platformDown = SKAction.move(to: CGPoint(x: frame.minX + 54, y: frame.midY - 40), duration: 1)
                platform1.run(platformDown)
            }
            
            // Button interactions
            if (categoriaA == Categoria.player1 && categoriaB == Categoria.button1) ||
               (categoriaB == Categoria.player1 && categoriaA == Categoria.button1) ||
               (categoriaA == Categoria.player2 && categoriaB == Categoria.button1) ||
               (categoriaB == Categoria.player2 && categoriaA == Categoria.button1) {
                let movePlatform2 = SKAction.move(to: CGPoint(x: frame.maxX - 60, y: frame.midY + 10), duration: 1)
                platform2.run(movePlatform2)
                button1.run(scaleButton)
            }
            
            if (categoriaA == Categoria.player1 && categoriaB == Categoria.button2) ||
               (categoriaB == Categoria.player1 && categoriaA == Categoria.button2) ||
               (categoriaA == Categoria.player2 && categoriaB == Categoria.button2) ||
               (categoriaB == Categoria.player2 && categoriaA == Categoria.button2) {
                let movePlatform2 = SKAction.move(to: CGPoint(x: frame.maxX - 60, y: frame.midY + 10), duration: 1)
                platform2.run(movePlatform2)
                button2.run(scaleButton)
            }
        
        // Door contact checks
        if (categoriaA == Categoria.player1 && categoriaB == Categoria.door1) ||
               (categoriaB == Categoria.player1 && categoriaA == Categoria.door1) {
                checkWinCondition()
            }
            
            if (categoriaA == Categoria.player2 && categoriaB == Categoria.door2) ||
               (categoriaB == Categoria.player2 && categoriaA == Categoria.door2) {
                checkWinCondition()
            }
        }
    
    func checkWinCondition() {
        // Check if both players are at their respective doors
        var player1AtDoor = false
        var player2AtDoor = false
        
        player1.physicsBody?.allContactedBodies().forEach { body in
            if body.node?.physicsBody?.categoryBitMask == Categoria.door1 {
                player1AtDoor = true
            }
        }
        
        player2.physicsBody?.allContactedBodies().forEach { body in
            if body.node?.physicsBody?.categoryBitMask == Categoria.door2 {
                player2AtDoor = true
            }
        }
        
        if player1AtDoor && player2AtDoor {
            changeScene(won: true)
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let categoriaA = contact.bodyA.categoryBitMask
        let categoriaB = contact.bodyB.categoryBitMask
        
        // Check if either player left either button
        if (categoriaA == Categoria.button1 || categoriaA == Categoria.button2 ||
            categoriaB == Categoria.button1 || categoriaB == Categoria.button2) {
            
            // Check if any player is still touching any button
            var anyPlayerTouchingButton = false
            
            // Check player1's contacts
            player1.physicsBody?.allContactedBodies().forEach { body in
                if body.node?.physicsBody?.categoryBitMask == Categoria.button1 ||
                    body.node?.physicsBody?.categoryBitMask == Categoria.button2 {
                    anyPlayerTouchingButton = true
                }
            }
            
            // Check player2's contacts if player1 wasn't touching
            if !anyPlayerTouchingButton {
                player2.physicsBody?.allContactedBodies().forEach { body in
                    if body.node?.physicsBody?.categoryBitMask == Categoria.button1 ||
                        body.node?.physicsBody?.categoryBitMask == Categoria.button2 {
                        anyPlayerTouchingButton = true
                    }
                }
            }
            
            // If no players are touching any button, move platform back up
            if !anyPlayerTouchingButton {
                let movePlatform2 = SKAction.move(to: platform2InitialPosition, duration: 1)
                platform2.run(movePlatform2)
                
                // Also reset button scales
                button1.run(scaleButtonUp)
                button2.run(scaleButtonUp)
            }
        }
    }
    


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let location = touch.location(in: self)
                let node = atPoint(location)
                
                switch node.name {
                case "leftButton1":
                    moveLeft1 = true
                case "rightButton1":
                    moveRight1 = true
                case "jumpButton1":
                    if let velocityY = player1.physicsBody?.velocity.dy, abs(velocityY) < 1 {
                        player1.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 7))
                    }
                case "leftButton2":
                    moveLeft2 = true
                case "rightButton2":
                    moveRight2 = true
                case "jumpButton2":
                    if let velocityY = player2.physicsBody?.velocity.dy, abs(velocityY) < 1 {
                        player2.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 7))
                    }
                default:
                    break
                }
            }
        }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let location = touch.location(in: self)
                let node = atPoint(location)
                
                switch node.name {
                case "leftButton1":
                    moveLeft1 = false
                case "rightButton1":
                    moveRight1 = false
                case "leftButton2":
                    moveLeft2 = false
                case "rightButton2":
                    moveRight2 = false
                default:
                    break
                }
            }
        }

    func createControls() {
            let buttonSize = CGSize(width: 60, height: 60)
            let padding: CGFloat = 30
            
            // Player 1 controls (left side)
            leftButton1 = SKSpriteNode(color: .gray, size: buttonSize)
            leftButton1.position = CGPoint(x: frame.minX + padding + 30, y: frame.minY + padding)
            leftButton1.name = "leftButton1"
            leftButton1.alpha = 0.7
            addChild(leftButton1)
            
            rightButton1 = SKSpriteNode(color: .gray, size: buttonSize)
            rightButton1.position = CGPoint(x: frame.minX + padding + 110, y: frame.minY + padding)
            rightButton1.name = "rightButton1"
            rightButton1.alpha = 0.7
            addChild(rightButton1)
            
            jumpButton1 = SKSpriteNode(color: .gray, size: buttonSize)
            jumpButton1.position = CGPoint(x: frame.minX + padding + 30, y: frame.minY + padding + 70)
            jumpButton1.name = "jumpButton1"
            jumpButton1.alpha = 0.7
            addChild(jumpButton1)
            
            // Player 2 controls (right side)
            leftButton2 = SKSpriteNode(color: .gray, size: buttonSize)
            leftButton2.position = CGPoint(x: frame.maxX - padding - 110, y: frame.minY + padding)
            leftButton2.name = "leftButton2"
            leftButton2.alpha = 0.7
            addChild(leftButton2)
            
            rightButton2 = SKSpriteNode(color: .gray, size: buttonSize)
            rightButton2.position = CGPoint(x: frame.maxX - padding - 30, y: frame.minY + padding)
            rightButton2.name = "rightButton2"
            rightButton2.alpha = 0.7
            addChild(rightButton2)
            
            jumpButton2 = SKSpriteNode(color: .gray, size: buttonSize)
            jumpButton2.position = CGPoint(x: frame.maxX - padding - 30, y: frame.minY + padding + 70)
            jumpButton2.name = "jumpButton2"
            jumpButton2.alpha = 0.7
            addChild(jumpButton2)
        }
    
    func changeScene(won: Bool) {
            let reveal = SKTransition.flipVertical(withDuration: 0.5)
            let gameoverScene = GameOverScene(size: self.size, won: won)
            self.view?.presentScene(gameoverScene, transition: reveal)
        }
    
    func resetPlayer() {
        if let currentScene = self.scene,
                               let view = currentScene.view {
                                let novaCena = type(of: currentScene).init(size: currentScene.size)
                                novaCena.scaleMode = currentScene.scaleMode
                                view.presentScene(novaCena, transition: SKTransition.fade(withDuration: 0.5))
                            }
        }
    
    override func update(_ currentTime: TimeInterval) {
            // Player 1 movement
            if moveLeft1 {
                player1.physicsBody?.velocity.dx = -200
            } else if moveRight1 {
                player1.physicsBody?.velocity.dx = 200
            } else {
                player1.physicsBody?.velocity.dx = 0
            }
            
            // Player 2 movement
            if moveLeft2 {
                player2.physicsBody?.velocity.dx = -200
            } else if moveRight2 {
                player2.physicsBody?.velocity.dx = 200
            } else {
                player2.physicsBody?.velocity.dx = 0
            }
        }
    }

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return hypot(x - point.x, y - point.y)
    }
}
