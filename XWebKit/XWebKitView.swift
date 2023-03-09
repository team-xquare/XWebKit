import SwiftUI

import SemicolonDesign

public struct XWebKitView: View {

    @ObservedObject var state: XWebKitState

    public init(urlString: String, accessToken: String = "") {
        self.state = .init(
            urlString: urlString,
            accessToken: accessToken,
            isPresentated: .constant(true),
            naviagteRightButtonText: nil
        )
    }

    init(
        urlString: String,
        accessToken: String,
        isPresentated: Binding<Bool>,
        naviagteRightButtonText: String?
    ) {
        self.state = .init(
            urlString: urlString,
            accessToken: accessToken,
            isPresentated: isPresentated,
            naviagteRightButtonText: naviagteRightButtonText
        )
    }

    public var body: some View {
        ZStack {
            ComposedWebView(state: self.state)
            if !self.state.isLoadingHidden {
                VStack {
                    ProgressView(value: self.state.loadingProgress)
                        .progressViewStyle(XWebKitProgressViewStyle())
                    Spacer()
                }
            }
            NavigationLink(
                isActive: self.$state.needsToNavigate,
                destination: {
                    XWebKitView(
                        urlString: self.state.naviagteLink,
                        accessToken: self.state.accessToken,
                        isPresentated: self.$state.needsToNavigate,
                        naviagteRightButtonText: self.state.naviagteRightButtonText
                    )
                    .navigationTitle(self.state.naviagteTitle)
                    .navigationBarTitleDisplayMode(.inline)
                },
                label: { EmptyView() }
            )
        }
        .toolbar {
            if let rightButtonText = self.state.rightButtonText {
                Button(rightButtonText) {
                    self.state.naviagteRightButtonTap = ()
                }
                .disabled(!self.state.isRightButtonEnabled)
            }
        }
        .sdAlert(isPresented: self.$state.isAlertPresented) {
            SDAlert(
                title: self.state.alertMessage,
                content: .init(),
                button1: (self.state.alertCancelText, {
                    self.state.alertResponse = false
                }),
                button2: (self.state.alertConfirmText, {
                    self.state.alertResponse = true
                })
            )
        }
        .sdPhotoViewer(
            isPresented: self.$state.isImageViewerPresented,
            images: self.state.images
        )
        .sdErrorAlert(isPresented: self.$state.isErrorAlertPresented) {
            SDErrorAlert(errerMessage: self.state.errorMessage)
        }
        .sdPhotoPicker(
            isPresented: self.$state.isPhotoPickerPresented,
            selection: self.$state.selectedImages
        )
        .sdBottomSheet(isPresented: self.$state.isActionSheetPresented, sdBottomSheet: {
            SDBottomSheet(buttons: self.state.actionSheetMenu.enumerated().map { menu in
                return (menu.element, { self.state.selectedMenuIndex = menu.offset })
            })
        })
        .sdTimePicker(
            isPresented: self.$state.isTimePickerPresented,
            currentDate: self.$state.timePickerCurrentTime,
            date: self.$state.selectedTime
        )
    }
}
