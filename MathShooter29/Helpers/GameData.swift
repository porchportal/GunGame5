//
//  GameData.swift
//  MathShooter29
//
//  Created by วรัญพงษ์ สุทธิพนไพศาล on 6/2/2567 BE.
//

import Combine
import Foundation
import SwiftUI

class gameData: ObservableObject {
    @Published var score: Int = 0
    @Published var gameOver: Bool = false
    
    @Published var pauseSystem: Bool = true
    @Published var isPaused: Bool = false
    //NumPause only 1 or 2 please
    @Published var NumPause: Int = 0
    
    @Published var status: Int = 0
    @Published var volume: Float = 0.5
}

