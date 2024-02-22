//
//  ManageView.swift
//  MathShooter29
//
//  Created by วรัญพงษ์ สุทธิพนไพศาล on 27/12/2566 BE.
//

import SwiftUI

struct ManageView: View {
    @EnvironmentObject var game_Data: gameData
    //@State private var status: Int = 0
    //@Binding var musicVolume1: Float
    //@State private var ContentActive: Bool = false
    @State private var timer: Timer?
    var body: some View {
        ZStack{
            switch game_Data.status{
            case 0:
                welcomeSection
                    .transition(.opacity)
                    .environmentObject(game_Data)
            case 1:
                StartView()
                    .transition(.opacity)
                    .environmentObject(game_Data)
                    .onAppear{
                        //AudioManager.shared.playBackgroundMusic(filename: "Neon-gaming2.wav")
                        //AudioManager.shared.adjustVolume(volume: game_Data.volume)
                    }
            case 4:
                OptionView(showTemporaryView: .constant(false))
                    .transition(.opacity)
                    .environmentObject(game_Data)
            case 5:
                others()
                    .transition(.opacity)
                    .environmentObject(game_Data)
            case 6:
                MusicManager()
                    .transition(.opacity)
                    .environmentObject(game_Data)
            default:
                ZStack{
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundStyle(.purple)
                        .transition(.opacity)
                    Button(action: {
                        game_Data.status = 1
                    }, label: {
                        Text("Exit")
                        foregroundColor(.black)
                        .font(.custom("Chalkduster", size: 30))
                        .padding()
                        .cornerRadius(30)
                        .shadow(color: .white, radius: 10, x: 0, y: 0)
                        .shadow(color: .blue, radius: 10, x: 0, y: 0)
                        .shadow(color: .white, radius: 20, x: 0, y: 0)
                    })
                }
            }
        }
    }
}
extension ManageView{
    private var buttom: some View{
        Text("Let's play")
            .font(.headline)
            .foregroundStyle(Color.white)
    }
    private var welcomeSection: some View{
        ZStack{
            Rectangle()
                .fill(Color.black)
                .edgesIgnoringSafeArea(.all)
            VStack{
                TextShimmer(text: "Welcome")
                    .font(.custom("Chalkduster", size: 65))
                    .padding()
                    //.background(Color.white.opacity(0.6))
                    .cornerRadius(30)
                    .shadow(color: .white, radius: 20, x: 0, y: 0)
                    .shadow(color: .blue, radius: -20, x: 0, y: 0)
                    .shadow(color: .blue, radius: 20, x: 0, y: 0)
                
            }
            
        }
        .onTapGesture {
            timer?.invalidate()
            game_Data.status = 1

        }
        .onAppear {
            timer = Timer.scheduledTimer(withTimeInterval: 6, repeats: false) { _ in
                game_Data.status = 1
                //AudioManager.shared.playBackgroundMusic(filename: "neon-gaming.mp3")
            }
        }
    }
}
struct TextShimmer: View{
    var text: String

    @State var animation = false
    
    //Random Color
    func randomColor() -> Color{
        let color = UIColor(red: CGFloat.random(in: 0...2),
                            green: CGFloat.random(in: 0...2), blue: 1, alpha: 1)
        return Color(color)
    }
    
    var body: some View{
        ZStack{
            Text(text)
                .font(.system(size: 45, weight: .bold))
                .foregroundColor(Color.black.opacity(0.85))
            
            // MutiColor
            HStack(spacing: 0){
                ForEach(0..<text.count, id: \.self){index in
                    Text(String(text[text.index(text.startIndex, offsetBy: index)]))
                        .font(.system(size: 45, weight: .bold))
                        .foregroundColor(randomColor())
                }
            }
            // masking for shimmer Effect
            .mask(
                Rectangle()
                    .fill(
                        LinearGradient(gradient: .init(colors: [Color.white.opacity(1.4), Color.green, Color.green.opacity(1.4)]), startPoint: .top, endPoint: .bottom)
                    )
                    .rotationEffect(.init(degrees: 70))
                    .padding(20)
                    //moving view continously
                    .offset(x: -250)
                    .offset(x: animation ? 500 : 0)
            )
            .onAppear(perform: {
                withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)){
                    animation.toggle()
                }
            })
        }
    }
}

#Preview {
    ManageView()
        .environmentObject(gameData())
        .preferredColorScheme(.dark)
}
