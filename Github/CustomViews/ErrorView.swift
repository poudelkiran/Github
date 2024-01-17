//
//  ErrorView.swift
//  Github
//
//  Created by FMI-PC-LT-48 on 12/01/2024.
//

import SwiftUI

struct ErrorView: View {
    let error: Error
    let retryAction: (() -> Void)?

    var body: some View {
        VStack {
            Text("An Error Occured")
                .font(.title)
            Text(error.localizedDescription)
                .font(.callout)
                .multilineTextAlignment(.center)
                .padding(.bottom, 40).padding()
            if let retryAction = retryAction {
                            Button(action: retryAction, label: { Text("Retry").bold() })
                        }
            
        }
    }
}

