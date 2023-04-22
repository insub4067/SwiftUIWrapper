//
//  StackView.swift
//  SwiftUIWrapperVC
//
//  Created by insub on 2023/04/22.
//

import SwiftUI

struct StackView: NavigatableView {
    
    var navigator: VCNavigator?
    
    var body: some View {
        VStack(spacing: 16) {
            Text("StackView")
                .font(.title)
            Button {
                didTapDismiss()
            } label: {
                Text("dismiss")
            }
        }
        
    }
    
    func didTapDismiss() {
        navigator?.dismiss()
    }
}

struct StackView_Previews: PreviewProvider {
    static var previews: some View {
        StackView()
    }
}
