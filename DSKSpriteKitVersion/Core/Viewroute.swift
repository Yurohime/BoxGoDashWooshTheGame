//
//  Viewroute.swift
//  RoboGame
//
//  Created by Alberto Halim Limantoro on 09/07/25.
//

import Combine
import SwiftUI

class ViewRouter: ObservableObject {
    @Published var currentPage: String = "menu"
    @Published var finalScore: Int = 0
}
