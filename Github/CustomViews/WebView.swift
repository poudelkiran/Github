//
//  WebView.swift
//  Github
//
//  Created by FMI-PC-LT-48 on 15/01/2024.
//

import SwiftUI
import WebKit

struct LoadingWebView: View {
    
    @State private var isLoading = true
    let url: URL?
    
    var body: some View {
        ZStack {
            if let url = url {
                WebView(url: url, isLoading: $isLoading)
                    .edgesIgnoringSafeArea(.all)
                if isLoading {
                    ProgressView()
                }
            }
        }
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    func makeUIView(context: Context) -> WKWebView  {
        let wkwebView = WKWebView()
        wkwebView.navigationDelegate = context.coordinator
        
        wkwebView.load(URLRequest(url: url))
        return wkwebView
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        init(_ parent: WebView) {
            self.parent = parent
        }
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }
    }
}
