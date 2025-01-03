//
//  ParticleEffectView.swift
//  Imoji
//
//  Created by Aadi Shiv Malhotra on 1/3/25.
//

import Foundation
import SwiftUI

/// A basic floating particle effect view
struct ParticleEffectView: View {

    // MARK: - Properties

    /// Number of particles to generate
    private let count = 20

    /// A timing function to animate infinite floating
    @State private var randomOffsets: [CGSize] = []

    init() {
        _randomOffsets = State(initialValue: Array(repeating: .zero, count: count))
    }

    // MARK: - Body

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<count, id: \.self) { index in
                    Circle()
                        .fill(gradient)
                        .frame(
                            width: CGFloat.random(in: 6...14),
                            height: CGFloat.random(in: 6...14)
                        )
                        .opacity(0.15)
                        .offset(randomOffsets[index])
                        .onAppear {
                            randomOffsets[index] = randomPosition(in: geo.size)
                            animateParticle(index: index, size: geo.size)
                        }
                }
            }
        }
    }

    // MARK: - Helpers

    /// Recursively animates a particle to a new random location
    private func animateParticle(index: Int, size: CGSize) {
        withAnimation(
            .easeInOut(duration: Double.random(in: 5...8))
                .repeatForever(autoreverses: true)
        ) {
            randomOffsets[index] = randomPosition(in: size)
        }
    }

    /// Generates a random offset within the specified size
    private func randomPosition(in size: CGSize) -> CGSize {
        let randomX = CGFloat.random(in: -size.width / 2...size.width / 2)
        let randomY = CGFloat.random(in: -size.height / 2...size.height / 2)
        return CGSize(width: randomX, height: randomY)
    }

    /// Gradient to color the particles
    private var gradient: LinearGradient {
        LinearGradient(
            colors: [.blue.opacity(0.3), .pink.opacity(0.3), .purple.opacity(0.3)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
