//
//  Physics.swift
//  DSKSpriteKitVersion
//
//  Created by Alberto Halim Limantoro on 09/08/25.
//

import SpriteKit
import SwiftUI

struct PhysicsCategory {
    static let box: UInt32 = 0x1 << 0
    static let obstacle: UInt32 = 0x1 << 1
    static let wall: UInt32 = 0x1 << 2
}
