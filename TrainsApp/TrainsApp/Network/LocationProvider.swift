import CoreLocation
import Foundation

enum LocationProviderError: Error {
    case authorizationDenied
    case unableToFetchLocation
}

@MainActor
final class LocationProvider: NSObject, CLLocationManagerDelegate {

    private let manager = CLLocationManager()

    private var authContinuation: CheckedContinuation<CLAuthorizationStatus, Never>?
    private var locationContinuation: CheckedContinuation<CLLocationCoordinate2D, Error>?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func requestCoordinate() async throws -> CLLocationCoordinate2D {
        let status = manager.authorizationStatus

        let resolvedStatus: CLAuthorizationStatus
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            resolvedStatus = await withCheckedContinuation { cont in
                self.authContinuation = cont
            }
        default:
            resolvedStatus = status
        }

        switch resolvedStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            break
        default:
            throw LocationProviderError.authorizationDenied
        }

        return try await withCheckedThrowingContinuation { cont in
            self.locationContinuation = cont
            self.manager.requestLocation()
        }
    }

    // MARK: - CLLocationManagerDelegate

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authContinuation?.resume(returning: manager.authorizationStatus)
        authContinuation = nil
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last?.coordinate else {
            locationContinuation?.resume(throwing: LocationProviderError.unableToFetchLocation)
            locationContinuation = nil
            return
        }
        locationContinuation?.resume(returning: coordinate)
        locationContinuation = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationContinuation?.resume(throwing: error)
        locationContinuation = nil
    }
}
