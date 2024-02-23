import SwiftUI
import Charts
import AVFoundation
import Accelerate

enum Constants {
    static let updateInterval = 0.03
    static let barAmount = 40
    static let magnitudeLimit: Float = 32
}

class Music_Manager: NSObject, ObservableObject {
    static var shared: Music_Manager = .init()
    private var engine: AVAudioEngine
    var player: AVAudioPlayerNode
    private var currentPlaying: AVAudioPlayerNode?
    var audioFile: AVAudioFile?
    
    @Published var NameMusic: Int = 0
    let listName: [String] = ["infinity-", "Hitman", "gameMain", "neon-gaming"]
    
    @Published var trackVolumes: [String: Float] = [:]
    
    private let bufferSize: AVAudioFrameCount = 1024
    var fftMagnitudes: [Float] = []
    
    override init() {
        engine = AVAudioEngine()
        player = AVAudioPlayerNode()
        super.init()
        configureAudioSession()
        prepareAudioEngine()
        loadInitialAudioFile()
        setupFFT()
    }
    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error.localizedDescription)")
        }
    }
    
    private func prepareAudioEngine() {
        engine.attach(player)
        engine.connect(player, to: engine.mainMixerNode, format: nil)
        engine.prepare()
        
        do {
            try engine.start()
        } catch {
            print("Could not start audio engine: \(error.localizedDescription)")
        }
    }
    
    private func loadInitialAudioFile() {
        guard let url = Bundle.main.url(forResource: "neon-gaming", withExtension: "mp3") else {
            print("Error: File neon-gaming.mp3 not found in the main bundle.")
            return
        }
        
        do {
            audioFile = try AVAudioFile(forReading: url)
        } catch {
            print("Error occurred while trying to create AVAudioFile: \(error.localizedDescription)")
        }
    }
    
    private func setupFFT() {
        let fftSetup = vDSP_DFT_zop_CreateSetup(nil, UInt(bufferSize), vDSP_DFT_Direction.FORWARD)
        
        engine.mainMixerNode.installTap(onBus: 0, bufferSize: bufferSize, format: nil) { [weak self] buffer, _ in
            guard let self = self, let fftSetup = fftSetup else { return }
            let channelData = buffer.floatChannelData?[0]
            self.fftMagnitudes = self.fft(data: channelData!, setup: fftSetup)
        }
    }
    func fft(data: UnsafeMutablePointer<Float>, setup: OpaquePointer) -> [Float] {
        var realIn = [Float](repeating: 0, count: Int(bufferSize))
        var imagIn = [Float](repeating: 0, count: Int(bufferSize))
        var realOut = [Float](repeating: 0, count: Int(bufferSize))
        var imagOut = [Float](repeating: 0, count: Int(bufferSize))
        
        for i in 0 ..< bufferSize {
            realIn[Int(i)] = data[Int(i)]
        }
        
        vDSP_DFT_Execute(setup, &realIn, &imagIn, &realOut, &imagOut)
        
        var magnitudes = [Float](repeating: 0, count: Constants.barAmount)
        
        realOut.withUnsafeMutableBufferPointer { realBP in
            imagOut.withUnsafeMutableBufferPointer { imagBP in
                var complex = DSPSplitComplex(realp: realBP.baseAddress!, imagp: imagBP.baseAddress!)
                vDSP_zvabs(&complex, 1, &magnitudes, 1, UInt(Constants.barAmount))
            }
        }
        
        var normalizedMagnitudes = [Float](repeating: 0.0, count: Constants.barAmount)
        var scalingFactor = Float(1)
        vDSP_vsmul(&magnitudes, 1, &scalingFactor, &normalizedMagnitudes, 1, UInt(Constants.barAmount))
        
        return normalizedMagnitudes
    }
    // Existing FFT, playMusic, stopAllMusic, and updateVolume methods...
}

// Music_Manager extension methods...

extension Music_Manager {
    func playMusic(trackIndex: Int) {
        let trackName = listName[trackIndex]
        guard let fileURL = Bundle.main.url(forResource: trackName, withExtension: "mp3"),
              let file = try? AVAudioFile(forReading: fileURL) else {
            print("Error: File not found.")
            return
        }
        currentPlaying?.stop()
        player.scheduleFile(file, at: nil, completionHandler: nil)
        player.volume = trackVolumes[trackName] ?? 1.0
        player.play()
        currentPlaying = player
    }
    func stopAllMusic() {
        player.stop()
        currentPlaying?.stop()
        currentPlaying = nil
    }
    func updateVolume(trackName: String, level: Float) {
        trackVolumes[trackName] = level
        if trackName == listName[NameMusic] {
            player.volume = level
        }
    }
}

