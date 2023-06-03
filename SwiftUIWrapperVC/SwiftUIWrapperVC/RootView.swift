//
//  RootView.swift
//  SwiftUIWrapperVC
//
//  Created by insub on 2023/04/22.
//

import SwiftUI

struct RootView: WrappableView {
    
    weak var navigator: VCNavigator?
    
    var body: some View {
        VStack(spacing: 16) {
            Text("RootView")
                .font(.title)
            Button {
                didTapButton()
            } label: {
                Text("Go to Stack View")
            }
        }
    }
    
    @MainActor func didTapButton() {
        let destination = StackView
            .init()
            .wrap()
        navigator?.push(to: destination)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
