//
//  MusicMain.swift
//  MathShooter29
//
//  Created by วรัญพงษ์ สุทธิพนไพศาล on 11/2/2567 BE.
//

//for main game
import SpriteKit
import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    private var backgroundMusicPlayer: AVAudioPlayer?
    var gameData: gameData?
    
    private init() {
        configureAudioSession()
    }
    func setGameData(_ gameData: gameData) {
        self.gameData = gameData
    }
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    func playBackgroundMusic(filename: String) {
        guard let bundle = Bundle.main.path(forResource: filename, ofType: nil) else { return }
        let backgroundMusicUrl = URL(fileURLWithPath: bundle)

        // Stop current music if it's playing
        //if backgroundMusicPlayer?.isPlaying == true {
          //  backgroundMusicPlayer?.stop()
        //}

        fadeOutCurrentMusic {
            // Stop current music if it's playing
            self.backgroundMusicPlayer?.stop()
            
            // Delay the start of the new track
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                do {
                    self.backgroundMusicPlayer = try AVAudioPlayer(contentsOf: backgroundMusicUrl)
                    self.backgroundMusicPlayer?.numberOfLoops = -1
                    self.backgroundMusicPlayer?.prepareToPlay()
                    self.backgroundMusicPlayer?.play()
                } catch {
                    print("Could not load file: \(error)")
                }
            }
        }
    }

    func stopBackgroundMusic() {
        if backgroundMusicPlayer?.isPlaying == true {
            backgroundMusicPlayer?.stop()
        }
    }/*
    func adjustVolume() {
        backgroundMusicPlayer?.volume = gameData?.volume ?? 0.5
    }*/
    func adjustVolume(volume: Float) {
        backgroundMusicPlayer?.volume = volume
    }
    private func fadeOutCurrentMusic(completion: @escaping () -> Void) {
        // Implement fade out logic here
        // For demonstration, directly call completion
        completion()
    }
}
