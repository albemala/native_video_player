import Foundation

struct VideoSource {
    let path: String
    let type: VideoSourceType
    let headers: [String: String]

    init?(from map: [String: Any]) {
        guard let path = map["path"] as? String else { return nil }
        self.path = path

        let typeRaw = map["type"] as? String ?? ""
        guard let type = VideoSourceType(rawValue: typeRaw) else { return nil }
        self.type = type
        
        guard let headers = map["headers"] as? [String: String] else {return nil }
        self.headers = headers
    }
}
