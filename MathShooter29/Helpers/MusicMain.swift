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
                player.currentTime = 0
                player.play()
            }
        } else {
            prepareBackgroundMusic(filename: filename)
        }
    }

    func stopBackgroundMusic() {
        audioPlayers.values.forEach { $0.stop() }/*
        if backgroundMusicPlayer?.isPlaying == true {
            backgroundMusicPlayer?.stop()
        }*/
    }
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
                timer.invalidate()
                completion()
            } else {
                player.volume = fadeVolume
            }
        }
    }
}
//effect main game
class Effect {
    var audioPlayerNode = AVAudioPlayerNode()
    var audioPitchTime = AVAudioUnitTimePitch()
    var audioFile:AVAudioFile
    var audioBuffer:AVAudioPCMBuffer
    var name:String
    var engine:AVAudioEngine
    var isPlaying = false
    
    init?(forSound sound:String, withEngine avEngine:AVAudioEngine) {
        do {
            audioPlayerNode.stop()
            name = sound
            engine = avEngine
            let soundFile = NSURL(fileURLWithPath: Bundle.main.path(forResource: sound, ofType: "wav")!) as URL
            try audioFile = AVAudioFile(forReading: soundFile)
            if let buffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: AVAudioFrameCount(audioFile.length)) {
                audioBuffer = buffer
                try audioFile.read(into: audioBuffer)
                engine.attach(audioPlayerNode)
                engine.attach(audioPitchTime)
                engine.connect(audioPlayerNode, to: audioPitchTime, format: audioBuffer.format)
                engine.connect(audioPitchTime, to: engine.mainMixerNode, format: audioBuffer.format)
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    func play(pitch:Float, speed:Float, volume: Float) {
        if !engine.isRunning {
            engine.reset()
            try! engine.start()
        }
        audioPlayerNode.volume = volume
        audioPlayerNode.play()
        audioPitchTime.pitch = pitch
        audioPitchTime.rate = speed
        audioPlayerNode.scheduleBuffer(audioBuffer) {
            self.isPlaying = false
        }
        isPlaying = true
    }
}

class Sounds {
    let engine = AVAudioEngine()
    var effects:[Effect] = []
    
    func getEffect(_ sound:String) -> Effect? {
        if let effect = effects.first(where: {return isReady($0,sound)}) {
            return effect
        } else {
            if let newEffect = Effect(forSound: sound, withEngine: engine) {
                effects.append(newEffect)
                return newEffect
            } else {
                return nil
            }
        }
    }
    
    func isReady(_ effect:Effect, _ sound:String) -> Bool {
        return effect.name == sound && effect.isPlaying == false
    }
    
    func preload(_ name:String) {
        let _ = getEffect(name)
    }
    
    func play(_ name:String, pitch:Float, speed:Float, volume: Float) {
        if let effect = getEffect(name) {
            effect.play(pitch: pitch, speed: speed, volume: volume)
        }
    }
    
    func play(_ name:String, volume: Float) {
        play(name, pitch: 0.0, speed: 1.0, volume: volume)
    }
    
    func play(_ name:String, pitch:Float, volume: Float) {
        play(name, pitch: pitch, speed: 1.0, volume: volume)
    }
    
    func play(_ name:String, speed:Float, volume: Float) {
        play(name, pitch: 0.0, speed: speed, volume: volume)
    }
    func disposeSounds() {
        effects = []
    }
}

