//
//  ContentView.swift
//  SwiftJan31
//
//  Created by Minsang Choi on 1/31/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var octaves : CGFloat = 1
    @State private var progress : CGFloat = 12
    @State private var dragp = CGPoint(x:150,y:0)

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack{
                Text("Introducing DeepSeek LLM, an advanced language model comprising 67 billion parameters. It has been trained from scratch on a vast dataset of 2 trillion tokens in both English and Chinese. In order to foster research, we have made DeepSeek LLM 7B/67B Base and DeepSeek LLM 7B/67B Chat open source for the research community. \n\n We release the DeepSeek LLM 7B/67B, including both base and chat models, to the public. To support a broader and more diverse range of research within both academic and commercial communities, we are providing access to the intermediate checkpoints of the base model from its training process. Please note that the use of this model is subject to the terms outlined in License section. Commercial usage is permitted under these terms.")
                    .foregroundStyle(.white)
                    .font(.system(size: 24))
            }
            .frame(width:380,height:500)
            .blur(radius:1)
            .layerEffect(ShaderLibrary.fbm(.boundingRect, .float2(dragp), .float(progress), .float(octaves)), maxSampleOffset: CGSize(width:0,height:50))
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragp = value.location
                        }
                            
                )
                .mask(
                    Circle()
                        .blur(radius: 20)
                )
        
            
            VStack{
             Spacer()
                HStack{
                    Text("x : \(dragp.x, specifier: "%.0f")")
                        .foregroundStyle(.white)
                        .font(.system(size:14, design: .monospaced))

                    Text("y : \(dragp.y, specifier: "%.0f")")
                        .foregroundStyle(.white)
                        .font(.system(size:14, design: .monospaced))

                }

                HStack{
                    Text("Octaves : \(octaves, specifier: "%.0f")")
                        .foregroundStyle(.white)
                        .font(.system(size:14, design: .monospaced))
                    Slider(value:$octaves, in:0...7, step:0.01)
                        .tint(.white)
                }
                HStack{
                    Text("Progress : \(progress, specifier: "%.0f")")
                        .foregroundStyle(.white)
                        .font(.system(size:14, design: .monospaced))
                    Slider(value:$progress, in:0...44, step:0.01)
                        .tint(.white)
                }

                
            }
            .padding()
        }
    }
    func ease(_ t: Double, exponent: Double) -> Double {
        // This function uses a common parameterized easing formula:
        // f(t) = t^exponent / (t^exponent + (1-t)^exponent)
        let numerator = pow(t, exponent)
        let denominator = numerator + pow(1 - t, exponent)
        return denominator == 0 ? 0 : numerator / denominator
    }

}

#Preview {
    ContentView()
}
