//
//  PopupView.swift
//  ClipBoard
//
//  Created by Rico Penkalski on 15.04.25.
//

import SwiftUI

struct PopupView: View {
    var body: some View {
        VStack{
            Text("Your ClipBoard")
                .font(.title)
                .bold()
            Text("Here will be the content!")
        }
        .padding()
        .frame(width: 300, height: 200)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(radius: 10)
        .transition(.move(edge: .top).combined(with:.opacity))
    }
}

#Preview {
    PopupView()
}
