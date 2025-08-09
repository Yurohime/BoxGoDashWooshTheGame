//
//  GameView.swift
//  DSKSpriteKitVersion
//
//  Created by Alberto Halim Limantoro on 09/08/25.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    var body: some View {
        SpriteView(scene: makeGameScene())
            .ignoresSafeArea()
    }
    
    func makeGameScene() -> SKScene {
        let scene = GameScene()
        scene.size = UIScreen.main.bounds.size
        scene.scaleMode = .resizeFill
        return scene
    }
}

#Preview {
    GameView()
}
