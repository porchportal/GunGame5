//
//  BackgroundPlayer.swift
//  MathShooter29
//
//  Created by วรัญพงษ์ สุทธิพนไพศาล on 5/2/2567 BE.
//
import SwiftUI
import Combine

class Debouncer {
    private var timer: Timer?

    func debounce(interval: TimeInterval, action: @escaping () -> Void) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false, block: { _ in action() })
    }
}

struct BackgroundPlayer: View {
    struct Position {
        var coords : CGSize = .zero
        var angle : Double = 0
        var speed = CGSize()
        var time : Double = 1
    }
    init (refreshRate: Double){
        self.refreshInterval = 1 / refreshRate
        self.timer = Timer.publish(every: refreshInterval, tolerance: 0, on: .current, in: .common).autoconnect()
        
        self.speed = CGFloat(refreshInterval * 10)
        self.tailFadeSpeed = Double(refreshInterval * 10)
        self.AngleSpeedDefault = Double(refreshRate * 3)
    }
    var refreshInterval: Double = 120
    let speed : CGFloat
    var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    let tailFadeSpeed : Double
    let AngleSpeedDefault : Double
    
    @State var coords : CGSize = .zero
    @State var angle : Double = 0
    @State var tailIndex = 0
    @State var counter = 0
    @State var maxOffset = CGSize()
    @State var offset : CGSize = .zero
    @State var isTapped = false
    let threshold: CGFloat = 5.0 
    let tailCount = 5
    let tailSize = 20
    let tailFluctuation : CGFloat = 2
    let gameObjRadius : CGFloat = 30
    @State var gameFrame = CGRect()
    let debouncer = Debouncer()
    @State var tail : [Position] = []
    
    var body: some View {
        VStack{
            ZStack{
                ZStack{
                    Rectangle()
                        .size(CGSize(width: gameFrame.width/3, height: -gameFrame.width/3))
                        .offset(CGSize(width: gameFrame.width/3, height: -gameFrame.width/3))

                }
                ZStack{
                    ForEach(tail.indices, id: \.self){ id in
                        RadialGradient(gradient:
                                        Gradient(colors: [.red, .red, .yellow, .clear]),
                                       center: .center,
                                       startRadius: 0,
                                       endRadius: gameObjRadius)
                        .frame(width: gameObjRadius*2, height: gameObjRadius*2)
                        .scaleEffect(x: 1,
                                     y: 1 + tail[id].speed.length()*CGFloat(0.03),
                                     anchor: .init(x: 0.5, y: 0))
                        .rotationEffect(Angle(radians: tail[id].angle))
                        .offset(tail[id].coords)
                        .opacity(tail[id].time * CGFloat(0.2))
                    }
                    Circle()
                        .fill(RadialGradient(gradient: Gradient(colors: [.white, .cyan, .blue]), center: .center, startRadius: 0, endRadius: gameObjRadius))
                        .frame(width: gameObjRadius*2, height: gameObjRadius*2)
                        .overlay(
                            Capsule(style: RoundedCornerStyle.circular)
                                .fill(Color.red)
                                .frame(width: gameObjRadius / 2, height: gameObjRadius / 1.5)
                            , alignment: .top)
                        .rotationEffect(Angle(radians: angle),
                                        anchor: .center)
                        .offset(coords)
                        .opacity(0.5)
                }
            }
            .onReceive(timer){time in
                
                let randomOffset = CGSize(width: CGFloat.random(in: -8...8), height: CGFloat.random(in: -8...8))
                let controlledOffset = isTapped ? offset : CGSize.zero
                
                let newCoords = coords + ((controlledOffset + randomOffset) * speed)
                if abs(newCoords.width) < maxOffset.width {
                    coords.width = newCoords.width
                }
                if abs(newCoords.height) < maxOffset.height {
                    coords.height = newCoords.height
                }
                //self.coords += offset
                let pi = Double.pi
                let length = offset.length()
                
                if length > 0{
                    let newAngle = Double(atan2(offset.height, offset.width)) + pi / 2
                    var deltaAngle = newAngle - angle.truncatingRemainder(dividingBy: 2 * pi)
                    if deltaAngle > pi{
                        deltaAngle = deltaAngle - 2 * pi
                    }
                    if deltaAngle < -pi{
                        deltaAngle = deltaAngle + 2 * pi
                    }
                    angle += deltaAngle
                }
                counter += 1
                if counter>tailCount{
                    counter = 0
                    for i in tail.indices{
                        tail[i].time -= tailFadeSpeed
                    }
                    tailIndex += 1
                    if tailIndex == tail.endIndex{
                        tailIndex = 0
                    }
                    
                    if length > 0 {
                        tail[tailIndex] = Position(coords:
                                                    CGSize(width: coords.width + CGFloat.random(in: -tailFluctuation...tailFluctuation),
                                                           height: coords.height + CGFloat.random(in: -tailFluctuation...tailFluctuation)),
                                                   angle: angle, speed: offset, time: 1)
                    }
                }
            }
            .clipShape(Rectangle())
            .overlay(
                GeometryReader { geo in
                    Color.clear
                        .preference(key: framePreferenceKey.self, value: geo.frame(in:.global))
                }.onPreferenceChange(framePreferenceKey.self){ newValue in
                    DispatchQueue.main.async {
                        if abs(gameFrame.width - newValue.width) > threshold || abs(gameFrame.height - newValue.height) > threshold {
                            //gameFrame = newValue
                            self.gameFrame = newValue
                            coords = .zero
                            
                            let x = gameFrame.width/2 - gameObjRadius
                            let y = gameFrame.height/2 - gameObjRadius
                            maxOffset = CGSize(width: x, height: y)
                        }
                    }
                }
            )
            .overlay(
                Controler(offset: $offset, isTapped: $isTapped, maxRadius: 50)
                    .foregroundColor(.accentColor)
                ,alignment: .bottomTrailing)
            .drawingGroup()
        }
        .onAppear(){
            tail = [Position](repeating: Position(coords: coords, angle: angle, time: 0), count: tailSize)
        }
    }
}
struct BackgroundPlayer1: View {
    @State var message = false
    var body: some View {
        ZStack{
            BackgroundPlayer(refreshRate: 120)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            Rectangle()
                .frame(width: 500, height: 500)
                .opacity(0.6)
            VStack{
                if message{
                    Text("Already click")
                        .font(.custom("", size: 50))
                        .foregroundColor(.blue)
                }
                Button(action: {
                    if message == false {
                        message = true
                    } else {
                        message = false
                    }
                }, label: {
                    Text("Click it")
                        .font(.custom("", size: 50))
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(30)
                        .shadow(color: .black, radius: 20, x: 0, y: 4)
                    
                })
            }
        }
    }
}
struct framePreferenceKey: PreferenceKey {
    static var defaultValue = CGRect()
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
struct Controler: View {
    
