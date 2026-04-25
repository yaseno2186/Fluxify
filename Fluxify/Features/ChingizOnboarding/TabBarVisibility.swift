//
//  TabBarVisibility.swift
//  Fluxify
//
//  Created by Yass on 25.04.26.
//
import SwiftUI
internal import Combine

class TabBarVisibility: ObservableObject {
    static let shared = TabBarVisibility()
    @Published var isVisible: Bool = true
    private init() {}
}

