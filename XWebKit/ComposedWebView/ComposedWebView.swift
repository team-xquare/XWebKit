import UIKit
import SwiftUI

import WebKit
import RxCocoa
import RxSwift
import Combine

struct ComposedWebView: UIViewRepresentable {

    @ObservedObject var state: XWebKitState

    private let refreshControl = UIRefreshControl()

    func makeCoordinator() -> WebViewCoordinator {
        WebViewCoordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {

        let webView = WKWebView(frame: CGRect.zero, configuration: generateWKWebViewConfiguration())
        webView.navigationDelegate = context.coordinator
        webView.scrollView.delegate = context.coordinator
        self.setLoadingProgress(webView: webView)
        self.setEvaluateJavaScript(webView: webView)
        self.setRefreshControl(webView: webView)
        
        if let url = URL(string: self.state.urlString) {
            print(url)
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
        }

        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) { }

}

extension ComposedWebView {

    private func generateWKWebViewConfiguration() -> WKWebViewConfiguration {

        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = false

        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences

        self.setWebCookie(cookie: [
            "accessToken": self.state.accessTokenGetter()
        ], configuration: configuration)

        self.registerBridge(name: [
            "navigate",
            "isRightButtonEnabled",
            "imageDetail",
            "back",
            "confirm",
            "error",
            "photoPicker",
            "actionSheet",
            "timePicker",
            "periodPicker"
        ], configuration: configuration)

        return configuration
    }

    private func setWebCookie(cookie: [String: String], configuration: WKWebViewConfiguration) {
        let dataStore = WKWebsiteDataStore.nonPersistent()
        cookie.forEach {
            dataStore.httpCookieStore.setCookie(HTTPCookie(properties: [
                .domain: ".xquare.app",
                .path: "/",
                .name: $0.key,
                .value: $0.value,
                .secure: "TRUE",
                HTTPCookiePropertyKey("HttpOnly"): true
            ])!)
        }
        configuration.websiteDataStore = dataStore
    }

    private func registerBridge(name: [String], configuration: WKWebViewConfiguration) {
        name.forEach {
            configuration.userContentController.add(self.makeCoordinator(), name: $0)
        }
    }
}

extension ComposedWebView {

    private func setEvaluateJavaScript(webView: WKWebView) {

        self.state.$naviagteRightButtonTap
            .compactMap { $0 }
            .sink { _ in
                print("naviagteRightButtonTap")
                self.evaluateJavaScript(
                    webView: webView,
                    bridgeName: "rightButtonTaped",
                    data: "{ }"
                )
            }
            .store(in: &self.state.cancellables)

        self.state.$alertResponse
            .combineLatest(self.state.$confirmId)
            .filter { $0.0 != nil }
            .sink {
                print($0)
                self.evaluateJavaScript(
                    webView: webView,
                    bridgeName: "confirm",
                    data: "{ id: \"\($0.1)\", success: \($0.0 ?? true) }"
                )
            }
            .store(in: &self.state.cancellables)

        self.state.$selectedImages
            .compactMap { $0 }
            .map { $0.map {
                guard let jpegData = $0.jpegData(compressionQuality: 1) else { return "" }
                return "data:image/png;base64," + jpegData.base64EncodedString()
            }}
            .combineLatest(self.state.$photoPickerId)
            .sink {
                self.evaluateJavaScript(
                    webView: webView,
                    bridgeName: "photoPicker",
                    data: "{ id: \"\($0.1)\", photos: \($0.0) }"
                )
            }
            .store(in: &self.state.cancellables)

        self.state.$selectedMenuIndex
            .combineLatest(self.state.$actionSheetId)
            .filter { $0.0 != nil }
            .sink {
                print($0)
                self.evaluateJavaScript(
                    webView: webView,
                    bridgeName: "actionSheet",
                    data: "{ id: \"\($0.1)\", index: \($0.0 ?? 0) }"
                )
            }
            .store(in: &self.state.cancellables)

        self.state.$selectedTime
            .combineLatest(self.state.$timePickerId)
            .filter { $0.0 != "" }
            .sink {
                print("timePicker")
                self.evaluateJavaScript(
                    webView: webView,
                    bridgeName: "timePicker",
                    data: "{ id: \"\($0.1)\", time: \"\($0.0)\" }"
                )
            }
            .store(in: &self.state.cancellables)

        self.state.$selectedPeriod
            .combineLatest(self.state.$periodPickerId)
            .filter { $0.0 != nil }
            .sink {
                print("periodPicker")
                self.evaluateJavaScript(
                    webView: webView,
                    bridgeName: "periodPicker",
                    data: "{ id: \"\($0.1)\", period: \($0.0 ?? 1) }"
                )
            }
            .store(in: &self.state.cancellables)

    }

    private func evaluateJavaScript(webView: WKWebView, bridgeName: String, data: String) {
        DispatchQueue.main.async {
            webView.evaluateJavaScript(
                """
                window.dispatchEvent(new CustomEvent('\(bridgeName)XBridge', {
                    detail: \(data)
                }));
                """
            )
        }
    }

    private func setLoadingProgress(webView: WKWebView) {
        Task {
            let progress = webView.rx.estimatedProgress.values
            for try await now in progress {
                self.state.loadingProgress = now
                if now == 1 {
                    self.state.isLoadingHidden = true
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }

    private func setRefreshControl(webView: WKWebView) {
        Task {
            let refresh = self.refreshControl.rx.controlEvent(.valueChanged).values
            for try await _ in refresh {
                webView.reload()
            }
        }
        webView.scrollView.addSubview(self.refreshControl)
    }

}
