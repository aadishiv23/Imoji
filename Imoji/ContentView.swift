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

    /// colors
    let squareColors: [Color] = [.blue, .green, .purple, .orange]

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea(edges: .all)

                VStack {
                    Spacer()
                    placeholderView
                    Spacer()

                    if showSquares {
                        gridSquares
                    }

                    Spacer()

                    inputBar
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
            TextField("Imoji it!", text: $inputText)
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(25)
                .overlay {
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color(.systemGray6), lineWidth: 1)
                }

            Button {
                withAnimation(.spring()) {
                    showSquares = true
                    inputText = ""
                }
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(Color.blue.opacity(0.8))
            }
            .disabled(inputText.isEmpty)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
