//
//  MathShooter29App.swift
//  MathShooter29
//
//  Created by วรัญพงษ์ สุทธิพนไพศาล on 19/12/2566 BE.
//

import SwiftUI

@main
struct MathShooter29App: App {
    @EnvironmentObject var game_Data: gameData
    var body: some Scene {
        WindowGroup {
            SplashScreenView() //main
                .preferredColorScheme(.dark)
                //.environmentObject(game_Data)
        }
    }
}
