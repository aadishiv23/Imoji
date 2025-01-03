//
//  ContentView.swift
//  Imoji
//
//  Created by Aadi Shiv Malhotra on 1/3/25.
//

import SwiftUI

struct ContentView: View {

    // MARK: - Properties

    /// Variable holding the user input.
    @State private var inputText = ""

    /// Value controlling display of keyboard.
    @State private var isKeyboardVisible = false

    /// Controls whether to show dummy square or not.
    @State private var showSquares = false

    /// Selected dummy square.
    @State private var selectedSquare: Int? = nil

    /// Dummy loading state.
    @State private var isLoading = false

    /// Rotation angle of animation.
    @State private var rotationAngle: Double = 0

    /// colors
    let squareColors: [Color] = [.blue, .green, .purple, .orange]

    /// gradient
    let gradient = LinearGradient(
        colors: [.blue, .purple, .pink],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - Body

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea(edges: .all)

                VStack {
                    // Reset Button
                    if showSquares {
                        HStack {
                            Spacer()
                            Button {
                                withAnimation(.spring()) {
                                    showSquares = false
                                    selectedSquare = nil
                                    inputText = ""
                                }
                            } label: {
                                Image(systemName: "arrow.counterclockwise.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundStyle(gradient)
                            }
                            .padding(.trailing)
                        }
                    }

                    Spacer()
                    placeholderView
                    Spacer()

                    if showSquares {
                        gridSquares
                    }

                    Spacer()

                    inputBar
                }

                if isLoading {
                    loadingAnimation
                }
            }
        }
    }

    // MARK: - Private views

    private var placeholderView: some View {
        VStack(spacing: 12) {
            Image(systemName: "face.smiling")
                .font(.system(size: 80))
                .foregroundStyle(.blue.opacity(0.7))
                .opacity(showSquares ? 0 : 1)

            Text("Imagine your emoji!")
                .font(.title2)
                .fontWeight(.semibold)
                .opacity(showSquares ? 0 : 1)
        }
    }

    private var gridSquares: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ],
            spacing: 20
        ) {
            ForEach(0..<4) { index in
                RoundedRectangle(cornerRadius: 12)
                    .fill(squareColors[index])
                    .frame(width: 150, height: 150)
                    .shadow(radius: 5)
                    .scaleEffect(selectedSquare == index ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedSquare)
                    .transition(.scale.combined(with: .opacity))
                    .onTapGesture {
                        withAnimation {
                            selectedSquare = index
                        }
                    }
            }
            .padding()
            .transition(.opacity.combined(with: .move(edge: .bottom)))
        }
    }

    private var inputBar: some View {
        HStack(spacing: 12) {
            Button {
                // add gallery action
            } label: {
                Image(systemName: "photo.on.rectangle")
                    .font(.system(size: 32))
                    .foregroundStyle(gradient)
            }
            .padding(.horizontal, 2)

            TextField("Imoji it!", text: $inputText)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.ultraThinMaterial)
                        .overlay {
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(gradient, lineWidth: 1.2)
                        }
                )
                .overlay {
                    gradient
                        .opacity(0.05)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }

            Button {
                startGenerationAnimation() // Fixed: Changed to use the loading animation
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(gradient)
                    .shadow(color: .purple.opacity(0.3), radius: 5, x: 0, y: 2)
            }
            .disabled(inputText.isEmpty)
        }
        .padding()
    }

    private var loadingAnimation: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea(edges: .all)

            VStack(spacing: 20) {
                ZStack {
                    ForEach(0..<3) { index in
                        Image(systemName: "sparkles")
                            .font(.system(size: 100))
                            .foregroundStyle(gradient)
                            .rotationEffect(.degrees(rotationAngle + Double(index) * 120))
                            .opacity(0.8)
                    }
                }
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: rotationAngle)

                Text("Creating magic...")
                    .font(.title2)
                    .foregroundStyle(gradient)
                    .opacity(0.8)
            }
        }
        .transition(.opacity)
    }

    // MARK: - Private Methods

    private func startGenerationAnimation() {
        withAnimation {
            isLoading = true
            rotationAngle = 360
        }

        hideKeyboard()
        inputText = ""

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            withAnimation(.spring()) {
                isLoading = false
                showSquares = true
            }
        }
    }
}

#Preview {
    ContentView()
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// private var loadingAnimation: some View {
//    ZStack {
//        // Full coverage background
//        Color.black
//            .ignoresSafeArea()
//
//        // Noise pattern generator
//        TimelineView(.animation) { timeline in
//            Canvas { context, size in
//                // Dynamic parameters based on time
//                let time = timeline.date.timeIntervalSince1970
//                let baseOffset = time.remainder(dividingBy: 2.0)
//
//                // Create a grid of points
//                let gridSize: CGFloat = 20
//                let rows = Int(size.height / gridSize)
//                let cols = Int(size.width / gridSize)
//
//                for row in 0...rows {
//                    for col in 0...cols {
//                        let x = CGFloat(col) * gridSize
//                        let y = CGFloat(row) * gridSize
//
//                        // Create dynamic movement
//                        let distanceFromCenter = sqrt(
//                            pow(x - size.width / 2, 2) +
//                                pow(y - size.height / 2, 2)
//                        )
//
//                        let wave = sin(distanceFromCenter / 50 - baseOffset * 2)
//                        let size = abs(wave) * 4
//
//                        // Color based on position and time
//                        let hue = (distanceFromCenter / 500 + baseOffset).truncatingRemainder(dividingBy: 1.0)
//                        let color = Color(hue: hue, saturation: 0.7, brightness: 0.9)
//
//                        let rect = CGRect(
//                            x: x + wave * 2,
//                            y: y + wave * 2,
//                            width: size,
//                            height: size
//                        )
//
//                        context.fill(Path(ellipseIn: rect), with: .color(color))
//                    }
//                }
//            }
//        }
//
//        // Minimal text indicator
//        VStack(spacing: 20) {
//            // Custom progress indicator
//            HStack(spacing: 4) {
//                ForEach(0..<3) { index in
//                    Circle()
//                        .fill(.white)
//                        .frame(width: 4, height: 4)
//                        .opacity(0.8)
//                        .animation(
//                            Animation
//                                .easeInOut(duration: 0.4)
//                                .repeatForever()
//                                .delay(0.2 * Double(index)),
//                            value: rotationAngle
//                        )
//                }
//            }
//
//            Text("generating")
//                .font(.system(size: 14, weight: .medium, design: .monospaced))
//                .foregroundColor(.white)
//                .opacity(0.8)
//        }
//    }
//    .transition(.opacity)
// }
