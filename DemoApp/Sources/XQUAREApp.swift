import SwiftUI

@main
struct XQUAREApp: App {

    var body: some Scene {
        WindowGroup {
            WebViewTesterView(
                url: "https://prod-server.xquare.app/xbridge-test",
                token: "Test Token"
            )
        }
    }

}
