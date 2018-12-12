// Created on: Dec 2018
// Created by: Amin Zeina
// Created for: ICS3U
// This program has game over scene

// this will be commented out when code moved to Xcode
import PlaygroundSupport


import SpriteKit

class SplashScene: SKScene, SKPhysicsContactDelegate {
    // local variables to this scene
    let background = SKSpriteNode(imageNamed: "splashSceneImage.png")
    let moveToNextSceneDelay = SKAction.wait(forDuration: 2.0)
    
    override func didMove(to view: SKView) {
        // this is run when the scene loads
        
        /* Setup your scene here */
        self.backgroundColor = SKColor(red: 0.5, green:0, blue:0, alpha: 1.0)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.name = "Background"
        self.addChild(background)
        background.setScale(1)
        
        background.run(moveToNextSceneDelay){
            let mainMenuScene = MainMenuScene(size: self.size)
            self.view!.presentScene(mainMenuScene)
        }
            
    }
    
    override func  update(_ currentTime: TimeInterval) {
        //
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
        
    }
}

class MainMenuScene: SKScene, SKPhysicsContactDelegate {
    // local variables to this scene
    let startButton = SKSpriteNode(imageNamed: "IMG_2181.PNG")
    
    override func didMove(to view: SKView) {
        // this is run when the scene loads
        
        /* Setup your scene here */
        self.backgroundColor = SKColor(red: 0.15, green:0.15, blue:0.3, alpha: 1.0)
        startButton.position = CGPoint(x: frame.midX, y: 150)
        startButton.name = "start button"
        self.addChild(startButton)
        startButton.setScale(0.65)
    }
    
