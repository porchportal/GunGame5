//
//  StartView.swift
//  MathShooter29
//
//  Created by วรัญพงษ์ สุทธิพนไพศาล on 21/12/2566 BE.
//

import SwiftUI

var shipChoice = UserDefaults.standard
struct StartView: View {
    @State private var activeButton: Int? = nil
    @EnvironmentObject var game_Data: gameData
    //@State private var isGamePresent = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @State var degreesRotating = 0.0
    var body: some View {
        GeometryReader{ geometry in
            ZStack {
                ZStack(alignment: .center){
                    if horizontalSizeClass == .regular && verticalSizeClass == .regular {
                        //Text("Running on iPad or large-screen device")
                        AnimatedBackground()
                            .position(
                                x: CGFloat.random(in: 100...geometry.size.width-100),
                                y: CGFloat.random(in: 100...geometry.size.height-100)
                            )
                    }
                    AnimatedBackground()
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        //.ignoresSafeArea(.all)
                        .edgesIgnoringSafeArea(.all)
                    
                    BackgroundPlayer(refreshRate: 60)
                        .frame(width: UIScreen.main.bounds.width/1.2, height: UIScreen.main.bounds.height/1.2)
                        //.ignoresSafeArea(.all)
                        .edgesIgnoringSafeArea(.all)
                }
                Text("MathShooter")
                    .font(.custom("Chalkduster", size: min(geometry.size.width, geometry.size.height) * 0.08))
                    .foregroundColor(.black)
                    .foregroundStyle(Color.gray)
                    .background(Color.white.opacity(0.02))
                    .cornerRadius(30)
                    .shadow(color: .white, radius: 20, x: -10, y: 0)
                    .shadow(color: .white, radius: 20, x: 10, y: 0)
                    .padding(30)
                    .position(CGPoint(x: geometry.size.width/2,
                                      y: geometry.size.height/2 - 250))
                // Main content
                VStack{
                    Spacer()
                    VStack(alignment: .center, spacing: 10){

                        Button{
                            game_Data.isGamePresent = true
                            game_Data.showGameScene = true
                            AudioManager.shared.stopBackgroundMusic()
                        } label: {
                            Text("Start Game")
                                .font(.custom("Chalkduster", size: min(geometry.size.width, geometry.size.height) * 0.07))
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.green.opacity(0.06))
                                .clipShape(.capsule)
                                .cornerRadius(30)
                                .shadow(color: .green, radius: 10, x: 0, y: 0)
                                .shadow(color: .white, radius: 20, x: -10, y: 0)
                                .shadow(color: .white, radius: 20, x: 10, y: 0)
                            
                        }
                        .fullScreenCover(isPresented: $game_Data.isGamePresent, content: {
                            ContentView()
                        })
                        .padding()
                        Button{
                            withAnimation{
                                //self.status = 4
                                game_Data.status = 4
                                AudioManager.shared.stopBackgroundMusic()
                            }
                        } label: {
                            Text("Option")
                                .foregroundColor(.black)
                                .font(.custom("Chalkduster", size: min(geometry.size.width, geometry.size.height) * 0.07))
                                //.font(.custom("Chalkduster", size: 30))
                                .padding()
                                .background(Color.gray.opacity(0.06))
                                .clipShape(.capsule)
                                .cornerRadius(30)
                                .shadow(color: .white, radius: 10, x: 5, y: 5)
                                .shadow(color: .white, radius: 20, x: -10, y: 0)
                                .shadow(color: .white, radius: 20, x: 10, y: 0)
                            
                        }
                    }
                    Spacer()
                }
                .padding()
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2 + 10)
                
                HStack{
                    Spacer()
                    VStack{
                        Text("Select the Ship")
                            .font(.custom("Chalkduster", size: min(geometry.size.width, geometry.size.height) * 0.025))
                            //.font(.custom("Chalkduster", size: 15))
                            .foregroundStyle(Color.white)
                        
                        Button(action: {
                            makePlayerChoice()
                            withAnimation(.easeIn(duration: 0.5)) {
                                activeButton = 0
                            }
                        }) {
                            buttonContent(title: "1", id: 0)
                                .font(.custom("Chalkduster", size: 20))
                        }
                        Button(action: {
                            makePlayerChoice2()
                            withAnimation(.easeIn(duration: 0.5)) {
                                activeButton = 1
                            }
                        }) {
                            buttonContent(title: "2", id: 1)
                                .font(.custom("Chalkduster", size: 20))
                        }
                        Button(action: {
                            makePlayerChoice3()
                            withAnimation(.easeIn(duration: 0.5)) {
                                activeButton = 2
                            }
                        }) {
                            buttonContent(title: "3", id: 2)
                                .font(.custom("Chalkduster", size: 20))
                        }
                    }.padding(10)
                    
                }
                .buttonStyle(ShipButtonStyle())
                .position(x: geometry.size.width / 2.2, y: geometry.size.height/1.2)
            }
            //.position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
        .transition(.asymmetric(insertion: .scale, removal: .opacity))
        
    }
    
    func makePlayerChoice(){
        shipChoice.set(1, forKey: "playerChoice")
    }
    func makePlayerChoice2(){
        shipChoice.set(2, forKey: "playerChoice")
    }
    func makePlayerChoice3(){
        shipChoice.set(3, forKey: "playerChoice")
    }
    private func buttonContent(title: String, id: Int) -> some View {
        HStack(spacing: 10) {
            Image(getShipImageName(for: id))
                .resizable()
                .frame(width: 40, height: 40)
                //.cornerRadius(10)
            Text(title)
                .foregroundColor(.black)
                //.foregroundColor(activeButton == id ? .black : .primary)
            if activeButton == id {
                Image(systemName: "hand.thumbsup")
                    .frame(width: 30, height: 10)
                    .foregroundColor(.green)
                    .scaleEffect(1.3)
            }
        }
        .frame(width: 110, height: 50)
        .background(activeButton == id ? Color.green.opacity(0.2) : Color.clear)
        .cornerRadius(10)
        .overlay(
            Circle()
                .strokeBorder(lineWidth: activeButton == id ? 0 : 0)
                .frame(width: 70, height: 70)
                .foregroundColor(Color(.systemPink))
                .hueRotation(.degrees(activeButton == id ? 0 : 200))
                .scaleEffect(activeButton == id ? 1.9 : 1)
                .offset(x: activeButton == id ? 35 : 0, y: 0), alignment: .trailing//35 65
        )
    }
    private func getShipImageName(for id: Int) -> String {
        switch id {
        case 0:
            return "playerShip5.001"
        case 1:
            return "Player2.001"
        case 2:
            return "player9.001"
        default:
            return "DefaultShipImage"
        }
    }
}
struct ShipButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.black)
            .font(.system(size: 20, weight: .bold, design: .serif))
            //.padding()
            .background(configuration.isPressed ? .gray.opacity(0.02) : .gray.opacity(0.2))
            .shadow(color: .white, radius: 10, x: 5, y: 5)
            .shadow(color: .white, radius: 10, x: 0, y: 0)
            .clipShape(Capsule())

    }
}
struct AnimatedBackground: View {
    @State private var degreesRotating = 0.0
    @State private var degreesRotating1 = 0.0
    var body: some View {
        ZStack {
            Image("background effect .001")
                .resizable()
                .frame(width: 500, height: 410)
                .rotationEffect(.degrees(degreesRotating))
                .onAppear {
                    withAnimation(.linear(duration: 2).speed(0.1).repeatForever(autoreverses: false)) {
                        degreesRotating = -360.0
                    }
                }
            Image("background effect .002")
                .resizable()
                .frame(width: 380, height: 300)
                .rotationEffect(.degrees(degreesRotating1))
                .onAppear {
                    withAnimation(.linear(duration: 2).speed(0.1).repeatForever(autoreverses: false)) {
                        degreesRotating1 = 360.0
                    }
                }
                //.offset(y: -8)
        }
        .opacity(0.25)
    }
}


#Preview {
    StartView()
        .environmentObject(gameData())
        .preferredColorScheme(.dark)
        .edgesIgnoringSafeArea(.all)
}
