import Foundation
import OpenAPIRuntime

struct RaspDateTranscoder: DateTranscoder {

    func encode(_ date: Date) throws -> String {
        ISO8601DateFormatter().string(from: date)
    }

    func decode(_ dateString: String) throws -> Date {
        if let timeOnly = Self.decodeTimeOnly(dateString) {
            return timeOnly
        }

        // 1) ISO8601 date-time: "2025-12-21T00:07:00+03:00"
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withTimeZone]
        if let date = iso.date(from: dateString) {
            return date
        }

        // 2) ISO8601 + fractional seconds
        let isoFrac = ISO8601DateFormatter()
        isoFrac.formatOptions = [.withInternetDateTime, .withFractionalSeconds, .withTimeZone]
        if let date = isoFrac.date(from: dateString) {
            return date
        }

        // 3) RFC3339
        if let date = Self.makeFormatter("yyyy-MM-dd'T'HH:mm:ssXXXXX").date(from: dateString) {
            return date
        }

        // 4) RFC3339 + millis
        if let date = Self.makeFormatter("yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX").date(from: dateString) {
            return date
        }

        throw DecodingError.dataCorrupted(
            .init(codingPath: [], debugDescription: "Unsupported date format: \(dateString)")
        )
    }

    private static func decodeTimeOnly(_ s: String) -> Date? {
        // "HH:mm" или "HH:mm:ss"
        let parts = s.split(separator: ":").map(String.init)
        guard parts.count == 2 || parts.count == 3 else { return nil }

        guard
            let h = Int(parts[0]), (0...23).contains(h),
            let m = Int(parts[1]), (0...59).contains(m)
        else { return nil }

        let sec: Int
        if parts.count == 3 {
            guard let s = Int(parts[2]), (0...59).contains(s) else { return nil }
            sec = s
        } else {
            sec = 0
        }

        var comps = DateComponents()
        comps.calendar = Calendar(identifier: .gregorian)
        comps.timeZone = TimeZone(secondsFromGMT: 0)
        comps.year = 1970
        comps.month = 1
        comps.day = 1
        comps.hour = h
        comps.minute = m
        comps.second = sec
        return comps.date
    }

    private static func makeFormatter(_ format: String) -> DateFormatter {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(secondsFromGMT: 0)
        f.dateFormat = format
        return f
    }
}