    override func  update(_ currentTime: TimeInterval) {
        //
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var touch = touches as! Set<UITouch>
        var location = touch.first!.location(in: self)
        var nodeTouched = self.atPoint(location)
        
        if let nodeTouchedName = nodeTouched.name{
            if nodeTouchedName == "start button" {
                let gameScene = GameScene(size: self.size)
                self.view!.presentScene(gameScene)
            }
        }
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
        
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    // local variables to this scene
    let moveToNextSceneDelay = SKAction.wait(forDuration: 2.0)
    let ship = SKSpriteNode(imageNamed: "spaceShip.png")
    let rightButton = SKSpriteNode(imageNamed: "rightButton.png")
    let leftButton = SKSpriteNode(imageNamed: "leftButton.png")
    let shootButton = SKSpriteNode(imageNamed: "redButton.png")
    let scoreLabel = SKLabelNode(fontNamed: "chalkduster")
    let highscoreLabel = SKLabelNode(fontNamed: "chalkduster")
    
    var score : Int = 0
    var highscore : Int = 0
    
    var missiles = [SKSpriteNode]()
    var aliens = [SKSpriteNode]()
    var alienAttackSpeedRate : Int = 1
    
    // for collision detection
    let collisionMissileCategory: UInt32    = 1
    let collisionAlienCategory: UInt32     = 2
    let collisionShipCategory: UInt32     = 4
    
    var rightButtonClicked = false
    var leftButtonClicked = false
    
    override func didMove(to view: SKView) {
        // this is run when the scene loads
        
        self.physicsWorld.contactDelegate = self
        
        highscore = UserDefaults.standard.integer(forKey: "highscore")
        /* Setup your scene here */
        self.backgroundColor = SKColor(red: 1, green:0.15, blue:0.3, alpha: 1.0)
        
        scoreLabel.text = "score: " + String(score)
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.fontColor = #colorLiteral(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        scoreLabel.fontSize = 50
        scoreLabel.position = CGPoint(x: 25, y: frame.size.height - 50)
        self.addChild(scoreLabel)
        scoreLabel.zPosition = 1.0
        
        highscoreLabel.text = "Highscore: " + String(highscore)
        highscoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        highscoreLabel.fontColor = #colorLiteral(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        highscoreLabel.fontSize = 50
        highscoreLabel.position = CGPoint(x: frame.width - 25 , y: frame.height - 50)
        self.addChild(highscoreLabel)
        highscoreLabel.zPosition = 1.5
        
        ship.position = CGPoint(x: screenSize.width / 2, y: 100)
        ship.name = "space ship"
        ship.physicsBody?.isDynamic = true
        ship.physicsBody = SKPhysicsBody(texture: ship.texture!, size: ship.size)
        ship.physicsBody?.affectedByGravity = false
        ship.physicsBody?.usesPreciseCollisionDetection = true
        ship.physicsBody?.categoryBitMask = collisionShipCategory
        ship.physicsBody?.collisionBitMask = 0x0
        self.addChild(ship)
        ship.setScale(0.65)
        ship.zPosition = 2.0
        
        rightButton.position = CGPoint(x: 300, y: 100)
        rightButton.name = "right button"
        self.addChild(rightButton)
        rightButton.setScale(0.7)
        rightButton.alpha = 0.5
        rightButton.zPosition = 3.0
        
        leftButton.position = CGPoint(x: 100, y: 100)
        leftButton.name = "left button"
        self.addChild(leftButton)
        leftButton.setScale(0.7)
        leftButton.alpha = 0.5
        leftButton.zPosition = 4.0
        
        shootButton.position = CGPoint(x: frame.size.width - 75, y: 100)
        shootButton.name = "shoot button"
        self.addChild(shootButton)
        shootButton.setScale(0.7)
        shootButton.alpha = 0.5
        shootButton.zPosition = 5.0
        
    }
    
    override func  update(_ currentTime: TimeInterval) {
        
        // move ship if buttons are clicked 
        if rightButtonClicked == true && ship.position.x <= screenSize.width - 150 {
            var moveShipRight = SKAction.moveBy(x: 10, y: 0, duration: 0.1)
            ship.run(moveShipRight)
        } else if leftButtonClicked == true && ship.position.x >= 50 {
            var moveShipLeft = SKAction.moveBy(x: -10, y: 0, duration: 0.1)
            ship.run(moveShipLeft)
        } 
        
        // create ship at random spot
        let spawnAlienChance = Int(arc4random_uniform(100) + 1)
        if spawnAlienChance <= alienAttackSpeedRate {
            spawnAlien()
        }
        
        // remove off screen missiles
        for aSingleMissile in missiles {
            if aSingleMissile.position.y > frame.size.height {
                aSingleMissile.removeFromParent()
                missiles.removeFirst()
            }
        }
        
        // remove off screen aliens
        for aSingleAlien in aliens {
            if aSingleAlien.position.y < ship.position.y - 100 {
                aSingleAlien.removeFromParent()
                aliens.removeFirst()
                
                // update score
                if score <= 2 {
                    score = 0
                } else {
                    score -= 2
                }
                scoreLabel.text = "Score: " + String(score)
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // check if contact occured
        let secondNode = contact.bodyB.node as! SKSpriteNode
        
        if ((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (collisionAlienCategory | collisionMissileCategory)) {
            
            // show explosion
            var emitterNode = SKEmitterNode(fileNamed: "Spark.sks")
            emitterNode?.particlePosition = (contact.bodyA.node?.position)!
            self.addChild(emitterNode!)
            self.run(SKAction.wait(forDuration: 2),completion: {emitterNode?.removeFromParent()})
            
            // remove missile and alien
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            ship.run(SKAction.playSoundFileNamed("BarrelExploding.wav", waitForCompletion: false))
            
            // update score
            score += 2
            
            if score > highscore {
                highscore = score
                highscoreLabel.text = "highscore: " + String(highscore)
                UserDefaults().set(highscore, forKey: "highscore")
            }
            scoreLabel.text = "Score: " + String(score)
        }
        
        if ((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (collisionAlienCategory | collisionShipCategory)) {
            // check if alien touches ship
            
            // show explosion
            var emitterNode = SKEmitterNode(fileNamed: "Spark.sks")
            emitterNode?.particlePosition = (contact.bodyA.node?.position)!
            self.addChild(emitterNode!)
            self.run(SKAction.wait(forDuration: 2),completion: {emitterNode?.removeFromParent()})
                
            // remove ship and alien
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent() 
            
            // switch scenes
            shootButton.run(moveToNextSceneDelay){
                let gameOverScene = GameOverScene(size: self.size)
                self.view!.presentScene(gameOverScene)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // check if buttons are clicked
        var touch = touches as! Set<UITouch>
        var location = touch.first!.location(in: self)
        var nodeTouched = self.atPoint(location)
        
        if let nodeTouchedName = nodeTouched.name{
            if nodeTouchedName == "right button" {
                rightButtonClicked = true 
            } else if nodeTouchedName == "left button" {
                leftButtonClicked = true
            } else if nodeTouchedName == "shoot button" {
                
                // shoot missile
                let aMissile = SKSpriteNode(imageNamed: "missile.png")
                aMissile.position = CGPoint(x: ship.position.x, y: 100)
                aMissile.zPosition = 6.0
                aMissile.name = "single missile"
                aMissile.physicsBody?.isDynamic = true
                aMissile.physicsBody = SKPhysicsBody(texture: aMissile.texture!, size: aMissile.size)
                aMissile.physicsBody?.affectedByGravity = false
                aMissile.physicsBody?.usesPreciseCollisionDetection = true
                aMissile.physicsBody?.categoryBitMask = collisionMissileCategory
                aMissile.physicsBody?.contactTestBitMask = collisionAlienCategory
                aMissile.physicsBody?.collisionBitMask = 0x0
                self.addChild(aMissile)
                aMissile.setScale(1)
                let shootMissile = SKAction.moveTo(y: frame.size.height + 75, duration: 1)
                aMissile.run(shootMissile)
                missiles.append(aMissile)
                
                //make sound
                aMissile.run(SKAction.playSoundFileNamed("laser1.wav", waitForCompletion: false))
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // check if buttons stopped being pressed
        var touch = touches as! Set<UITouch>
        var location = touch.first!.location(in: self)
        var nodeTouched = self.atPoint(location)
        
        if let nodeTouchedName = nodeTouched.name{
            if nodeTouchedName == "right button" {
                rightButtonClicked = false 
            } else if nodeTouchedName == "left button" {
                leftButtonClicked = false
            }
        }
    }
    
    func spawnAlien() {
        let aSingleAlien = SKSpriteNode(imageNamed: "alien.png")
        let alienStartPostitionX = Int(arc4random_uniform(UInt32(screenSize.width)))
        let alienEndPostitionX = Int(arc4random_uniform(UInt32(screenSize.width)))
        aSingleAlien.position = CGPoint(x: alienStartPostitionX, y: Int(screenSize.height) + 100)
        aSingleAlien.zPosition = 7.0
        let alienMove = SKAction.move(to: CGPoint(x: alienEndPostitionX, y: -100), duration: TimeInterval(4 - (alienAttackSpeedRate / 4)))
        aSingleAlien.run(alienMove)
        aSingleAlien.physicsBody?.isDynamic = true
        aSingleAlien.physicsBody = SKPhysicsBody(texture: aSingleAlien.texture!, size: aSingleAlien.size)
        aSingleAlien.physicsBody?.affectedByGravity = false
        aSingleAlien.physicsBody?.usesPreciseCollisionDetection = true
        aSingleAlien.physicsBody?.categoryBitMask = collisionAlienCategory
        aSingleAlien.physicsBody?.contactTestBitMask = collisionMissileCategory | collisionShipCategory
        aSingleAlien.physicsBody?.collisionBitMask = 0x0
        self.addChild(aSingleAlien)
        aliens.append(aSingleAlien)
    }
}

class GameOverScene: SKScene, SKPhysicsContactDelegate {
    // local variables to this scene
    let moveToNextSceneDelay = SKAction.wait(forDuration: 2.0)
    let gameOverText = SKLabelNode(fontNamed: "chalkduster")
    let menuButton = SKSpriteNode(imageNamed: "Copy of menu_button.png")
    
    override func didMove(to view: SKView) {
        // this is run when the scene loads
        
        /* Setup your scene here */
        self.backgroundColor = SKColor(red: 0, green:0, blue:0, alpha: 1.0)
        menuButton.position = CGPoint(x: frame.midX, y: 150)
        menuButton.name = "menu button"
        self.addChild(menuButton)
        menuButton.setScale(0.65)
        
        gameOverText.text = "Game Over"
        gameOverText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        gameOverText.fontColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        gameOverText.fontSize = 50
        gameOverText.position = CGPoint(x: frame.midX - 150, y: 300)
        self.addChild(gameOverText)
        gameOverText.zPosition = 1.0
    }
    
    override func  update(_ currentTime: TimeInterval) {
        //
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // check if menu button was touched
        var touch = touches as! Set<UITouch>
        var location = touch.first!.location(in: self)
        var nodeTouched = self.atPoint(location)
        
        if let nodeTouchedName = nodeTouched.name{
            if nodeTouchedName == "menu button" {
                let mainMenuScene = MainMenuScene(size: self.size)
                self.view!.presentScene(mainMenuScene)
            }
        } 
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
        
    }
}

// this will be commented out when code moved to Xcode

// set the frame to be the size for your iPad
let screenSize = UIScreen.main.bounds
let screenWidth = screenSize.width
let screenHeight = screenSize.height
let frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)

let scene = SplashScene(size: frame.size)
scene.scaleMode = SKSceneScaleMode.resizeFill

let skView = SKView(frame: frame)
skView.showsFPS = true
skView.showsNodeCount = true
skView.presentScene(scene)

PlaygroundPage.current.liveView = skView

