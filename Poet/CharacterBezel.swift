//
//  CharacterBezel.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/24/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import SwiftUI

struct CharacterBezel: View {
    
    @State private var character: String = ""
    @State private var opacity: Double = 0
    
    var passableCharacter: PassableString
    
    init(passableCharacter: PassableString) {
        self.passableCharacter = passableCharacter
    }
    
    enum Layout {
        static var fullOpacity = 1.0
        static var zeroOpacity = 0.0
        static var fadeInDuration = 0.125
        static var fadeOutWaitInMilliseconds = Int(fadeInDuration * 1000.0) + 500
        static var fadeOutDuration = 0.7
        
        static var verticalPadding: CGFloat = 30
        static var horizontalPadding: CGFloat = 38
        static var characterFontSize: CGFloat = 128
        static var bezelCornerRadius: CGFloat = 10
        static var bezelBlurRadius: CGFloat = 12
    }
    
    var body: some View {
        VStack {
            VStack {
                Text(character)
                    .font(Font.system(size: Layout.characterFontSize))
                    .padding(EdgeInsets(
                        top: Layout.verticalPadding,
                        leading: Layout.horizontalPadding,
                        bottom: Layout.verticalPadding,
                        trailing: Layout.horizontalPadding))
            }
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.white.opacity(0.9))
                        .padding(10)
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.black.opacity(0.12))
                        .padding(10)
                    .mask(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .padding(10)
                            .opacity(0.95)
                    )
                }
                
            )
        }
        .opacity(opacity)
            .onReceive(passableCharacter.subject) { (newValue) in
                if let newValue = newValue {
                    self.character = newValue
                    withAnimation(.linear(duration: Layout.fadeInDuration)) {
                        self.opacity = Layout.fullOpacity
                    }
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now().advanced(by: .milliseconds(Layout.fadeOutWaitInMilliseconds))) {
                        withAnimation(.linear(duration: Layout.fadeOutDuration)) {
                            self.opacity = Layout.zeroOpacity
                        }
                    }
                }
        }
        .allowsHitTesting(false)
    }
}

struct CharacterBezel_Previews: PreviewProvider {
    static var previews: some View {
        CharacterBezel(passableCharacter: PassableString())
    }
}

/// Caution: I haven't yet found a way to disable user interaction on this blur view. "isUserInteractionEnabled,", even when applied to all subviews, seems to have no effect.
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemThinMaterial
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
