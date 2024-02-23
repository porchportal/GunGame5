//
//  Boss3Show.swift
//  MathShooter29
//
//  Created by วรัญพงษ์ สุทธิพนไพศาล on 8/2/2567 BE.
//

import SwiftUI
import SpriteKit

class boss3ShowSimulation: SKScene {
    var Bossy3_ = SKSpriteNode()
    var Boss3Fire_ = SKSpriteNode()
    override func didMove(to view: SKView) {
        scene?.size = CGSize(width: 750, height: 1335)
        
        let backgroundImage = SKSpriteNode(imageNamed: "image003")
        backgroundImage.position = CGPoint(x: size.width/2, y: size.height/2)
        backgroundImage.zPosition = -1
        backgroundImage.alpha = 0.6
        backgroundImage.setScale(1.3)
        addChild(backgroundImage)
        
        makebossTwo_()
    }
    func makebossTwo_(){
        //BossTwoActive = true
        Bossy3_ = SKSpriteNode(imageNamed: "Boss")
        //BossyTwo_.name = "Boss3"
        Bossy3_.zPosition = 15
        Bossy3_.setScale(1.6)
        Bossy3_.color = SKColor.red
        Bossy3_.colorBlendFactor = 1.0
        Bossy3_.size = CGSize(width: 400, height: 400)
        Bossy3_.zRotation = .pi
        
        Bossy3_.physicsBody = SKPhysicsBody(rectangleOf: Bossy3_.size)
        Bossy3_.physicsBody?.affectedByGravity = false
        //let moveAction = SKAction.move(to: endPosition, duration: 10)
        //BossyTwo.position = CGPoint(x: randomAppearY, y: size.height / 1.2)
        Bossy3_.position = CGPoint(x: size.width/2, y: size.height/2)

        addChild(Bossy3_)
    }
    func boss3FireFunc_() {
        let RandomAngle = CGFloat.random(in: 155...225) * CGFloat.pi / 180
        //BossyTwo_.zRotation = RandomAngle
        Boss3Fire_ = SKSpriteNode(imageNamed: "buttel.001")
        Boss3Fire_.position = Bossy3_.position
        Boss3Fire_.zRotation = Bossy3_.zRotation
        Boss3Fire_.zPosition = 4
        Boss3Fire_.color = SKColor.red
        Boss3Fire_.size = CGSize(width: 200, height: 200)
        Boss3Fire_.physicsBody?.affectedByGravity = false

        
         if let fireThunderPath = Bundle.main.path(forResource: "ChargeEffect", ofType: "sks"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: fireThunderPath)) {
             
             do {
                 let fireThruster = try NSKeyedUnarchiver.unarchivedObject(ofClass: SKEmitterNode.self, from: data) as SKEmitterNode?
                 fireThruster?.xScale = 1.2
                 fireThruster?.yScale = 1.2
                 fireThruster?.particleRotation = .pi
                 let fireThrusterEffectNode = SKEffectNode()
                 if let fireThruster = fireThruster {
                     fireThrusterEffectNode.addChild(fireThruster)
                 }
                 fireThrusterEffectNode.zPosition = 1
                 //fireThrusterEffectNode.position.y = -90
                 fireThrusterEffectNode.position.y = 90
                 //Boss3Fire_.addChild(fireThrusterEffectNode)
                 Bossy3_.addChild(fireThrusterEffectNode)
                 
                 fireThrusterEffectNode.xScale = 0.1 // Start scaled down (adjust as needed)
                 fireThrusterEffectNode.yScale = 0.1 // Start scaled down (adjust as needed)

                 let scaleIn = SKAction.scale(to: 1, duration: 2) // Scale to full size over 2 seconds
                 let fadeIn = SKAction.fadeIn(withDuration: 2) // Fade in from 0 to full opacity over 2 seconds

                 // Assuming you want the fade-in and scale-in to happen simultaneously
                 let group = SKAction.group([fadeIn, scaleIn]) // Group scale and fade-in to run at the same time

                 let fadeOut = SKAction.fadeOut(withDuration: 1.5) // Fade out after the fade-in and scale-in
                 let remove = SKAction.removeFromParent()

                 // Sequence: fade-in and scale-in, then fade-out, then remove
                 fireThrusterEffectNode.run(SKAction.sequence([group, fadeOut, remove]))
             } catch {
                 print("Error unarchiving file: \(error)")
             }
         }
        let currentRotation = Bossy3_.zRotation
        var rotationDifference = RandomAngle - currentRotation

        rotationDifference = (rotationDifference + .pi).truncatingRemainder(dividingBy: .pi * 2) - .pi
        rotationDifference = rotationDifference < -CGFloat.pi ? rotationDifference + 2 * CGFloat.pi : rotationDifference
            
        let rotationAction = SKAction.rotate(byAngle: rotationDifference, duration: 0.3)
        let wait = SKAction.wait(forDuration: 1.5)
        let combine = SKAction.sequence([wait, rotationAction])
        Bossy3_.run(combine)
        
        let slowBulletSpeed: CGFloat = 300
        let slowDx = slowBulletSpeed * cos(Boss3Fire_.zRotation + .pi/2)
        let slowDy = slowBulletSpeed * sin(Boss3Fire_.zRotation + .pi/2)
        let slowMoveAction = SKAction.moveBy(x: slowDx, y: slowDy, duration: 2)

        if let fireThunderPath = Bundle.main.path(forResource: "Thunder", ofType: "sks"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: fireThunderPath)) {
            
            do {
                let fireThruster = try NSKeyedUnarchiver.unarchivedObject(ofClass: SKEmitterNode.self, from: data) as SKEmitterNode?
                fireThruster?.xScale = 1.5
                fireThruster?.yScale = 1.5
                fireThruster?.particleRotation = .pi
                let fireThrusterEffectNode = SKEffectNode()
                if let fireThruster = fireThruster {
                    fireThrusterEffectNode.addChild(fireThruster)
                }
                fireThrusterEffectNode.zPosition = 3
                fireThrusterEffectNode.position.y = -90
                Boss3Fire_.addChild(fireThrusterEffectNode)
                
                let scaleIn = SKAction.scale(to: 1, duration: 1)
                //let fadein = SKAction.fadeIn(withDuration: 3)
                let fadeout = SKAction.fadeOut(withDuration: 1.5)
                let remove = SKAction.removeFromParent()
                fireThrusterEffectNode.run(SKAction.sequence([scaleIn ,wait, fadeout, remove]))
            } catch {
                print("Error unarchiving file: \(error)")
            }
        }

        
        let fastBulletSpeed: CGFloat = 1400
        let fastDx = fastBulletSpeed * cos(Boss3Fire_.zRotation + .pi/2)
        let fastDy = fastBulletSpeed * sin(Boss3Fire_.zRotation + .pi/2)
        let fastMoveAction = SKAction.moveBy(x: fastDx, y: fastDy, duration: 1)
            
        let deleteAction = SKAction.removeFromParent()
        //let group = SKAction.group([thunderAction, fastMoveAction])

        let sequence = SKAction.sequence([slowMoveAction, fastMoveAction, deleteAction])
        Boss3Fire_.run(sequence)
        addChild(Boss3Fire_)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        boss3FireFunc_()
    }
}

struct Boss3Show: View {
    var scene : SKScene{
        let scene = boss3ShowSimulation()
        scene.size = CGSize(width: 750, height: 1335)
        scene.scaleMode = .aspectFill
        return scene
    }
    var body: some View {
        ZStack{
            SpriteView(scene: scene)
                .ignoresSafeArea(.all)
        }
    }
}

#Preview {
    Boss3Show()
}
