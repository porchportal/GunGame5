//
//  CustomAlertView.swift
//  MathShooter29
//
//  Created by วรัญพงษ์ สุทธิพนไพศาล on 21/2/2567 BE.
//

import SwiftUI

struct CustomAlertView: View {
    @EnvironmentObject var game_Data: gameData
    //@Binding var isPresented: Bool
    //@Binding var volume: Float
    //var isPresented: Bool
    @State private var offset: CGFloat = 1000
    @State private var showingVolumeLabel = false

    var body: some View {
        GeometryReader{ sizeIn in
            ZStack{
                Color(.black)
                    .ignoresSafeArea(.all)
                    .opacity(0.6)
                    .onTapGesture {
                        close()
                        game_Data.messageNoti = true
                    }
                VStack {
                    Text("Setting")
                        .font(.system(size: sizeIn.size.width/20, weight: .bold))
                        .foregroundColor(.black)
                        .padding()
                    
                    Text("if you want to continue game, please click (Resume)")
                        .font(.system(size: sizeIn.size.width/35, weight: .regular))
                        .foregroundColor(.black)
                        .font(.body)
                    
                    if showingVolumeLabel {
                        Text("Volume: \(Int(game_Data.volume * 100))%")
                            .font(.system(size: 30, weight: .regular))
                            .foregroundColor(.black)
                            .padding()
                            .opacity(showingVolumeLabel ? 1 : 0)
                            .animation(.easeInOut(duration: 0.5), value: showingVolumeLabel)
                    }

                    
                    HStack{
                        Button(action: {
                            let newVolume = max(game_Data.volume - 0.01, 0)
                            game_Data.volume = newVolume
                            showLabelOnVolume()
                            AudioManager.shared.adjustVolume(volume: newVolume)
                        }) {
                            Image(systemName: "speaker.minus")
                                .resizable()
                                .foregroundColor(.black)
                                .frame(width: 15, height: 15)
                        }
                        Slider(value: Binding(
                            get: {
                                game_Data.volume
                            },
                            set: { newValue in
                                game_Data.volume = newValue
                                AudioManager.shared.adjustVolume(volume: newValue)
                                showLabelOnVolume()
                            }
                        ), in: 0...1, step: 0.01)
                            .padding()
                        Button(action: {
                            let newVolume = max(game_Data.volume + 0.01, 0)
                            game_Data.volume = newVolume
                            AudioManager.shared.adjustVolume(volume: newVolume)
                            showLabelOnVolume()
                        }) {
                            Image(systemName: "speaker.plus")
                                .resizable()
                                .foregroundColor(.black)
                                .frame(width: 15, height: 15)
                        }
                    }
                    .frame(width: sizeIn.size.width/2 + 60, height: 50)
                    
                    HStack{
                        Button(action: {
                            close()
                            game_Data.messageNoti = true
                        }, label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundColor(.green)
                                HStack{
                                    Image(systemName: "arrow.right.to.line.alt")
                                        .resizable()
                                        .frame(width: sizeIn.size.width/30, height: sizeIn.size.width/30)
                                        .foregroundColor(.white)
                                    Text("Resume")
                                        .font(.system(size: sizeIn.size.width/35, weight: .medium))
                                        .foregroundColor(.white)
                                        //.padding()
                                }
                                .shadow(color: .black, radius: 20, x: 0, y: 0)
                                .padding()
                            }
                            .padding()
                        })
                        Button(action: {
                            game_Data.isGamePresent = false
                            game_Data.isPaused = false
                            game_Data.score = 0
                            AudioManager.shared.playBackgroundMusic(filename: "Neon-gaming2.wav")
                            AudioManager.shared.adjustVolume(volume: game_Data.volume)
                            close()
                        }, label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundColor(.red)
                                HStack{
                                    Image(systemName: "xmark.octagon")
                                        .resizable()
                                        .frame(width: sizeIn.size.width/30, height: sizeIn.size.width/30)
                                        .foregroundColor(.white)
                                    Text("Exit")
                                        .font(.system(size: sizeIn.size.width/35, weight: .medium))
                                        .foregroundColor(.white)
                                }
                                .shadow(color: .black, radius: 20, x: 0, y: 0)
                                .padding()
                            }
                            .padding()
                        })
                    }
                    //.frame(width: sizeIn.size.width/2 + 150)

                }
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .background(.white.opacity(0.9))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(alignment: .topTrailing) {
                    Button {
                        close()
                        game_Data.messageNoti = true
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .fontWeight(.medium)
                    }
                    .tint(.black)
                    .padding()
                }
                //.frame(width: sizeIn.size.width/2)
                .shadow(radius: 20)
                .padding(30)
                .offset(x: 0, y: offset)
                .onAppear {
                    withAnimation(.spring()) {
                        offset = 0
                    }
                }
            }
        }
    }
    func close() {
        withAnimation(.spring()) {
            offset = 1000
            game_Data.isShowingAlert = false
        }
    }
    func showLabelOnVolume(){
        withAnimation{
            showingVolumeLabel = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation{
                showingVolumeLabel = false
            }
        }
    }
}
#Preview {
    CustomAlertView()
        .environmentObject(gameData())
}
