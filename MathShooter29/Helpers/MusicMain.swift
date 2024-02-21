//
//  MusicMain.swift
//  MathShooter29
//
//  Created by วรัญพงษ์ สุทธิพนไพศาล on 11/2/2567 BE.
//

//for main game
import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    private var backgroundMusicPlayer: AVAudioPlayer?
    var gameData: gameData?
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    
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
        stopBackgroundMusic()
        if let player = audioPlayers[filename] {
            fadeOutCurrentMusic {
                player.play()
            }
        } else {
            prepareBackgroundMusic(filename: filename)
        }
    }

    func stopBackgroundMusic() {
        audioPlayers.values.forEach { $0.stop() }
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
    internal func prepareBackgroundMusic(filename: String) {
        guard let bundle = Bundle.main.path(forResource: filename, ofType: nil) else {
            print("Error: File not found - \(filename)")
            return
        }
        let backgroundMusicUrl = URL(fileURLWithPath: bundle)
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: backgroundMusicUrl)
            backgroundMusicPlayer?.numberOfLoops = -1
            backgroundMusicPlayer?.prepareToPlay()
            audioPlayers[filename] = backgroundMusicPlayer
            // Optionally adjust initial volume here
            // backgroundMusicPlayer?.volume = initialVolume
        } catch {
            print("Could not preload file: \(error)")
        }
    }
    private func fadeOutCurrentMusic(completion: @escaping () -> Void) {
        guard let player = backgroundMusicPlayer, player.isPlaying else {
            completion()
            return
        }
        let fadeDuration = 0.25
        var fadeVolume = player.volume

        let fadeStep: Float = 0.1
        let fadeInterval = fadeDuration / Double(player.volume/fadeStep)
        
        Timer.scheduledTimer(withTimeInterval: fadeInterval, repeats: true) { timer in
            fadeVolume -= Float(fadeStep)
            if fadeVolume <= 0 {
                player.stop()
                player.volume = 1.0 // Reset volume or adjust according to your game settings
                timer.invalidate()
                completion()
            } else {
                player.volume = fadeVolume
            }
        }
    }

}
