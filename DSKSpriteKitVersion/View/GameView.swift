//
//  GameView.swift
//  DSKSpriteKitVersion
//
//  Created by Alberto Halim Limantoro on 09/08/25.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    @EnvironmentObject var viewRouter: ViewRouter

    var scene: GameScene {
        let scene = GameScene()
        scene.size = CGSize(width: 390, height: 844)
        scene.scaleMode = .fill

        // Assign game over callback
        scene.onGameOver = {
            DispatchQueue.main.async {
                viewRouter.currentPage = "menu"
            }
        }
        return scene
    }

    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
    }
}

#Preview {
    GameView()
}

