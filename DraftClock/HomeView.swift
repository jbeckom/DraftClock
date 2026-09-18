//
//  HomeView.swift
//  DraftClock
//
//  Created by Joshua Beckom on 9/18/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()
                
                VStack(spacing: 8) {
                    Text("Draft Clock")
                        .font(.system(size: 48, weight: .bold))
                    
                    Text("Keep your draft moving.")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                VStack(spacing: 16) {
                    NavigationLink {
                        DraftSetupView()
                    } label: {
                        Label("New Draft", systemImage: "plus.circle.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    
                    NavigationLink {
                        SavedDraftsPlaceholderView()
                    } label: {
                        Label("Saved Drafts", systemImage: "folder.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                }
                .frame(maxWidth: 400)
                
                Spacer()
            }
            .padding(40)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingsPlaceholderView()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
        }
    }
}

private struct SavedDraftsPlaceholderView: View {
    var body: some View {
        ContentUnavailableView(
            "No Saved Drafts",
            systemImage: "folder",
            description: Text("Saved draft configurations will appear here.")
        )
        .navigationTitle("Saved Drafts")
    }
}

private struct SettingsPlaceholderView: View {
    var body: some View {
        ContentUnavailableView(
            "Settings Coming Soon",
            systemImage: "gearshape",
            description: Text("Appearance and alert settings will be available here.")
        )
        .navigationTitle("Settings")
    }
}

#Preview {
    HomeView()
}
