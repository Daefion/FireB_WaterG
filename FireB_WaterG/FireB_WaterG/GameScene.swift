//
//  GameScene.swift
//  FireB_WaterG
//
//  Created by Aluno a25982 Teste on 09/05/2025.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var player: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        
        createPlayer()
        createMap()
    }
	
    func createPlayer() {
        player = SKSpriteNode(color: .white, size: CGSize(width: 20, height: 20))
        player.position = CGPoint(x: frame.minX + 100, y: frame.minY + 150)
        player.name = "player1"
        
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = true
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.restitution = 0
        player.physicsBody?.friction = 0.2
        
        addChild(player)
    }
		
    
    func createMap() {
        let staticBodies: [(SKSpriteNode, CGSize, CGPoint)] = [
            (SKSpriteNode(color: .green, size: CGSize(width: frame.width, height: 10)), CGSize(width: frame.width, height: 10), CGPoint(x: frame.midX, y: frame.minY + 20)), // chão
            (SKSpriteNode(color: .green, size: CGSize(width: 20, height: frame.height)), CGSize(width: 20, height: frame.height), CGPoint(x: frame.minX, y: frame.midY)), // parede esq
            (SKSpriteNode(color: .green, size: CGSize(width: 20, height: frame.height)), CGSize(width: 20, height: frame.height), CGPoint(x: frame.maxX, y: frame.midY)), // parede dir
            (SKSpriteNode(color: .green, size: CGSize(width: frame.width, height: 10)), CGSize(width: frame.width, height: 10), CGPoint(x: frame.midX, y: frame.maxY - 20)), // teto
            (SKSpriteNode(color: .green, size: CGSize(width: 400, height: 5)), CGSize(width: 400, height: 5), CGPoint(x: frame.minX, y: frame.minY + 75)),
            (SKSpriteNode(color: .green, size: CGSize(width: 800, height: 5)), CGSize(width: 800, height: 5), CGPoint(x: frame.minX, y: frame.minY + 130)),
            (SKSpriteNode(color: .green, size: CGSize(width: 300, height: 5)), CGSize(width: 300, height: 5), CGPoint(x: frame.minX + 550, y: frame.minY + 100)),
            (SKSpriteNode(color: .green, size: CGSize(width: 100, height: 100)), CGSize(width: 100, height: 100), CGPoint(x: frame.maxX - 30, y: frame.minY + 30)),
            (SKSpriteNode(color: .green, size: CGSize(width: 850, height: 5)), CGSize(width: 850, height: 50), CGPoint(x: frame.midX + 100, y: frame.minY + 200)),
        ]

        for (node, size, position) in staticBodies {
            node.position = position
            node.physicsBody = SKPhysicsBody(rectangleOf: size)
            node.physicsBody?.isDynamic = false // estático, não se move
            addChild(node)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let isTop = location.y > frame.midY + 100
        let isRight = location.x > frame.midX
        let isLeft = location.x < frame.midX

        if isTop {
            // Salta apenas se a velocidade vertical for quase 0 (para evitar saltos múltiplos)
            if let velocityY = player.physicsBody?.velocity.dy, abs(velocityY) < 1 {
                player.physicsBody?.applyImpulse(CGVector(dx: 0, dy:10))
            }
        } else if isRight {
            player.physicsBody?.velocity.dx = 150
        } else if isLeft {
            player.physicsBody?.velocity.dx = -150
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Parar movimento ao soltar toque
        //player.physicsBody?.velocity.dx = 0
        player.physicsBody?.velocity.dy = 0
    }

}

