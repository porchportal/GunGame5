//
//  ScoreRankOnSKScene.swift
//  MathShooter29
//
//  Created by วรัญพงษ์ สุทธิพนไพศาล on 21/2/2567 BE.
//

import SwiftUI

struct ScoreRankOnSKScene: View {
    @EnvironmentObject var game_Data: gameData
    //let scores = loadScore()
    let scores = loadScore()
    @State private var animateScores = false
    //var currentScore: Int = 0
    var body: some View {
        GeometryReader{ sizeIn in
            ZStack(alignment: .center){
                Image("image002")
                    .resizable()
                    //.scaledToFit()
                    .opacity(1)
                    .ignoresSafeArea(.all)

                VStack {
                    Text("Game Over")
                        .font(.custom("Chalkduster", size: sizeIn.size.width/10))
                        .foregroundColor(.red)
                        .padding()
                    Text("Your score: \(game_Data.score)")
                        .font(.custom("Chalkduster", size: sizeIn.size.width/23))
                        .foregroundColor(.green)
                        .padding()

                    if !scores.contains(game_Data.score) {
                        Text("Your score is not on the rank")
                            .font(.custom("Chalkduster", size: sizeIn.size.width/35))
                            .foregroundColor(.red)
                    }
                    VStack{
                        ForEach(Array(scores.enumerated()), id: \.offset) { index, score in
                            Text("Rank \(index + 1): \(score)")
                                .font(.custom("Chalkduster", size: sizeIn.size.width/20))
                                .foregroundColor(.white)
                                .padding()
                                .background(
                                    score == game_Data.score ? Color.green.opacity(0.5) :
                                    (index % 2 == 0 ? Color.cyan.opacity(0.5) : Color.blue.opacity(0.5))
                                )
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 0.25)
                                )
                                //.offset(x: animateScores ? 0 : UIScreen.main.bounds.width, y: 0)
                                .offset(x: animateScores ? 0 : sizeIn.size.width, y: 0)
                                .animation(Animation.easeOut.delay(Double(index) * 0.15), value: animateScores)
                        }
                    }
                }
                .position(CGPoint(x: sizeIn.size.width/2, y: sizeIn.size.height/2 - 150))
            }
        }
        .onAppear {
            withAnimation {
                animateScores = true
            }
        }
    }
}

#Preview {
    ScoreRankOnSKScene()
        .environmentObject(gameData())
}
