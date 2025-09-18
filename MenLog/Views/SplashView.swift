//
//  SplashView.swift
//  MenLog
//
//  Created by 八木佑樹 on 2025/08/26.
//

import SwiftUI

struct SplashView: View {
    @State private var isLoading = true

    var body: some View {
        if isLoading {
            ZStack {
                VStack {
                    Image("LaunchImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                    Text("MenLog")
                        .font(.title)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        isLoading = false
                    }
                }
            }
        } else {
            ContentView()
        }
    }
}
