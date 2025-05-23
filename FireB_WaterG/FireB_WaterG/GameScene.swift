import SpriteKit
import GameplayKit

struct Categoria {
    static let none : UInt32 = 0
    static let all : UInt32 = UInt32.max
    static let player : UInt32 = 0b1        // 1
    static let deathPool : UInt32 = 0b10   // 2
    static let ground : UInt32 = 0b100      // 4 (para chão e paredes)
    static let lever : UInt32 = 0b1000      // 8 (alavanca)
    static let platform : UInt32 = 0b10000
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode!
    var initialPlayerPosition = CGPoint.zero
    
    var leftButton: SKSpriteNode!
    var rightButton: SKSpriteNode!
    var jumpButton: SKSpriteNode!
    
    var lever: SKSpriteNode!
    
    var platform : SKSpriteNode!
    
    var moveLeft = false
    var moveRight = false
    
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
        
        createPlayer()
        createMap()
        createDeathPools()
        createControls()
        createLever()
        createPlatform()
    }
    
    func createPlayer() {
        player = SKSpriteNode(color: .white, size: CGSize(width: 20, height: 20))
        initialPlayerPosition = CGPoint(x: frame.minX + 20, y: frame.minY + 40)
        player.position = initialPlayerPosition
        player.name = "player1"
        
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = true
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.restitution = 0
        player.physicsBody?.friction = 0.2
        
        player.physicsBody?.categoryBitMask = Categoria.player
        player.physicsBody?.contactTestBitMask = Categoria.deathPool | Categoria.ground
        player.physicsBody?.collisionBitMask = Categoria.ground | Categoria.lever
        
        addChild(player)
    }
    
    func createMap() {
        let staticBodies: [(SKSpriteNode, CGSize, CGPoint)] = [
            (SKSpriteNode(color: .green, size: CGSize(width: frame.width, height: 10)), CGSize(width: frame.width, height: 10), CGPoint(x: frame.midX, y: frame.minY + 20)),
            (SKSpriteNode(color: .green, size: CGSize(width: 20, height: frame.height)), CGSize(width: 20, height: frame.height), CGPoint(x: frame.minX, y: frame.midY)),
            (SKSpriteNode(color: .green, size: CGSize(width: 20, height: frame.height)), CGSize(width: 20, height: frame.height), CGPoint(x: frame.maxX, y: frame.midY)),
            (SKSpriteNode(color: .green, size: CGSize(width: frame.width, height: 10)), CGSize(width: frame.width, height: 10), CGPoint(x: frame.midX, y: frame.maxY - 20)),
            (SKSpriteNode(color: .green, size: CGSize(width: 400, height: 5)), CGSize(width: 400, height: 5), CGPoint(x: frame.minX, y: frame.minY + 75)),
            (SKSpriteNode(color: .green, size: CGSize(width: 800, height: 5)), CGSize(width: 800, height: 5), CGPoint(x: frame.minX, y: frame.minY + 130)),
            (SKSpriteNode(color: .green, size: CGSize(width: 300, height: 5)), CGSize(width: 300, height: 5), CGPoint(x: frame.minX + 550, y: frame.minY + 100)),
            (SKSpriteNode(color: .green, size: CGSize(width: 100, height: 100)), CGSize(width: 100, height: 100), CGPoint(x: frame.maxX - 30, y: frame.minY + 30)),
            (SKSpriteNode(color: .green, size: CGSize(width: 750, height: 5)), CGSize(width: 750, height: 5), CGPoint(x: frame.midX + 50, y: frame.minY + 200)),
            (SKSpriteNode(color: .green, size: CGSize(width: 750, height: 5)), CGSize(width: 750, height: 5), CGPoint(x: frame.midX - 50, y: frame.minY + 250)),
            (SKSpriteNode(color: .green, size: CGSize(width: 100, height: 50)), CGSize(width: 100, height: 50), CGPoint(x: frame.minX, y: frame.minY + 270)),
            (SKSpriteNode(color: .green, size: CGSize(width: 750, height: 5)), CGSize(width: 750, height: 5), CGPoint(x: frame.midX + 40, y: frame.minY + 300)),
        ]
        
        for (node, size, position) in staticBodies {
            node.position = position
            node.physicsBody = SKPhysicsBody(rectangleOf: size)
            node.physicsBody?.isDynamic = false
            node.physicsBody?.categoryBitMask = Categoria.ground
            node.physicsBody?.contactTestBitMask = Categoria.none
            node.physicsBody?.collisionBitMask = Categoria.player
            addChild(node)
        }
    }
    
    func createDeathPools() {
        let pool1 = SKSpriteNode(color: .red, size: CGSize(width: 100, height: 10))
        pool1.position = CGPoint(x: frame.midX + 200, y: frame.minY + 25)
        pool1.name = "deathPool"
        pool1.alpha = 0.7
        pool1.physicsBody = SKPhysicsBody(rectangleOf: pool1.size)
        pool1.physicsBody?.isDynamic = false
        pool1.physicsBody?.categoryBitMask = Categoria.deathPool
        pool1.physicsBody?.contactTestBitMask = Categoria.player
        pool1.physicsBody?.collisionBitMask = Categoria.none
        addChild(pool1)
        
        let pool2 = SKSpriteNode(color: .blue, size: CGSize(width: 100, height: 10))
        pool2.position = CGPoint(x: frame.midX , y: frame.minY + 25)
        pool2.name = "deathPool"
        pool2.alpha = 0.7
        pool2.physicsBody = SKPhysicsBody(rectangleOf: pool2.size)
        pool2.physicsBody?.isDynamic = false
        pool2.physicsBody?.categoryBitMask = Categoria.deathPool
        pool2.physicsBody?.contactTestBitMask = Categoria.player
        pool2.physicsBody?.collisionBitMask = Categoria.none
        addChild(pool2)
    }
    
    func createLever() {
        lever = SKSpriteNode(color: .yellow, size: CGSize(width: 6, height: 30))
        lever.position = CGPoint(x: frame.midX - 100, y: frame.minY + 35)
        lever.name = "lever"
        
        
        lever.physicsBody = SKPhysicsBody(rectangleOf: lever.size)
        lever.physicsBody?.isDynamic = false // Para não se mover
        lever.physicsBody?.categoryBitMask = Categoria.lever
        lever.physicsBody?.contactTestBitMask = Categoria.player
        lever.physicsBody?.collisionBitMask = Categoria.player
        addChild(lever)
    }
    
    func createPlatform() {
        let platform1 = SKSpriteNode(color: .white, size: CGSize(width: 80, height: 10))
        platform1.position = CGPoint(x: frame.minX + 54, y: frame.midY + 10)
        platform1.name = "platform"
        platform1.physicsBody = SKPhysicsBody(rectangleOf: platform1.size)
        platform1.physicsBody?.isDynamic = false
        platform1.physicsBody?.categoryBitMask = Categoria.platform
        platform1.physicsBody?.contactTestBitMask = Categoria.player
        platform1.physicsBody?.collisionBitMask = Categoria.player
        addChild(platform1)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let categoriaA = contact.bodyA.categoryBitMask
        let categoriaB = contact.bodyB.categoryBitMask
        

        if (categoriaA == Categoria.player && categoriaB == Categoria.deathPool) ||
           (categoriaB == Categoria.player && categoriaA == Categoria.deathPool) {
            if let currentScene = self.scene,
               let view = currentScene.view {
                let novaCena = type(of: currentScene).init(size: currentScene.size)
                novaCena.scaleMode = currentScene.scaleMode
                view.presentScene(novaCena, transition: SKTransition.fade(withDuration: 0.5))
            }
        }
        if (categoriaA == Categoria.player && categoriaB == Categoria.lever){
            let rotateAction = SKAction.rotate(byAngle: .pi / -4, duration: 0.2)
                    lever.run(rotateAction)
            lever.physicsBody?.contactTestBitMask = Categoria.none

            
        }
        
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node = atPoint(location)
            
            switch node.name {
            case "leftButton":
                moveLeft = true
            case "rightButton":
                moveRight = true
            case "jumpButton":
                if let velocityY = player.physicsBody?.velocity.dy, abs(velocityY) < 1 {
                    player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 8))
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
            case "leftButton":
                moveLeft = false
            case "rightButton":
                moveRight = false
            default:
                break
            }
        }
    }

    func createControls() {
        let buttonSize = CGSize(width: 60, height: 60)
        let padding: CGFloat = 30
        
        leftButton = SKSpriteNode(color: .gray, size: buttonSize)
        leftButton.position = CGPoint(x: frame.minX + padding + 30, y: frame.minY + padding)
        leftButton.name = "leftButton"
        addChild(leftButton)
        
        rightButton = SKSpriteNode(color: .gray, size: buttonSize)
        rightButton.position = CGPoint(x: frame.minX + padding + 110, y: frame.minY + padding)
        rightButton.name = "rightButton"
        addChild(rightButton)
        
        jumpButton = SKSpriteNode(color: .gray, size: buttonSize)
        jumpButton.position = CGPoint(x: frame.maxX - padding - 30, y: frame.minY + padding)
        jumpButton.name = "jumpButton"
        addChild(jumpButton)
        
        leftButton.alpha = 0.7
        rightButton.alpha = 0.7
        jumpButton.alpha = 0.7
    }
    
    override func update(_ currentTime: TimeInterval) {
        if moveLeft {
            player.physicsBody?.velocity.dx = -175
        } else if moveRight {
            player.physicsBody?.velocity.dx = 175
        } else {
            player.physicsBody?.velocity.dx = 0
        }
        
    }
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return hypot(x - point.x, y - point.y)
    }
}
