import SwiftUI

import Combine

class XWebKitState: ObservableObject {

    var urlString: String = ""
    var accessToken: String = ""

    var isPresentated: Binding<Bool>

    var cancellables = Set<AnyCancellable>()

    @Published var loadingProgress: Double = 0.0

    // navigate
    @Published var needsToNavigate: Bool = false
    @Published var naviagteTitle: String = ""
    @Published var naviagteLink: String = ""

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

    // photoPicker
    @Published var photoPickerId: String = ""
    @Published var isPhotoPickerPresented: Bool = false
    @Published var selectedImages: [UIImage] = []

    init(urlString: String, accessToken: String = "", isPresentated: Binding<Bool>) {
        self.urlString = urlString
        self.accessToken = accessToken
        self.isPresentated = isPresentated
    }

}
