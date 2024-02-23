//
//  MessageNotification .swift
//  MathShooter29
//
//  Created by วรัญพงษ์ สุทธิพนไพศาล on 19/2/2567 BE.
//

import SwiftUI

struct MessageNotification_: View {
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack(alignment: .center){
                //Rectangle()
                  //  .opacity(0.8)
                HStack{
                    VStack{
                        Text("Please")
                        Text("click the button to play.")
                    }
                    .font(.headline)
                    Image(systemName: "arrowshape.right")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                .foregroundColor(.green)
                .font(.custom("", size: 20))
                .shadow(color: .white, radius: 20, x: 0, y: 0)
            }.position(CGPoint(x: geometry.size.width/2, y: geometry.size.height/2))
        })
    }
}

#Preview {
    MessageNotification_()
}
