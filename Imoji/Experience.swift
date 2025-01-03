//
//  Experience.swift
//  Imoji
//
//  Created by Aadi Shiv Malhotra on 1/3/25.
//

import SwiftUI

struct ExperienceView: View {

    // MARK: - Environment Properties

    /// Tracks current color scheme (light or dark).
    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Focus State

    /// Toggles when the user taps the text field, controlling its expansion & button visibility.
    @FocusState private var isInputFocused: Bool

    // MARK: - State Properties

    /// User's text input.
    @State private var inputText = ""

    /// Controls whether we show the squares.
    @State private var showSquares = false

    /// Holds the selected square index.
    @State private var selectedSquare: Int? = nil

    /// Indicates if we’re currently loading/generating.
    @State private var isLoading = false

    // MARK: - Color / Gradient

    /// A set of default SwiftUI colors.
    private let colors = [
        Color.blue,
        Color.purple,
        Color.indigo,
        Color.mint
    ]

    /// Main gradient used for styling.
    private var gradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(
                colors: [
                    colors[0].opacity(0.8),
                    colors[1].opacity(0.8),
                    colors[2].opacity(0.6)
                ]
            ),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // MARK: - Body

    var body: some View {
        NavigationView {
            ZStack {
                // Background layer, adapting to dark or light mode
                backgroundLayer

                VStack {
                    // Reset button shows up if squares are on screen
                    if showSquares {
                        resetButton
                    }

                    Spacer()

                    // App's primary placeholder view (big smiley, text)
                    placeholderView

                    Spacer()

                    // Show squares if toggled
                    if showSquares {
                        gridSquares
                    }

                    Spacer()

                    // Bottom text-field and actions
                    inputBar
                }
                // End of main VStack

                // Overlays loading animation if generating
                if isLoading {
                    loadingAnimation
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Private Subviews

    /// Background view that adapts to light/dark mode.
    private var backgroundLayer: some View {
        Group {
            if colorScheme == .dark {
                Color.black
                    .overlay(
                        gradient
                            .opacity(0.15)
                            .blendMode(.plusLighter)
                    )
            } else {
                Color.white
                    .overlay(
                        gradient
                            .opacity(0.1)
                            .blendMode(.plusDarker)
                    )
            }
        }
        .ignoresSafeArea()
    }

    /// Button to reset the app's state.
    private var resetButton: some View {
        HStack {
            Spacer()
            Button {
                // Animate the reset of squares, selection, and input
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    showSquares = false
                    selectedSquare = nil
                    inputText = ""
                }
            } label: {
                Image(systemName: "arrow.counterclockwise.circle.fill")
                    .font(.system(size: 28, weight: .semibold))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(gradient)
                    .shadow(color: colors[0].opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .padding(.trailing)
            .padding(.top, 8)
        }
    }

    /// Placeholder view with an emoji-like image and descriptive text.
    private var placeholderView: some View {
        VStack(spacing: 16) {
            Image(systemName: "face.smiling.fill")
                .font(.system(size: 90))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(gradient)
                .shadow(color: colors[1].opacity(0.3), radius: 15, x: 0, y: 8)
                .opacity(showSquares ? 0 : 1)
                .scaleEffect(showSquares ? 0.8 : 1)
                .animation(.spring(response: 0.6, dampingFraction: 0.7), value: showSquares)

            Text("Imagine your emoji!")
                .font(.system(size: 24, weight: .medium, design: .rounded))
                .foregroundStyle(gradient)
                .opacity(showSquares ? 0 : 1)
                .animation(.easeOut(duration: 0.3), value: showSquares)
        }
    }

    /// The grid of colored squares displayed after generation.
    private var gridSquares: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2),
            spacing: 20
        ) {
            ForEach(0..<4) { index in
                gridItem(index: index)
            }
        }
        .padding()
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    /// Single square item in the grid.
    private func gridItem(index: Int) -> some View {
        RoundedRectangle(cornerRadius: 16)
            // Manually apply a gradient fill (iOS 16 safe)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        colors[index].opacity(colorScheme == .dark ? 0.8 : 0.7),
                        colors[index].opacity(colorScheme == .dark ? 0.5 : 0.4)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        colors[index].opacity(0.3),
                        lineWidth: 1
                    )
            )
            .frame(height: 160)
            .shadow(
                color: colors[index].opacity(0.3),
                radius: selectedSquare == index ? 20 : 10,
                x: 0,
                y: selectedSquare == index ? 10 : 5
            )
            .scaleEffect(selectedSquare == index ? 1.05 : 1)
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: selectedSquare)
            .onTapGesture {
                withAnimation {
                    selectedSquare = index
                }
            }
    }

