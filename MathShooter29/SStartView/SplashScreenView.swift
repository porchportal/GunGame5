//
//  SplashScreenView.swift
//  MathShooter29
//
//  Created by วรัญพงษ์ สุทธิพนไพศาล on 7/1/2567 BE.
//

import SwiftUI

struct SplashScreenView: View {
    @State var isActive : Bool = false
    @State private var size = 0.8
    @State private var opacity = 0.3
    //@Binding var status :Int
    
    var body: some View {
        if isActive {
            ManageView()
                .environmentObject(gameData())
        } else {
            GeometryReader{ sizeIn in
                ZStack{
                    Rectangle()
                        .foregroundStyle(.black)
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        VStack {
                            Image("Space01.001")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: sizeIn.size.width / 3, height: sizeIn.size.height / 3)
                                .shadow(color: .blue, radius: 10, x: 0, y: 0)
                                .shadow(color: .blue, radius: 60, x: 0, y: 0)
                        }
                        .scaleEffect(size)
                        .opacity(opacity)
                        .onAppear {
                            withAnimation(.easeIn(duration: 1.2)) {
                                self.size = 1.0
                                self.opacity = 1.00
                            }
                        }
                    }
                }
            }
            .onAppear {
                AudioManager.shared.prepareBackgroundMusic(filename: "gameMain.mp3")
                AudioManager.shared.prepareBackgroundMusic(filename: "infinity-.mp3")
                AudioManager.shared.prepareBackgroundMusic(filename: "Normalmusic.wav")
                AudioManager.shared.prepareBackgroundMusic(filename: "Hitman.mp3")
                AudioManager.shared.prepareBackgroundMusic(filename: "evil-boss.mp3")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
        .environmentObject(gameData())
}
