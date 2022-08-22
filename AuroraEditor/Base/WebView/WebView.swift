//
//  WebView.swift
//  AuroraEditor
//
//  Created by TAY KAI QUAN on 21/8/22.
//  Copyright © 2022 Aurora Company. All rights reserved.
//

import Foundation
import SwiftUI
import WebKit

// UIViewRepresentable, wraps UIKit views for use with SwiftUI
struct WebView: NSViewRepresentable {
    typealias NSViewType = NSView

    @Binding
    var pageURL: URL? // Page to load

    @Binding
    var updateType: UpdateType

    @Binding var canGoBack: Bool
    @Binding var canGoForward: Bool

    enum UpdateType {
        case refresh
        case back
        case forward
        case none
    }

    func makeNSView(context: Context) -> NSView {
        let webKitView = WKWebView()
        webKitView.navigationDelegate = context.coordinator

        // load the initial page
        if let pageURL = pageURL {
            let request = URLRequest(url: pageURL)
            webKitView.load(request)
        }

        return webKitView
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        // make sure web view and page url exist, and add a delegate
        guard let webView = nsView as? WKWebView, let pageURL = pageURL else { return }
        webView.navigationDelegate = context.coordinator

        // if the url is different from the webview's url, load the new page
        if let currentURL = webView.url, currentURL != pageURL {
            let request = URLRequest(url: pageURL)
            webView.load(request)     // Send the command to WKWebView to load our page
        }

        // if there was an update (eg. refres, back, forward) then do the relevant action
        switch updateType {
        case .refresh:
            webView.reload()
        case .back:
            webView.goBack()
        case .forward:
            webView.goForward()
        case .none:
            break // nothing to do on none
        }

        // set updateType back to none
        if updateType != .none { DispatchQueue.main.async {
            updateType = .none
        }}
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.pageURL = webView.url
            parent.canGoForward = webView.canGoForward
            parent.canGoBack = webView.canGoBack
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
