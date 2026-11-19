//
//  ContentView.swift
//  MyApp
//
//  Created by Fan Yiming on 2026-11-04.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = AppViewModel()
    @State private var mapViewModel = GameMapViewModel()

    var body: some View {
        Group {
            if viewModel.showsMap {
                GameMapView(
                    viewModel: mapViewModel,
                    avatar: viewModel.avatar,
                    backpackItems: viewModel.collectedPrizes,
                    roundNumber: viewModel.roundNumber,
                    onOpenWardrobe: viewModel.openWardrobe,
                    onStartNewRound: {
                        mapViewModel = GameMapViewModel()
                        viewModel.startNewRound()
                    },
                    onPrizeWon: viewModel.collect
                )
            } else {
                WardrobeView(viewModel: viewModel, onReady: viewModel.enterMap)
            }
        }
        .animation(.easeInOut, value: viewModel.showsMap)
        .safeAreaInset(edge: .top, spacing: 0) {
            HStack {
                BackpackView(items: viewModel.collectedPrizes)
                Spacer()
                HPView()
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
            .background(.thinMaterial)
        }
    }
}

#Preview {
    ContentView()
        .environment(GameState())
}
