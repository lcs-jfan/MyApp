// ============================================================
// File: MyApp/ContentView.swift
// ============================================================
//
//  ContentView.swift
//  MyApp
//
//  Created by Fan Yiming on 2026-11-04.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

// ============================================================
// File: MyApp/MyAppApp.swift
// ============================================================
//
//  MyAppApp.swift
//  MyApp
//
//  Created by Fan Yiming on 2026-11-04.
//

import SwiftUI

@main
struct MyAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
