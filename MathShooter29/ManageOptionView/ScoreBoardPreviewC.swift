//
//  ScoreBoardPreviewC.swift
//  MathShooter29
//
//  Created by วรัญพงษ์ สุทธิพนไพศาล on 9/2/2567 BE.
//

import SwiftUI

struct ScoreBoardPreviewC: View {
    let scores: [Int] = loadScore()
    @State private var animateScores = false
    @Binding var isActiveScore: Bool
    var body: some View {
        ZStack {
            Image("image002")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Text("Rank Score")
                    .font(.custom("Chalkduster", size: 40))
                    .foregroundColor(.red)
                    .padding(.top, 20)
                    //.position(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height * 0.1)
                
                VStack(spacing: 20) {
                    ForEach(Array(scores.enumerated()), id: \.offset) { index, score in
                        Text("Rank \(index + 1): \(score)")
                            .font(.custom("Chalkduster", size: 30))
                            .foregroundColor(.white)
                            .padding()
                            .background(index % 2 == 0 ? Color.cyan.opacity(0.5) : Color.blue.opacity(0.5))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 0.25)
                            )
                            .offset(x: animateScores ? 0 : UIScreen.main.bounds.width, y: 0)
                            .animation(Animation.easeOut.delay(Double(index) * 0.15), value: animateScores)
                    }
                }
                .padding(.top, 40)
                Spacer()
                Button(action: {
                    isActiveScore = false
                    animateScores = false
                }, label: {
                    HStack{
                        Image(systemName: "arrow.circlepath")
                        Text("back")
                    }
                    .foregroundColor(.black)
                    .font(.custom("Chalkduster", size: 30))
                    .padding()
                    .cornerRadius(30)
                    .shadow(color: .white, radius: 10, x: 0, y: 0)
                    .shadow(color: .blue, radius: 10, x: 0, y: 0)
                    .shadow(color: .white, radius: 20, x: 0, y: 0)
                })
            }
            .padding(.top, UIScreen.main.bounds.height * 0.1)
        }
        .onAppear {
            withAnimation {
                animateScores = true
            }
        }
    }
}


#Preview {
    ScoreBoardPreviewC(isActiveScore: .constant(false))
}
