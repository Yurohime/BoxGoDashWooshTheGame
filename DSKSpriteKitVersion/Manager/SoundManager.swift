//
//  SoundManager.swift
//  Updated for overlapping + pitch variation
//
//  Created by Euginia Gabrielle on 16/07/25.
//  Created by Alberto Halim Limantoro on 10/06/25.
//

import AVFoundation

class SoundManager {
    static let shared = SoundManager()

    private var musicPlayer: AVAudioPlayer?
    
    // Keep strong references so overlapping sounds aren’t released immediately
    private var activeSFXPlayers: [AVAudioPlayer] = []

    private init() {}

    // MARK: - Background Music
    func playBGM(
        named name: String,
        fileExtension: String = "mp3",
        loop: Bool = true
    ) {
        guard let url = Bundle.main.url(forResource: name, withExtension: fileExtension) else {
            print("❌ Music file not found: \(name)")
            return
        }

        do {
            musicPlayer = try AVAudioPlayer(contentsOf: url)
            musicPlayer?.volume = BGMLevel.get()
            musicPlayer?.numberOfLoops = loop ? -1 : 0
            musicPlayer?.prepareToPlay()
            musicPlayer?.play()
        } catch {
            print("❌ Error playing music: \(error.localizedDescription)")
        }
    }

    func updateBGMVolume() {
        musicPlayer?.volume = BGMLevel.get()
    }

    func stopMusic() {
        musicPlayer?.stop()
    }

    // MARK: - Sound Effects
    func playSFX(
        named name: String,
        fileExtension: String = "mp3",
        pitchVariation: Float = 0.05 // ±5% speed change
    ) {
        guard let url = Bundle.main.url(forResource: name, withExtension: fileExtension) else {
            print("❌ SFX file not found: \(name)")
            return
        }

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = SFXLevel.get()
            player.enableRate = true

            // Apply pitch variation by changing playback rate slightly
            let randomFactor = 1.0 + Float.random(in: -pitchVariation...pitchVariation)
            player.rate = randomFactor

            player.prepareToPlay()
            player.play()

            // Keep reference until sound finishes
            activeSFXPlayers.append(player)

            // Remove from array when done
            DispatchQueue.main.asyncAfter(deadline: .now() + player.duration) { [weak self] in
                self?.activeSFXPlayers.removeAll { $0 == player }
            }
        } catch {
            print("❌ Error playing SFX: \(error.localizedDescription)")
        }
    }

    func updateSFXVolume() {
        activeSFXPlayers.forEach { $0.volume = SFXLevel.get() }
    }
}
