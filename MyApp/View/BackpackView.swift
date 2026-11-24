//  BackpackView.swift
//  MyApp
//
//  Created by Fan Yiming on 2026-11-04.
//  GitHub Copilot made the backpack contents view reusable from level-completion rewards.

import SwiftUI

struct BackpackView: View {
    @State private var showsContents = false
    let items: [WheelPrize]

    var body: some View {
        Button {
            showsContents = true
        } label: {
            Label("\(items.count)", systemImage: "bag.fill")
                .font(.title3.bold())
                .foregroundStyle(.brown)
                .padding(.horizontal, 15)
                .padding(.vertical, 12)
                .background(.regularMaterial, in: Capsule())
                .overlay {
                    Capsule()
                        .stroke(.brown.opacity(0.25), lineWidth: 1)
                }
        }
        .accessibilityLabel("Backpack: \(items.count) item\(items.count == 1 ? "" : "s")")
        // Present the collection without navigating away from the current map or activity.
        .sheet(isPresented: $showsContents) {
            BackpackContentsView(items: items)
        }
    }
}

struct BackpackContentsView: View {
    @Environment(\.dismiss) private var dismiss
    let items: [WheelPrize]

    var body: some View {
        NavigationStack {
            Group {
                // Give an empty-state explanation until the player has earned a prize.
                if items.isEmpty {
                    ContentUnavailableView(
                        "Backpack is empty",
                        systemImage: "bag",
                        description: Text("Earn items from learning activities to add them here.")
                    )
                } else {
                    List(items) { item in
                        Label(item.title, systemImage: item.icon)
                            .foregroundStyle(item.color)
                    }
                }
            }
            .navigationTitle("Backpack")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done", action: dismiss.callAsFunction)
                }
            }
        }
    }
}
