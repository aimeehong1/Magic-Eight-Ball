//
//  ContentView.swift
//  Predict
//
//  Created by Aimee Hong on 9/16/24.
//

import SwiftUI

struct ContentView: View {
    @State private var prediction = ""
    @State private var choicesArray = ["It is certain",
                                       "It is decidedly so",
                                       "Without a doubt",
                                       "Yes, definitely",
                                       "You may rely on it",
                                       "As I see it, yes",
                                       "Most likely",
                                       "Outlook good",
                                       "Yes",
                                       "Signs point to yes",
                                       "Reply hazy try again",
                                       "Ask again later",
                                       "Better not tell you now",
                                       "Cannot predict now",
                                       "Concentrate and ask again",
                                       "Don't count on it",
                                       "My reply is no",
                                       "My sources say no",
                                       "Outlook not so good",
                                       "Very doubtful"]
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                Image("predict-ball-image")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350)
                
                Circle()
                    .foregroundColor(.indigo)
                    .frame(width: 140, height: 140)
                    .offset(y: -20)
                
                Text(prediction)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.4)
                    .foregroundStyle(.white)
                    .frame(width: 100, height: 100)
                    .offset(y: -20)
                    .animation(.default, value: prediction)
            }
            
            Spacer()
            
            Button("Predict!") {
                prediction = choicesArray.randomElement() ?? "No choices available"
            }
            .font(.title2)
            .buttonStyle(.borderedProminent)
            .tint(.indigo)
        }
        .padding()
        .onShake {
            prediction = choicesArray.randomElement() ?? "No choices available"
        }
    }
}

extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

//  Override the default behavior of shake gestures to send our notification instead.
extension UIWindow {
     open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
     }
}

// A view modifier that detects shaking and calls a function of our choosing.
struct DeviceShakeViewModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                action()
            }
    }
}

// A View extension to make the modifier easier to use.
extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        self.modifier(DeviceShakeViewModifier(action: action))
    }
}

#Preview {
    ContentView()
}
