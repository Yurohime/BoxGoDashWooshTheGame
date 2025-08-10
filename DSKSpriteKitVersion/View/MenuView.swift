//
//  MenuView.swift
//  DSKSpriteKitVersion
//
//  Created by Alberto Halim Limantoro on 09/08/25.
//


import SwiftUI

public struct MenuView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var animate = false
    @State private var showWhiteboi = true
    @State private var fadeOverlayOpacity: Double = 1.0 // Start fully white
    @State private var highScore: Int = 0

    public var body: some View {
        ZStack {
            // Background
            Image("Background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                // Logo
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(0.8)
                    .frame(maxHeight: 150)
                    .padding(.top, 80)
                    .offset(y: animate ? -200 : 0)
                
                // High score
                if highScore > 0 {
                    Text("High Score: \(highScore)")
                        .font(.system(size: 30, weight: .light))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
                        .padding(.top, 10)
                        .offset(y: animate ? -200 : 0)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
                
                Spacer()
                
                // Play button
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        animate = true           // Move logo & button
                        showWhiteboi = false
                        fadeOverlayOpacity = 1.0 // Fade to white at same time
                    }
                    
                    // Switch to game after fade finishes
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        viewRouter.currentPage = "game"
                    }
                }) {
                    ZStack {
                        Image("Button Play")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 400, height: 160)
                            .offset(y: 15)
                        
                        if showWhiteboi {
                            Image("Whiteboi")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                        }
                    }
                    .offset(y: animate ? 300 : 125)
                }
                .buttonStyle(.plain)
                
                Spacer()
            }
            
            // White fade overlay
            Color.white
                .ignoresSafeArea()
                .opacity(fadeOverlayOpacity)
                .allowsHitTesting(false)
        }
        .onAppear {
            // Fade in from white
            withAnimation(.easeInOut(duration: 1.0)) {
                fadeOverlayOpacity = 0.0
            }
            highScore = SaveManager.shared.loadHighScore()
        }
    }
}

#Preview {
    RootView()
}
