//
//  PopupView.swift
//  ClipBoard
//
//  Created by Rico Penkalski on 15.04.25.
//

import SwiftUI

struct PopupView: View {
    let history: [String]
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 12) {
                Text("📋 Clipboard History")
                    .font(.title2)
                    .bold()
                
                List(history, id: \.self) { entry in
                    Text(entry)
                        .font(.system(size: 16))
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(.clear)
            }
            .padding()
        }
        .background(.regularMaterial)
        .cornerRadius(16)
        .frame(width: 300, height: 210)
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}

extension PopupView {
    static let example = PopupView(history: ["Hello", "World", "This", "is", "Testing"])
}

#Preview {
    PopupView.example
}
