//
//  ScoreBoard.swift
//  MathShooter29
//
//  Created by วรัญพงษ์ สุทธิพนไพศาล on 22/1/2567 BE.
//

import SwiftUI
import SpriteKit

class ScoreBoardScene: SKScene {
    var score: Int = 0
    let scores = loadScore()
    let background = SKSpriteNode(imageNamed: "image002")
    var delay : Float = 0.0
    
    override func didMove(to view: SKView) {
        var height = UIScreen.main.bounds.height
        scene?.size = CGSize(width: 750, height: 1335)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.setScale(1.3)
        background.zPosition = -1
        background.alpha = 0.6
        addChild(background)
        
        let gameOverLabel = SKLabelNode(text: "Game Over")
        gameOverLabel.fontName = "Chalkduster"
        gameOverLabel.fontSize = 80
        gameOverLabel.zPosition = 1
        gameOverLabel.fontColor = SKColor.red
        gameOverLabel.position = CGPoint(x: size.width/2, y: size.height/1.18)
        addChild(gameOverLabel)
        
        var scoreIsOnTheBoard = false
        
        //scores.indices
        for index in scores.indices {
            let rank = "Rank \(index + 1) : \(scores[index])"
            let ScoreNode: SKLabelNode = SKLabelNode(fontNamed: "Chalkduster")
            delay += 0.15
            ScoreNode.text = rank
            ScoreNode.zPosition = 1
            ScoreNode.fontColor = .white
            ScoreNode.alpha = 10
            ScoreNode.fontSize = 50
            
            
            let scoreNodeSize = ScoreNode.frame.size
            let textBox = SKShapeNode(rectOf: CGSize(width: max(200, scoreNodeSize.width + 40), height: 80), cornerRadius: 20)
            textBox.fillColor = index % 2 == 0 ? .cyan : .blue
            textBox.position = CGPoint(x: self.size.width * 1.5, y: height)
            //textBox.position = CGPoint(x: 2*size.width, y: height )
            textBox.alpha = 0.2
            if scores[index] == score {
                textBox.fillColor = .green
                scoreIsOnTheBoard = true
            }
            ScoreNode.position = CGPoint(x: 0, y: -scoreNodeSize.height / 2)
            textBox.addChild(ScoreNode)
            
            addChild(textBox)
            let moveAction = SKAction.move(to: CGPoint(x: size.width/2, y: height), duration: TimeInterval(0.5 + delay))
            textBox.run(moveAction)
            height -= 100
        }
        delay = 0
        let CurrentlyScore: SKLabelNode = SKLabelNode(fontNamed: "Chalkduster")
        CurrentlyScore.text = "Your score: \(score)"
        CurrentlyScore.position = CGPoint(x: size.width/2, y: size.height/1.38)
        CurrentlyScore.fontColor = .green
        CurrentlyScore.fontSize = 70
        addChild(CurrentlyScore)
        
        if !scoreIsOnTheBoard {
            let notOnBoardLabel = SKLabelNode(fontNamed: "Chalkduster")
            notOnBoardLabel.text = "Your score is not on the rank"
            notOnBoardLabel.fontSize = 30
            notOnBoardLabel.fontColor = .red
            notOnBoardLabel.position = CGPoint(x: size.width/2, y: size.height/1.28)
            addChild(notOnBoardLabel)
        }
    }
}

struct ScoreBoard: View {
    //@ObservedObject var scene = Game_Scene(size: .zero, viewModel: GameViewModelUpdatable.self as! GameViewModelUpdatable)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    var body: some View {
        GeometryReader{ sizeIn in
            ZStack(alignment: .center){
                if horizontalSizeClass == .regular && verticalSizeClass == .regular{
                    SpriteView(scene: ScoreBoardScene())
                        .ignoresSafeArea(.all)
                        .frame(width: 750, height: 1335)
                } else {
                    SpriteView(scene: ScoreBoardScene())
                        .ignoresSafeArea(.all)
                }
                
            }
            
        }
    }
}

#Preview {
    ScoreBoard()
        .environmentObject(gameData())
}
