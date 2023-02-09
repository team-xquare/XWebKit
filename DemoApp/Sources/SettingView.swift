import SwiftUI

import XWebKit
import SemicolonDesign

struct SettingView: View {

    @Environment(\.presentationMode) var presentationMode

    @Binding var url: String
    @Binding var token: String

    @State private var tempUrl: String = ""
    @State private var tempToken: String = ""

    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    SDTextField(title: "URL", placeholder: "https://...", text: $tempUrl)
                    SDTextField(title: "Access Token", placeholder: "eyJ0eXAiOiJKV1Q...", text: $tempToken)
                    HStack {
                        SmallButton(
                            text: "기본값",
                            action: {
                                self.tempUrl = "https://service.xquare.app/xbridge-test"
                                self.tempToken = "Test Token"
                            },
                            type: .lightColor
                        )
                    }
                    Spacer()
                }
                .padding(16)
            }
            VStack {
                Spacer()
                FillButton(
                    text: "확인",
                    action: {
                        self.url = self.tempUrl
                        self.token = self.tempToken
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    type: .rounded
                )
            }
        }
        .navigationTitle("Setting")
    }

}
