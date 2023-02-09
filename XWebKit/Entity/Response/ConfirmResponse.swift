import Foundation

struct ConfirmResponse: Decodable {
    let id: String
    let message: String
    let confirmText: String
    let cancelText: String
}