struct MusicManager: View {
    @ObservedObject var model = Music_Manager()
    @EnvironmentObject var game_Data: gameData
    //@Binding var status: Int
    
    let audioProcessing1 = Music_Manager.shared
    let timer = Timer.publish(
        every: Constants.updateInterval,
        on: .main,
        in: .common
    ).autoconnect()

    @State var isPlaying = false
    @State var currentlyPlayingIndex: Int? = nil
    @State var data: [Float] = Array(repeating: 0, count: Constants.barAmount)
        .map { _ in Float.random(in: 1 ... Constants.magnitudeLimit) }
    var body: some View {
        GeometryReader{ sizeIn in
            VStack{
                Text("Music View")
                    .foregroundColor(.white)
                    .font(.custom("Chalkduster", size: 30))
                    .foregroundColor(.black)
                    .shadow(color: .white.opacity(0.8), radius: 10, x: 0, y: 0)
                    .padding()
                Text("Music visualized as dynamic, flowing colors, echoing the melody's rhythm")
                    .foregroundColor(.white)
                    .font(.custom("Chalkduster", size: 10))
                    .foregroundColor(.black)
                    .shadow(color: .white.opacity(0.5), radius: 10, x: 0, y: 0)
                
                Chart(Array(data.enumerated()), id: \.0) { index, magnitude in
                    BarMark(
                        x: .value("Frequency", String(index)),
                        y: .value("Magnitude", magnitude)
                    )
                    .foregroundStyle(
                        Color(
                            hue: 0.3 - Double((magnitude / Constants.magnitudeLimit) / 5),
                            saturation: 1,
                            brightness: 1,
                            opacity: 0.7
                        )
                    )
                }
                .onReceive(timer, perform: updateData)
                .chartYScale(domain: 0 ... Constants.magnitudeLimit)
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .frame(width: sizeIn.size.width/1.5 ,height: 100)
                .padding()
                .background(
                    .black
                        .opacity(0.3)
                        .shadow(.inner(radius: 20))
                )
                .cornerRadius(10)
                
                ForEach(0..<model.listName.count, id: \.self) { index in
                    Button(action: { playMusic(trackName: audioProcessing1.listName[index]) }) {
                        HStack(spacing: 20){
                            Text(audioProcessing1.listName[index])
                                .foregroundColor(.white)
                                .frame(width: 100)

                            Image(systemName: currentlyPlayingIndex == index && isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                            
                        }
                    }
                    //.padding()
                }

                .padding(10)
                Button(action: stopButtonTapped) {
                    Text("Stop Music")
                        .foregroundColor(.black)
                        .font(.system(size: 20, weight: .regular))
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: .white.opacity(0.6), radius: 10, x: 0, y: 0)
                }
                .padding()
                Button{
                    game_Data.status = 4
                    audioProcessing1.stopAllMusic()
                    isPlaying = false
                    //status = 4
                } label: {
                    Text("Back")
                        //.padding(.bottom,10)
                        .foregroundColor(.black)
                        .font(.system(size: 20, weight: .regular))
                        .padding()
                        .background(.white.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: .white, radius: 10, x: 0, y: 0)
                }
                
            }
            .position(CGPoint(x: sizeIn.size.width/2, y: sizeIn.size.height/2))
        }
    }
    func updateData(_: Date) {
        if isPlaying {
            withAnimation(.easeOut(duration: 0.08)) {
                data = audioProcessing1.fftMagnitudes.map {
                    min($0, Constants.magnitudeLimit)
                }
            }
        }
    }
    func playMusic(trackName: String) {
        if let trackIndex = model.listName.firstIndex(of: trackName) {
            audioProcessing1.playMusic(trackIndex: trackIndex)
            currentlyPlayingIndex = trackIndex
            isPlaying = true
        }
    }

    func stopButtonTapped() {            
        audioProcessing1.stopAllMusic()
        isPlaying = false
    }
}

#Preview {
    MusicManager()
        .environmentObject(gameData())
        .preferredColorScheme(.dark)
}
