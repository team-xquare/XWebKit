import Foundation

enum BridgeType: String {
    case navigate
    case imageDetail
    case back
    case confirm
    case error
    case photoPicker
}

extension BridgeType {

    var responseType: Decodable.Type? {
        switch self {
        case .navigate: return NavigateResponse.self
        case .confirm: return ConfirmResponse.self
        default: return nil
        }
    }

}

extension BridgeType: CaseIterable { }
