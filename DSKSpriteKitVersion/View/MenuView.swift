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
    @State private var fadeOverlayOpacity: Double = 1.0 // start fully white
    
    // --- NEW: State variable to hold the high score ---
    @State private var highScore: Int = 0
    
    public var body: some View {
        ZStack {
            Image("Background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(0.8)
                    .frame(maxHeight: 150)
                    .padding(.top, 80)
                    .offset(y: animate ? -200 : 0)
                
                // --- MODIFIED: Display High Score with a thin font ---
                if highScore > 0 {
                    Text("High Score: \(highScore)")
                        .font(.system(size: 30, weight: .light, design: .default))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
                        .padding(.top, 10)
                        .offset(y: animate ? -200 : 0) // Animate with the logo
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        animate = true
                        showWhiteboi = false
                    }
                    
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
                .allowsHitTesting(false) // Allow taps to pass through
        }
        .onAppear {
            // Fade out the white overlay
            withAnimation(.easeInOut(duration: 1.0)) {
                fadeOverlayOpacity = 0.0
            }
            
            // --- NEW: Load the high score when the view appears ---
            highScore = SaveManager.shared.loadHighScore()
        }
    }
}

#Preview {
    RootView()
}
