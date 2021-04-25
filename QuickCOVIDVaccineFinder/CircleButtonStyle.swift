//
import SwiftUI
//import Foundation

struct CircleButtonStyle: ButtonStyle {
    var bgColor: Color
  

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(10)
            .frame(minWidth : 0, maxWidth: .infinity)
            

           .background(
              //  ZStack {
                //   Rectangle()
//                        .shadow(color: .white, radius: configuration.isPressed ? 7: 10, x: configuration.isPressed ? -5: -15, y: configuration.isPressed ? -5: -15)
//                        .shadow(color: .black, radius: configuration.isPressed ? 7: 10, x: configuration.isPressed ? 5: 15, y: configuration.isPressed ? 5: 15)
                    //    .blendMode(.overlay)
          Circle()
                  .fill(bgColor)
            //  }
      )
            .scaleEffect(configuration.isPressed ? 0.95: 1)
            .foregroundColor(.primary)
            .animation(.spring())
    }
}
