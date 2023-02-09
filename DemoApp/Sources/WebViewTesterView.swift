import SwiftUI

import XWebKit
import SemicolonDesign

struct WebViewTesterView: View {

    @State var url: String
    @State var token: String

    @State var isSettingViewActive: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                if !isSettingViewActive {
                    XWebKitView(
                        urlString: url,
                        accessToken: token
                    )
                }
            }
            .navigationTitle("Tester")
            .toolbar {
                NavigationLink(
                    isActive: $isSettingViewActive,
                    destination: {
                        SettingView(url: $url, token: $token)
                    },
                    label: {
                        Image(systemName: "gear")
                            .tint(.black)
                    }
                )
            }
        }
        .tint(.Primary.purple400)
    }
}
