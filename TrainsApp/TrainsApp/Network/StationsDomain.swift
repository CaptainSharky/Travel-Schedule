import Foundation

enum StationTitleParser {

    static func splitCityAndStation(from raw: String) -> (city: String, station: String) {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return ("", "") }

        // 1) Формат: "Город (Станция)"
        if let open = trimmed.range(of: " ("), trimmed.hasSuffix(")") {
            let city = String(trimmed[..<open.lowerBound]).trimmingCharacters(in: .whitespacesAndNewlines)
            let stationPart = trimmed[open.upperBound...].dropLast() // remove ")"
            let station = String(stationPart).trimmingCharacters(in: .whitespacesAndNewlines)
            if !city.isEmpty, !station.isEmpty {
                return (city, station)
            }
        }

        // 2) Формат: "Город - Станция"
        if trimmed.contains(" - ") {
            let parts = trimmed.split(separator: "-", maxSplits: 1, omittingEmptySubsequences: false)
            if parts.count == 2 {
                let city = String(parts[0]).trimmingCharacters(in: .whitespacesAndNewlines)
                let station = String(parts[1]).trimmingCharacters(in: .whitespacesAndNewlines)
                if !city.isEmpty, !station.isEmpty {
                    return (city, station)
                }
            }
        } else {
            let hyphenCount = trimmed.filter { $0 == "-" }.count
            if hyphenCount == 1 {
                let parts = trimmed.split(separator: "-", maxSplits: 1, omittingEmptySubsequences: false)
                if parts.count == 2 {
                    let city = String(parts[0]).trimmingCharacters(in: .whitespacesAndNewlines)
                    let station = String(parts[1]).trimmingCharacters(in: .whitespacesAndNewlines)
                    if !city.isEmpty, !station.isEmpty {
                        return (city, station)
                    }
                }
            }
        }

        return (trimmed, trimmed)
    }
}
