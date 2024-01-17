//
//  ListEmptyView.swift
//  Github
//
//  Created by FMI-PC-LT-48 on 15/01/2024.
//

import Foundation
import SwiftUI

struct MessageView: View {
    let message: String

    var body: some View {
            Text(message)
                .font(.callout)
                .multilineTextAlignment(.center)
                .padding(.bottom, 40).padding()
    }
}
