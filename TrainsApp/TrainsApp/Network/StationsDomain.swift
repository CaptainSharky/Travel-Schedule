import Foundation

enum StationTitleParser {
    static func splitCityAndStation(from raw: String) -> (city: String, station: String) {
        if let open = raw.range(of: " ("), raw.hasSuffix(")") {
            let city = String(raw[..<open.lowerBound]).trimmingCharacters(in: .whitespacesAndNewlines)
            let stationPart = String(raw[open.upperBound...]).dropLast()
            let station = String(stationPart).trimmingCharacters(in: .whitespacesAndNewlines)
            if !city.isEmpty, !station.isEmpty {
                return (city, station)
            }
        }

        return (raw, raw)
    }
}
