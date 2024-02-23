//
//  GameData.swift
//  MathShooter29
//
//  Created by วรัญพงษ์ สุทธิพนไพศาล on 6/2/2567 BE.
//

import Combine
import SwiftUI

class gameData: ObservableObject {
    @Published var score: Int = 0
    @Published var gameOver: Bool = false
    @Published var isScoreView: Bool = false
    
    @Published var pauseSystem: Bool = false
    @Published var isPaused: Bool = false
    //NumPause only 1 or 2 please
    @Published var NumPause: Int = 0
    
    @Published var status: Int = 0
    @Published var volume: Float = 1
    @Published var volumeEffect: Float = 1
    
    @Published var showGameScene: Bool = false
    
    @Published var messageNoti: Bool = false
    @Published var messagePopUp: Bool = false
    @Published var isGamePresent: Bool = false
    @Published var isShowingAlert: Bool = false
    
    @Published var countGamePlay: Int = 0
}

