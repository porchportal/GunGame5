//
//  OptionView.swift
//  MathShooter29
//
//  Created by วรัญพงษ์ สุทธิพนไพศาล on 7/1/2567 BE.
//

import SwiftUI

struct OptionView: View {
    @Binding var showTemporaryView : Bool
    //@Binding var status: Int
    @State private var selectedImage: UIImage?
    //@ObservedObject var scene = Game_Scene(gameData: gameData, size: .zero)
    @State private var avatarImage: UIImage?
    @State private var showAlert = false
    @State private var changfeView = false
    @EnvironmentObject var game_Data: gameData
    @State private var isActiveScore : Bool = false
    @State private var isShowCustomVolume: Bool = false
    //image003
    var body: some View {
        NavigationView {
            GeometryReader{ sizeIn in
                ZStack{
                    ZStack(alignment: .center){
                        Image("image003")
                            .resizable()
                            .opacity(1)
                            .ignoresSafeArea(.all)
                        Rectangle()
                            .foregroundColor(.black)
                            .opacity(0.5)
                            .ignoresSafeArea()
                    }
                    .position(CGPoint(x: sizeIn.size.width/2, y: sizeIn.size.height/2))
                        
                    
                    VStack{
                        Spacer()
                        HStack(alignment: .top){
                            NavigationLink(destination:{
                                others()
                            }, label: {
                                VStack{
                                    ZStack{
                                        Rectangle()
                                            .cornerRadius(10)
                                        Image("Boss")
                                            .resizable()
                                            .offset(CGSize(width: -1, height: 1))
                                            .foregroundColor(.red)
                                            //.position(x: 0)
                                    }
                                    .frame(width: 50, height: 50)
                                    Text("Boss1")
                                        .font(.custom("Chalkduster", size: 20))
                                        .shadow(color: .white, radius: 10, x: -10, y: 0)
                                        .shadow(color: .white, radius: 10, x: 10, y: 0)
                                    
                                }
                                .foregroundColor(.black)
                                .padding()
                                .shadow(color: .blue, radius: 10, x: 0, y: 0)
                                .shadow(color: .white, radius: 20, x: 0, y: 0)
                            })
                            //others()
                            NavigationLink(destination:{
                                BossTwoShow()
                            }, label: {
                                VStack{
                                    ZStack{
                                        Rectangle()
                                            .cornerRadius(10)
                                        Image("Boss")
                                            .resizable()
                                            .offset(CGSize(width: -1, height: 1))
                                            .foregroundColor(.red)
                                            //.position(x: 0)
                                    }
                                    .frame(width: 50, height: 50)
                                    Text("Boss2")
                                        .font(.custom("Chalkduster", size: 20))
                                        .shadow(color: .white, radius: 10, x: -10, y: 0)
                                        .shadow(color: .white, radius: 10, x: 10, y: 0)
                                    
                                }
                                .foregroundColor(.black)
                                .padding()
                                .shadow(color: .blue, radius: 10, x: 0, y: 0)
                                .shadow(color: .white, radius: 20, x: 0, y: 0)
                            })
                            NavigationLink(destination:{
                                Boss3Show()
                            }, label: {
                                VStack{
                                    ZStack{
                                        Rectangle()
                                            .cornerRadius(10)
                                        Image("Boss")
                                            .resizable()
                                            .offset(CGSize(width: -1, height: 1))
                                            .foregroundColor(.red)
                                            //.position(x: 0)
                                    }
                                    .frame(width: 50, height: 50)
                                    Text("Boss3")
                                        .font(.custom("Chalkduster", size: 20))
                                        .shadow(color: .white, radius: 10, x: -10, y: 0)
                                        .shadow(color: .white, radius: 10, x: 10, y: 0)
                                    
                                }
                                .foregroundColor(.black)
                                .padding()
                                .shadow(color: .blue, radius: 10, x: 0, y: 0)
                                .shadow(color: .white, radius: 20, x: 0, y: 0)
                            })
                        }
                        
                        
                        Button("Interface Boss1"){
                            changfeView = true
                        }
                        .foregroundColor(.black)
                        .font(.custom("Chalkduster", size: 30))
                        .padding()
                        .cornerRadius(30)
                        .shadow(color: .blue, radius: 10, x: 0, y: 0)
                        //.shadow(color: .white, radius: 10, x: 0, y: 0)
                        .shadow(color: .white, radius: 8, x: 20, y: 0)
                        .shadow(color: .white, radius: 8, x: -20, y: 0)
                        //.shadow(color: .blue, radius: 10, x: 0, y: 0)
                        .padding(20)
                        
                        Button(action: {
                            isShowCustomVolume = true
                        }, label: {
                            Text("Control Volume")
                                .foregroundColor(.black)
                                .font(.custom("Chalkduster", size: 30))
                                .padding()
                                .background(Color.white.opacity(0.02))
                                .cornerRadius(30)
                                .shadow(color: .white, radius: 10, x: 0, y: 0)
                                .shadow(color: .blue, radius: 10, x: 0, y: 0)
                                .shadow(color: .white, radius: 20, x: 0, y: 0)
                        })
                        Button{
                            isActiveScore = true
                        } label: {
                            Text("Score Board")
                                .foregroundColor(.black)
                                .font(.custom("Chalkduster", size: 30))
                                .padding()
                                .cornerRadius(30)
                                .shadow(color: .white, radius: 10, x: 0, y: 0)
                                .shadow(color: .blue, radius: 10, x: 0, y: 0)
                                .shadow(color: .white, radius: 20, x: 0, y: 0)
                        }
                        Button{
                            game_Data.status = 6
                            //status = 6
                        } label: {
                            Text("Music")
                                .foregroundColor(.black)
                                .font(.custom("Chalkduster", size: 30))
                                .padding()
                                .cornerRadius(30)
                                .shadow(color: .white, radius: 10, x: 0, y: 0)
                                .shadow(color: .blue, radius: 10, x: 0, y: 0)
                                .shadow(color: .white, radius: 20, x: 0, y: 0)
                        }
                        Button{
                            game_Data.status = 1
                            AudioManager.shared.playBackgroundMusic(filename: "Neon-gaming2.wav")
                            AudioManager.shared.adjustVolume(volume: game_Data.volume)
                            //status = 1
                        } label: {
                            HStack{
                                Image(systemName: "house")
                                Text("back")
                            }
                            .foregroundColor(.black)
                            .font(.custom("Chalkduster", size: 30))
                            .padding()
                            .background(Color.white.opacity(0.02))
                            .cornerRadius(30)
                            .shadow(color: .white, radius: 10, x: 0, y: 0)
                            .shadow(color: .blue, radius: 10, x: 0, y: 0)
                            .shadow(color: .white, radius: 20, x: 0, y: 0)
                        }
                        Spacer()
                    }
                    .sheet(isPresented: $changfeView, content: {
                        TestingView3()
                    })
                    .fullScreenCover(isPresented: $isActiveScore, content: {
                        ScoreBoardPreviewC(isActiveScore: $isActiveScore)
                    })
                    if isShowCustomVolume {
                        customVolumeView(isShowCustomVolume: $isShowCustomVolume)
                    }
                    /*
                    .sheet(isPresented: $isShowCustomVolume, content: {
                        customVolumeView()
                            //.presentationDetents([.medium])
                            .presentationDetents([.fraction(0.2), .medium])
                    })*/
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .background(Color.black)
    }
}
struct customVolumeView: View {
    @EnvironmentObject var gameData: gameData
    @Binding var isShowCustomVolume: Bool
    @State private var offset: CGFloat = 1000
    var body: some View {
        GeometryReader { geo in
            ZStack{
                Color(.black)
                    .ignoresSafeArea(.all)
                    .opacity(0.5)
                    .onTapGesture {
                        close()
                    }
                /*
                Rectangle()
                    .foregroundColor(.black)
                    .ignoresSafeArea(.all)*/
                VStack{
                    Text("Volume Control")
                        .foregroundColor(.black)
                        .font(.custom("", size: 20))
                    Text("Volume: \(Int(gameData.volume * 100))%")
                        .foregroundColor(.black)
                        .font(.custom("", size: 20))
                        .padding()
                    Slider(value: Binding(
                        get: {
                            gameData.volume
                        },
                        set: { newValue in
                            gameData.volume = newValue
                            AudioManager.shared.adjustVolume(volume: newValue)
                        }
                    ), in: 0...1, step: 0.01)
                    .padding()
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .background(.white.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(alignment: .topTrailing) {
                    Button {
                        close()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .fontWeight(.medium)
                    }
                    .tint(.black)
                    .padding()
                }
                .shadow(radius: 20)
                .padding(30)
                .offset(x: 0, y: offset)
                //.frame(width: geo.size.width/2, height: geo.size.height/2)
                .shadow(color: .white, radius: 10, x: 0, y: 0)
                .onAppear {
                    withAnimation(.spring()) {
                        //offset = 500
                        offset = geo.size.height/2 - 100
                    }
                }
            }
        }
    }
    func close() {
        withAnimation(.spring()) {
            offset = 1000
            isShowCustomVolume = false
        }
    }
}

#Preview {
    OptionView(showTemporaryView: .constant(false))
        .environmentObject(gameData())
        .ignoresSafeArea(.all)
}
