//
//  BossTwoShow.swift
//  MathShooter29
//
//  Created by วรัญพงษ์ สุทธิพนไพศาล on 8/2/2567 BE.
//

import SwiftUI
import SpriteKit

class bossTwoShowSimulation: SKScene {
    var BossyTwo_ = SKSpriteNode()
    var BossTwoFire_ = SKSpriteNode()
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
        BossyTwo_ = SKSpriteNode(imageNamed: "Boss")
        BossyTwo_.name = "BossTwo"
        BossyTwo_.zPosition = 15
        BossyTwo_.setScale(1.6)
        BossyTwo_.color = SKColor.red
        BossyTwo_.colorBlendFactor = 1.0
        BossyTwo_.size = CGSize(width: 400, height: 400)
        BossyTwo_.zRotation = .pi
        
        BossyTwo_.physicsBody = SKPhysicsBody(rectangleOf: BossyTwo_.size)
        BossyTwo_.physicsBody?.affectedByGravity = false
        
        //let moveAction = SKAction.move(to: endPosition, duration: 10)
        //BossyTwo.position = CGPoint(x: randomAppearY, y: size.height / 1.2)
        BossyTwo_.position = CGPoint(x: size.width/2, y: size.height/2)

        addChild(BossyTwo_)
    }
    func bossTwoFireFunc_() {
        let RandomAngle = CGFloat.random(in: 135...225) * CGFloat.pi / 180
        //BossyTwo_.zRotation = RandomAngle
        BossTwoFire_ = SKSpriteNode(imageNamed: "buttel.001")
        BossTwoFire_.position = BossyTwo_.position
        let rotationAction = SKAction.rotate(toAngle:RandomAngle, duration: 0.3)
        BossyTwo_.run(rotationAction)
        BossTwoFire_.zRotation = BossyTwo_.zRotation
        BossTwoFire_.name = "BossTwoFire"
        BossTwoFire_.zPosition = 3
        BossTwoFire_.color = SKColor.red
        BossTwoFire_.size = CGSize(width: 200, height: 200)
        BossTwoFire_.physicsBody?.affectedByGravity = false
        
        let bulletSpeed: CGFloat = 1400
        let Dx = bulletSpeed * cos(BossTwoFire_.zRotation + .pi/2)
        let Dy = bulletSpeed * sin(BossTwoFire_.zRotation + .pi/2)
        let moveAction = SKAction.moveBy(x: Dx, y: Dy, duration: 1)
        let deleteAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveAction, deleteAction])
        
        BossTwoFire_.run(sequence)
        addChild(BossTwoFire_)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        bossTwoFireFunc_()
    }
}

struct BossTwoShow: View {
    
    var scene : SKScene{
        let scene = bossTwoShowSimulation()
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
    BossTwoShow()
}
