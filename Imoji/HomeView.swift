//
//  HomeView.swift
//  Imoji
//
//  Created by Aadi Shiv Malhotra on 1/3/25.
//

import SwiftUI

struct HomeView: View {
    
    // MARK: - Navigation State
    @State private var navigateToContentView = false
    @State private var navigateToExperienceView = false
    
    // MARK: - Gradient
    private var gradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue, Color.purple]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                gradient
                    .ignoresSafeArea()
                    .overlay(
                        Color.black.opacity(0.3)
                    )
                
                VStack(spacing: 40) {
                    Text("Welcome to Imoji")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                        .padding(.bottom, 30)
                    
                    // ContentView Button
                    Button {
                        navigateToContentView = true
                    } label: {
                        Text("Go to Content")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.2))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                                    )
                                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                            )
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .scaleEffect(navigateToContentView ? 1.05 : 1)
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: navigateToContentView)
                    
                    // ExperienceView Button
                    Button {
                        navigateToExperienceView = true
                    } label: {
                        Text("Go to Experience")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.2))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                                    )
                                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                            )
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .scaleEffect(navigateToExperienceView ? 1.05 : 1)
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: navigateToExperienceView)
                    
                    Spacer()
                }
            }
            // Navigation Destination
            .background(
                NavigationLink(destination: ContentView(), isActive: $navigateToContentView) {
                    EmptyView()
                }
                .hidden()
            )
            .background(
                NavigationLink(destination: ExperienceView(), isActive: $navigateToExperienceView) {
                    EmptyView()
                }
                .hidden()
            )
        }
    }
}

// MARK: - Preview
#Preview {
    HomeView()
}
