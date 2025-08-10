//
//  Rootview.swift
//  RoboGame
//
//  Created by Alberto Halim Limantoro on 09/07/25.
//

import SwiftUI

struct RootView: View {
    @StateObject var viewRouter = ViewRouter()
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        VStack {
            switch viewRouter.currentPage {
            case "menu":
                MenuView()
                    .environmentObject(viewRouter)
            case "game":
                GameView()
                    .environmentObject(viewRouter)
            default:
                MenuView()
                    .environmentObject(viewRouter)
            }
        }
    }
}

#Preview {
    RootView()
}