    init(offset: Binding<CGSize>, isTapped: Binding<Bool>, maxRadius: CGFloat){

        self._offset = offset
        self._isTapped = isTapped
        self.maxRadius = maxRadius
        
    }
    
    let maxRadius : CGFloat
    
    @Binding var offset: CGSize
    @Binding var isTapped: Bool
    
    @State var gestureLocation = CGSize(width: 0, height: 0)
    @State var startLocation = CGSize(width: 0, height: 0)
    @State var joystickFrame = CGRect()
    @State private var controlOffset: CGSize = .zero
    @State private var isControlTapped: Bool = false
    
    var body: some View{
        ZStack{
            if isTapped{
                ZStack{
                    Circle()
                        .fill(RadialGradient(gradient: Gradient(colors: [.clear, .white]), center: .center, startRadius: 0, endRadius: maxRadius * 1.5))
                        .frame(width: maxRadius * 3, height: maxRadius * 3)
                        .opacity(0.2)
                        .offset(startLocation)
                    Circle()
                        .fill(RadialGradient(gradient: Gradient(colors: [.white, .gray]), center: .center, startRadius: 0, endRadius: maxRadius/2))
                        .frame(width: maxRadius, height: maxRadius)
                        .shadow(radius: 5)
                        .offset(gestureLocation)
                }
            }
            Color.clear
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance:0, coordinateSpace:.global)
                        .onChanged { gesture in
                            
                            if !isTapped {
                                isTapped = true
                                
                                let startWidth = gesture.startLocation.x - joystickFrame.minX - joystickFrame.width/2
                                let startHeight = gesture.startLocation.y - joystickFrame.minY - joystickFrame.height/2
                                startLocation = CGSize(width: startWidth,
                                                       height: startHeight)
                            }
                            
                            var x = gesture.translation.width
                            var y = gesture.translation.height
                            
                            let r = gesture.translation.length()
                            
                            if r > maxRadius{
                                let q = maxRadius / r
                                x *= q
                                y *= q
                            }
                            
                            let gestLocX = gesture.startLocation.x + x - joystickFrame.minX - joystickFrame.width/2
                            let gestLocY = gesture.startLocation.y + y - joystickFrame.minY - joystickFrame.height/2
                            
                            offset = CGSize(width: x, height: y)
                            gestureLocation = CGSize(width: gestLocX, height: gestLocY)
                        }
                        .onEnded { _ in
                            
                            offset = .zero
                            isTapped = false
                        }
                )
                .overlay(
                    GeometryReader { geo in
                        Color.clear
                            .preference(key: framePreferenceKey.self, value: geo.frame(in:.global))
                    }.onPreferenceChange(framePreferenceKey.self){self.joystickFrame = $0}
                )
        }.clipShape(Rectangle())
    }
}
extension CGSize{
    func normalized() -> CGSize {
        let length = sqrt(self.width * self.width + self.height * self.height)
        guard length != 0 else { return self }
        return CGSize(width: self.width / length, height: self.height / length)
    }
    func length() -> CGFloat{
        sqrt(width * width + height * height)
    }
    static func +(lhs: CGSize, rhs: CGSize) -> CGSize{
        CGSize(
            width: lhs.width + rhs.width,
            height: lhs.height + rhs.height
        )
    }
    static func -(lhs: CGSize, rhs: CGSize) -> CGSize{
        CGSize(
            width: lhs.width - rhs.width,
            height: lhs.height - rhs.height
        )
    }
    
    static func  *(lhs: CGSize, rhs: CGFloat) -> CGSize {
        CGSize(width: lhs.width * rhs,
               height: lhs.height * rhs)
    }
    
    static func  +(lhs: CGSize, rhs: CGFloat) -> CGSize {
        CGSize(width: lhs.width + rhs,
               height: lhs.height + rhs)
    }
}

#Preview {
    BackgroundPlayer1()
}

