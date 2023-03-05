import SwiftUI

import Combine

class XWebKitState: ObservableObject {

    var urlString: String = ""
    var accessToken: String = ""

    var isPresentated: Binding<Bool>

    var cancellables = Set<AnyCancellable>()

    @Published var loadingProgress: Double = 0.0

    // 현제 네이게이션 정보
    var rightButtonText: String?
    @Published var isRightButtonEnabled: Bool = false
    @Published var naviagteRightButtonTap: Void?

    // navigate - 네비게이팅 될곳의 정보
    @Published var needsToNavigate: Bool = false
    @Published var naviagteTitle: String = ""
    @Published var naviagteLink: String = ""
    @Published var naviagteRightButtonText: String?

    // imageDetail
    @Published var isImageViewerPresented: Bool = false
    @Published var images: [URL] = []

    // confirm
    @Published var confirmId: String = ""
    @Published var isAlertPresented: Bool = false
    @Published var alertMessage: String = ""
    @Published var alertConfirmText: String = ""
    @Published var alertCancelText: String = ""
    @Published var alertResponse: Bool?

    // error
    @Published var isErrorAlertPresented: Bool = false
    @Published var errorMessage: String = ""

    // actionSheet
    @Published var actionSheetId: String = ""
    @Published var actionSheetMenu: [String] = []
    @Published var isActionSheetPresented: Bool = false
    @Published var selectedMenuIndex: Int?

    // photoPicker
    @Published var photoPickerId: String = ""
    @Published var isPhotoPickerPresented: Bool = false
    @Published var selectedImages: [UIImage] = []

    // timePicker
    @Published var timePickerId: String = ""
    @Published var timePickerCurrentTime: String = ""
    @Published var isTimePickerPresented: Bool = false
    @Published var selectedTime: String = ""

    init(
        urlString: String,
        accessToken: String = "",
        isPresentated: Binding<Bool>,
        naviagteRightButtonText: String?
    ) {
        self.urlString = urlString
        self.accessToken = accessToken
        self.isPresentated = isPresentated
        self.rightButtonText = naviagteRightButtonText
    }

}