    /// Bottom HStack containing text input and actions, condensing by default & expanding on focus.
    private var inputBar: some View {
        HStack(spacing: 12) {
            // Gallery action (stubbed)
            Button {
                // TODO: Gallery action
            } label: {
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 24, weight: .semibold))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(gradient)
            }

            // Condensed or expanded text field (animated by focus state)
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(colorScheme == .dark ? .black : .white)
                    .shadow(color: Color(.systemGray4), radius: 8, x: 0, y: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(gradient, lineWidth: 1.5)
                    )
                    // Keep the height "normal" at ~44
                    .frame(height: 44)

                TextField("Describe your emoji...", text: $inputText)
                    .focused($isInputFocused)
                    .textFieldStyle(.plain)
                    // Minimal vertical padding so total height remains about 44
                    .padding(.horizontal, 16)
                    .padding(.vertical, 4)
            }
            // Width transitions from smaller to bigger on focus
            .frame(width: isInputFocused ? 220 : 120)
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isInputFocused)

            // The "send" button appears only when the text field is focused
            if isInputFocused {
                Button {
                    startGenerationAnimation()
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32, weight: .semibold))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(gradient)
                        .shadow(color: colors[1].opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .transition(.move(edge: .trailing).combined(with: .opacity))
                .disabled(inputText.isEmpty)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isInputFocused)
    }

    /// Fullscreen loading overlay with a **more flashy** swirling animation.
    private var loadingAnimation: some View {
        ZStack {
            // Full background matching the current color scheme
            colorScheme == .dark ? Color.black : Color.white

            // Swirling point animation using TimelineView
            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    let time = timeline.date.timeIntervalSince1970

                    // Slight opacity for layering effect
                    context.opacity = 0.85

                    // Increase to make it flashier
                    let points = 20

                    // Radius for swirling
                    let radius = min(size.width, size.height) * 0.35

                    // Calculate center of the canvas
                    let center = CGPoint(x: size.width / 2, y: size.height / 2)

                    // Draw each point
                    for i in 0..<points {
                        let angle = 2 * .pi * Double(i) / Double(points)
                        // Faster swirl speed
                        let phase = time * 4 + Double(i) / Double(points) * 2 * .pi

                        // Sinusoidal scale for each point (larger range)
                        let scale = (sin(phase) + 2) / 2.5

                        // X & Y positions based on swirling circle
                        let x = center.x + cos(angle) * radius
                        let y = center.y + sin(angle) * radius

                        // Pick a color from our array
                        let pointColor = colors[i % colors.count]

                        // Size of each ellipse
                        let rect = CGRect(
                            x: x - 6 * scale,
                            y: y - 6 * scale,
                            width: 12 * scale,
                            height: 12 * scale
                        )

                        // Draw ellipse with blur
                        context.fill(
                            Path(ellipseIn: rect),
                            with: .color(pointColor.opacity(0.7))
                        )
                        context.addFilter(.blur(radius: 6 * scale))
                    }
                }
            }

            // Subtle text while generating
            Text("generating your emoji")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(gradient)
                .opacity(0.9)
                .padding(.top, 80)
        }
        .ignoresSafeArea()
        .transition(.opacity.animation(.easeInOut(duration: 0.5)))
    }

    // MARK: - Private Methods

    /// Starts the loading animation, hides keyboard, then shows squares when complete.
    private func startGenerationAnimation() {
        withAnimation(.easeInOut(duration: 0.5)) {
            isLoading = true
        }

        // Hide keyboard and clear text
        hideKeyboard()
        inputText = ""
        isInputFocused = false

        // Fake delay to simulate "generation" time
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                isLoading = false
                showSquares = true
            }
        }
    }
}

// MARK: - SwiftUI Preview

#Preview {
    ExperienceView()
}
