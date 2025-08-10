//
//  AudioLevel.swift
//  DuckyDiveGame
//
//  Created by Alberto Halim Limantoro on 17/07/25.
//

class SFXLevel {
    private static var volumeLevel: Float = 0.3  // Range: 0.0 (mute) to 1.0 (full)

    class func set(_ newValue: Float) {
        volumeLevel = max(0.0, min(1.0, newValue))  // Clamp between 0 and 1
    }

    class func get() -> Float {
        return volumeLevel
    }
}

class BGMLevel {
    private static var volumeLevel: Float = 0.3  // Range: 0.0 (mute) to 1.0 (full)

    class func set(_ newValue: Float) {
        volumeLevel = max(0.0, min(1.0, newValue))  // Clamp between 0 and 1
        print("Music volume set to: \(volumeLevel)")
    }

    class func get() -> Float {
        return volumeLevel
    }
}
