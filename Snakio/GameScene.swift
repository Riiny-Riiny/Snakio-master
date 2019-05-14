//
//  GameScene.swift
//  Snakio
//
//  Created by Riiny Giir on 4/8/19.
//  Copyright © 2019 Riiny Giir. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    //1
    var gameLogo: SKLabelNode!
    var bestScore: SKLabelNode!
    var playButton: SKShapeNode!
    var game: GameManager!
    
    //1
    var currentScore: SKLabelNode!
    
    var playerPositions: [(Int,Int)] = []
    var gameBG: SKShapeNode!
    var gameArray: [(node: SKShapeNode, x: Int, y: Int)] = []
    var scorePos: CGPoint?
    
    
    override func didMove(to view: SKView) {
        //2
        initializeMenu()
        game = GameManager(scene: self)
        //2
        initializeGameView()
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeR))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeL))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeUp: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeU))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeD))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
       
        
        
        }
   
    
    @objc func swipeR() {
        game.swipe(ID: 3)
    }
    
    @objc func swipeL() {
       game.swipe(ID: 1)
    }
    
    @objc func swipeU() {
        game.swipe(ID: 2)
    }
    
    @objc func swipeD() {
      game.swipe(ID: 4)
    }
    
   
    private func initializeGameView() {
        currentScore = SKLabelNode(fontNamed: "AerialRoundedMTBold")
         currentScore.zPosition = 1
        currentScore.position = CGPoint (x: 0 , y: (frame.size.height / -2) + 60)
         currentScore.fontSize = 40
         currentScore.isHidden = true
        currentScore.text = "Score: 0"
         currentScore.fontColor = SKColor.yellow
        self.addChild(currentScore)
        //5
        let width = frame.size.width - 220
        let height = width * 2
        let rect = CGRect( x: -width / 2, y: -height / 2, width: width, height: height)
        gameBG = SKShapeNode(rect: rect, cornerRadius: 0.02)
        gameBG.fillColor = SKColor.magenta
        gameBG.zPosition = 2
        gameBG.isHidden = true
        self.addChild(gameBG)
        //6
        createGameBoard(width: Int(width) , height: Int(height))
        
    }
    
    
    private func createGameBoard(width: Int,  height: Int){
       
        let numCols = 20
        let numRows = numCols * 2
        let cellWidth: CGFloat = CGFloat(width) / CGFloat(numCols)
        var x = CGFloat(width / -2) + (cellWidth / 2)
        var y = CGFloat(height / 2) - (cellWidth / 2)
        //loop through rows and columns, create cells
        
        
        
        for i in 0...numRows - 1 {
            for j in 0...numCols - 1 {
            let cellNode = SKShapeNode(rectOf: CGSize(width: cellWidth, height: cellWidth))
                cellNode.strokeColor = SKColor.black
                cellNode.zPosition = 2
                cellNode.position = CGPoint(x: x, y: y)
                gameArray.append((node: cellNode, x: i, y: j))
                gameBG.addChild(cellNode)
                x += cellWidth
         }
            x = CGFloat(width / -2) + (cellWidth / 2)
            y -= cellWidth
        }
    }
    private func startGame() {
        print("start game")
        //1
        gameLogo.run(SKAction.move(by: CGVector(dx: -50, dy: 600), duration: 0.5)) {
            self.gameLogo.isHidden = true
        }
        //2
        playButton.run(SKAction.scale(to: 0, duration: 0.3)) {
            self.playButton.isHidden = true
        }
        //3
        let bottomCorner = CGPoint(x: 0, y: (frame.size.height / -2) + 20 )
        bestScore.run(SKAction.move(to: bottomCorner, duration: 0.4)) {
            self.gameBG.setScale(0)
            self.currentScore.setScale(0)
            self.gameBG.isHidden = false
            self.currentScore.isHidden = false
            self.gameBG.run(SKAction.scale(to: 1, duration: 0.4))
            self.currentScore.run(SKAction.scale(to: 1, duration: 0.4))
            //new code
            self.game.initGame()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        //called before each frame is rendered
        //1
        game.update(time: currentTime)
    }
    //3
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if node.name == "play_button" {
                    startGame()
                }
            }
            
        }
    }
    private func initializeMenu() {
        //4
        
        gameLogo  = SKLabelNode( fontNamed: "ArialRoundedMTBold")
        gameLogo.zPosition = 1
        gameLogo.position = CGPoint(x: 0, y: (frame.size.height/2) - 200)
        gameLogo.fontSize = 60
        gameLogo.text = "sNaKiO"
       
        gameLogo.fontColor = SKColor.blue
        self.addChild(gameLogo)
        //5
        bestScore  = SKLabelNode( fontNamed: "ArialRoundedMTBold")
         bestScore.zPosition = 1
         bestScore.position = CGPoint(x: 0, y: gameLogo.position.y - 50)
         bestScore.fontSize = 40
        bestScore.text = "Best Score: \(UserDefaults.standard.integer(forKey: "bestScore"))"
        bestScore.text = "Final Score: 0"
        bestScore.fontColor = SKColor.white
        self.addChild(bestScore)
       
        //6
        playButton = SKShapeNode()
        playButton.name = "play_button"
        playButton.zPosition = 1
        playButton.position = CGPoint(x: 0, y: (frame.size.height / -2) + 200)
        playButton.fillColor = SKColor.cyan
        //7
        let topCorner = CGPoint(x: -50, y: 50)
        let bottomCorner = CGPoint(x: -50, y: -50)
        let middle = CGPoint(x: 50, y: 0)
        let path = CGMutablePath()
        path.addLine(to: topCorner)
        path.addLines(between: [topCorner, bottomCorner, middle])
        //8
        playButton.path = path
        self.addChild(playButton)
    }
}
