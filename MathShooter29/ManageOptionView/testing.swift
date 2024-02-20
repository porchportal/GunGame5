//
//  testing.swift
//  MathShooter29
//
//  Created by วรัญพงษ์ สุทธิพนไพศาล on 20/2/2567 BE.
//

import SwiftUI
struct OptionView1: View {
    @Binding var showTemporaryView: Bool
    @State private var selectedImage: UIImage?
    @State private var avatarImage: UIImage?
    @State private var showAlert = false
    @State private var changeView = false
    @EnvironmentObject var gameData: gameData
    @State private var isActiveScore: Bool = false
    @State private var isShowCustomVolume: Bool = false

    // Environment properties for adaptive layout
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    backgroundLayer(geometry: geometry)
                    contentLayer(geometry: geometry)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .ignoresSafeArea()
    }

    // Background layer with image and overlay
    private func backgroundLayer(geometry: GeometryProxy) -> some View {
        ZStack {
            Image("image003")
                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .opacity(1)
                .overlay(Rectangle().foregroundColor(.black).opacity(0.6))
        }
    }

    // Content layer with buttons and navigation links
    private func contentLayer(geometry: GeometryProxy) -> some View {
        VStack {
            Spacer()
            navigationLinks(geometry: geometry)
                .frame(width: 100, height: 100)
            buttons(geometry: geometry)
            Spacer()
        }
        .sheet(isPresented: $changeView, content: {
            TestingView3()
        })
        .fullScreenCover(isPresented: $isActiveScore, content: {
            ScoreBoardPreviewC(isActiveScore: $isActiveScore)
        })
        .sheet(isPresented: $isShowCustomVolume, content: {
            CustomVolumeView().presentationDetents([.fraction(0.2), .medium])
        })
    }

    // Navigation links for bosses
    private func navigationLinks(geometry: GeometryProxy) -> some View {
        HStack(alignment: .top) {
            NavigationLink(destination: others()) {
                bossOptionView(imageName: "Boss", text: "Boss1")
            }
            NavigationLink(destination: BossTwoShow()) {
                bossOptionView(imageName: "Boss", text: "Boss2")
            }
            NavigationLink(destination: Boss3Show()) {
                bossOptionView(imageName: "Boss", text: "Boss3")
            }
        }
    }

    // Reusable view for boss options
    private func bossOptionView(imageName: String, text: String) -> some View {
        VStack {
            ZStack {
                Rectangle()
                    .cornerRadius(10)
                Image(imageName)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .offset(CGSize(width: -1, height: 1))
                    .foregroundColor(.red)
            }
            Text(text)
                .font(.custom("Chalkduster", size: 20))
                .shadow(color: .white, radius: 10, x: -10, y: 0)
                .shadow(color: .white, radius: 10, x: 10, y: 0)
        }
        .foregroundColor(.black)
        .padding()
        .shadow(color: .blue, radius: 10)
        .shadow(color: .white, radius: 20)
    }

    // Buttons for actions
    private func buttons(geometry: GeometryProxy) -> some View {
        Group {
            actionButton(title: "Interface Boss1", action: {
                changeView = true
            })
            actionButton(title: "Control Volume", action: {
                isShowCustomVolume = true
            })
            actionButton(title: "Score Board", action: {
                isActiveScore = true
            })
            actionButton(title: "Music", action: {
                gameData.status = 6
                AudioManager.shared.playBackgroundMusic(filename: "Neon-gaming2.wav")
                AudioManager.shared.adjustVolume(volume: gameData.volume)
            })
            backButton()
        }
    }

    // Reusable view for action buttons
    private func actionButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.black)
                .font(.custom("Chalkduster", size: horizontalSizeClass == .compact ? 20 : 30))
                .padding()
                .background(Color.white.opacity(0.02))
                .cornerRadius(30)
                .shadow(color: .white, radius: 10)
                .shadow(color: .blue, radius: 10)
                .shadow(color: .white, radius: 20)
        }
    }

    // Back button with house icon
    private func backButton() -> some View {
        Button {
            gameData.status = 1
        } label: {
            HStack {
                Image(systemName: "house")
                Text("Back")
            }
            .foregroundColor(.black)
            .font(.custom("Chalkduster", size: 30))
            .padding()
            .background(Color.white.opacity(0.02))
            .cornerRadius(30)
            .shadow(color: .white, radius: 10)
            .shadow(color: .blue, radius: 10)
            .shadow(color: .white, radius: 20)
        }
    }
}

struct CustomVolumeView: View {
    @EnvironmentObject var gameData: gameData

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Volume Control")
                    .foregroundColor(.white)
                    .font(.headline)
                Slider(value: $gameData.volume, in: 0...1, step: 0.01)
                    .padding()
                    .onChange(of: gameData.volume) { newValue, _ in
                        AudioManager.shared.adjustVolume(volume: newValue)
                    }
                Text("Volume: \(Int(gameData.volume * 100))%")
                    .foregroundColor(.white)
                    .font(.subheadline)
            }
        }
    }
}

#Preview {
    OptionView1(showTemporaryView: .constant(false))
}
