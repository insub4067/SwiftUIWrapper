//
//  RootView.swift
//  SwiftUIWrapperVC
//
//  Created by insub on 2023/04/22.
//

import SwiftUI

struct RootView: NavigatableView {
    
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
    
    func didTapButton() {
        let destination = SwiftUIWrapperVC(content: StackView())
        navigator?.navigate(to: destination)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
