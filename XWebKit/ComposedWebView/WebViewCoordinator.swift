import UIKit

import WebKit

class WebViewCoordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler, UIScrollViewDelegate {

    var parent: ComposedWebView

    init(_ uiWebView: ComposedWebView) {
        self.parent = uiWebView
    }

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        return decisionHandler(.allow)
    }

    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        switch message.name {
        case "navigate": self.processNavigateBridge(message.body)
        case "isRightButtonEnabled": self.processIsRightButtonEnabledBridge(message.body)
        case "imageDetail": self.preocessImageDetailBridge(message.body)
        case "back": self.processBackBridge()
        case "confirm": self.processConfirmBridge(message.body)
        case "success": self.processSuccessBridge(message.body)
        case "error": self.processErrorBridge(message.body)
        case "photoPicker": self.processPhotoPickerBridge(message.body)
        case "actionSheet": self.processActionSheet(message.body)
        case "timePicker": self.processTimePicker(message.body)
        case "periodPicker": self.processPeriodPicker(message.body)
        default: break
        }
    }

    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }

}

extension WebViewCoordinator {

    private func processNavigateBridge(_ messageBody: Any) {
        guard let messageBody = try? MessageBodyDecoder.share.decode(NavigateResponse.self, from: messageBody) else {
            return
        }
        print(messageBody)
        self.parent.state.naviagteLink = parent.state.urlString+messageBody.url
        self.parent.state.naviagteTitle = messageBody.title
        self.parent.state.naviagteRightButtonText = messageBody.rightButtonText
        self.parent.state.needsToNavigate = true
    }

    private func processIsRightButtonEnabledBridge(_ messageBody: Any) {
        guard let messageBody = try? MessageBodyDecoder.share.decode(IsRightButtonEnabledResponse.self, from: messageBody) else {
            return
        }
        print(messageBody)
        self.parent.state.isRightButtonEnabled = messageBody.isEnabled
        print(self.parent.state.isRightButtonEnabled)
    }

    private func preocessImageDetailBridge(_ messageBody: Any) {
        guard let messageBody = try? MessageBodyDecoder.share.decode(ImageDetailResponse.self, from: messageBody) else {
            return
        }
        self.parent.state.images = messageBody.images.map { URL(string: $0)! }
        self.parent.state.isImageViewerPresented = true
    }

    private func processBackBridge() {
        self.parent.state.isPresentated.wrappedValue = false
    }

    private func processConfirmBridge(_ messageBody: Any) {
        guard let messageBody = try? MessageBodyDecoder.share.decode(ConfirmResponse.self, from: messageBody) else {
            return
        }
        self.parent.state.alertResponse = nil
        self.parent.state.confirmId = messageBody.id
        self.parent.state.alertMessage = messageBody.message
        self.parent.state.alertConfirmText = messageBody.confirmText
        self.parent.state.alertCancelText = messageBody.cancelText
        self.parent.state.isAlertPresented = true
    }

    private func processSuccessBridge(_ messageBody: Any) {
        guard let messageBody = try? MessageBodyDecoder.share.decode(SuccessRespose.self, from: messageBody) else {
            return
        }
        self.parent.state.successMessage = messageBody.message
        self.parent.state.successTitle = messageBody.title
        self.parent.state.isSuccessAlertPresented = true
    }

    private func processErrorBridge(_ messageBody: Any) {
        guard let messageBody = try? MessageBodyDecoder.share.decode(ErrorRespose.self, from: messageBody) else {
            return
        }
        self.parent.state.errorMessage = messageBody.message
        self.parent.state.isErrorAlertPresented = true
    }

    private func processActionSheet(_ messageBody: Any) {
        guard let messageBody = try? MessageBodyDecoder.share.decode(ActionSheetResponse.self, from: messageBody) else {
            return
        }
        print("processActionSheet")
        print(messageBody)
        self.parent.state.selectedMenuIndex = nil
        self.parent.state.actionSheetId = messageBody.id
        self.parent.state.actionSheetMenu = messageBody.menu
        self.parent.state.isActionSheetPresented = true
    }

    private func processPhotoPickerBridge(_ messageBody: Any) {
        guard let messageBody = try? MessageBodyDecoder.share.decode(PhotoPickerResponse.self, from: messageBody) else {
            return
        }
        self.parent.state.selectedImages = []
        self.parent.state.photoPickerId = messageBody.id
        self.parent.state.isPhotoPickerPresented = true
    }

    private func processTimePicker(_ messageBody: Any) {
        guard let messageBody = try? MessageBodyDecoder.share.decode(TimePickerResponse.self, from: messageBody) else {
            return
        }
        print("processTimePicker")
        print(messageBody)
        self.parent.state.selectedTime = ""
        self.parent.state.timePickerId = messageBody.id
        self.parent.state.isTimePickerPresented = true
    }

    private func processPeriodPicker(_ messageBody: Any) {
        guard let messageBody = try? MessageBodyDecoder.share.decode(PeriodResponse.self, from: messageBody)
        else {
            return
        }
        print("processPeriodPicker")
        print(messageBody)
        self.parent.state.periodPickerId = messageBody.id
        self.parent.state.isPeriodPickerPresented = true
    }
}
