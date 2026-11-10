//
//  ContentView.swift
//  MyApp
//
//  Created by Fan Yiming on 2026-11-04.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = AppViewModel()

    var body: some View {
        Group {
            if viewModel.showsMap {
                GameMapView(
                    avatar: viewModel.avatar,
                    onOpenWardrobe: viewModel.openWardrobe
                )
            } else {
                WardrobeView(viewModel: viewModel, onReady: viewModel.enterMap)
            }
        }
        .animation(.easeInOut, value: viewModel.showsMap)
    }
}

#Preview {
    ContentView()
}
