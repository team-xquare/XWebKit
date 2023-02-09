import SwiftUI

@main
struct XQUAREApp: App {

    var body: some Scene {
        WindowGroup {
            WebViewTesterView(
                url: "https://service.xquare.app/xbridge-test",
                token: "Test Token"
            )
        }
    }

}
