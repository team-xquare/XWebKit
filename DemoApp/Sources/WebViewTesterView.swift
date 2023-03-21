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
                        accessTokenGetter: {
                            print("martin :: accessTokenGetter - \(token)")
                            return token
                        }
                    )
                }
            }
            .navigationTitle("Tester")
            .toolbar {
                Button("Refresh", action: {
                    print("martin :: token refresh")
                    self.token = "Refreshed TestToken"
                })
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
        .navigationViewStyle(.stack)
        .tint(.Primary.purple400)
    }
}
