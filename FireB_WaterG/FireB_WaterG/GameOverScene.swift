import SpriteKit

class GameOverScene: SKScene {
    
    init(size: CGSize, won: Bool) {
        super.init(size: size)
        
        backgroundColor = SKColor.black
        
        let message = won ? "Vitória!" : "Game Over"
        
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.white
        label.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(label)
        
        // Voltar ao menu ou reiniciar após 3 segundos
        run(SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.run {
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition: transition)
            }
        ]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


