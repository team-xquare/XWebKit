import SwiftUI

import SemicolonDesign

public struct XWebKitView: View {

    @ObservedObject var state: XWebKitState

    public init(urlString: String, accessTokenGetter: @escaping () -> String = { "" }) {
        self.state = .init(
            urlString: urlString,
            accessTokenGetter: accessTokenGetter,
            isPresentated: .constant(true),
            naviagteRightButtonText: nil
        )
    }

    init(
        urlString: String,
        accessTokenGetter: @escaping () -> String,
        isPresentated: Binding<Bool>,
        naviagteRightButtonText: String?
    ) {
        self.state = .init(
            urlString: urlString,
            accessTokenGetter: accessTokenGetter,
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
                        accessTokenGetter: self.state.accessTokenGetter,
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
        .sdOkayAlert(isPresented: self.$state.isErrorAlertPresented) {
            SDOkayAlert(title: "문제가 발생했습니다.", message: self.state.errorMessage)
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
        .sdPeriodPicker(
            isPresented: self.$state.isPeriodPickerPresented,
            period: self.$state.selectedPeriod
        )
    }
}
