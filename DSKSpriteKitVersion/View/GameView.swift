import SwiftUI
import SpriteKit

struct GameView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var fadeOverlayOpacity: Double = 1.0 // start fully white

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
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()

            // White fade overlay
            Color.white
                .ignoresSafeArea()
                .opacity(fadeOverlayOpacity)
                .allowsHitTesting(false)
        }
        .onAppear {
            // Fade out the white overlay when game starts
            withAnimation(.easeInOut(duration: 1.0)) {
                fadeOverlayOpacity = 0.0
            }
        }
    }
}

#Preview {
    GameView()
}
