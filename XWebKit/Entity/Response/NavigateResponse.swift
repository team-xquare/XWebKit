import Foundation

struct NavigateResponse: Decodable {
    let url: String
    let title: String
    let rightButtonText: String?
}
