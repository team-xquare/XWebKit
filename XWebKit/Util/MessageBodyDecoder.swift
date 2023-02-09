import Foundation

final class MessageBodyDecoder {

    static let share: MessageBodyDecoder = .init()

    private let decoder = JSONDecoder()

    private init() { }

    func decode<T>(_ type: T.Type, from data: Any) throws -> T where T: Decodable {
        guard let dataString = data as? String,
              let response = try? decoder.decode(type, from: Data(dataString.utf8))
            else { throw MessageBodyDecodeError.conversionError }
        return response
    }

}

enum MessageBodyDecodeError: Error {
    case conversionError
}
