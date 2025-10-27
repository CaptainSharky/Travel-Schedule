//
//  ContentView.swift
//  TrainsApp
//
//  Created by Stepan Chuiko on 26.10.2025.
//

import SwiftUI
import OpenAPIURLSession

struct ContentView: View {
    let apikey = "bb6ebbc8-d4ec-44d1-a927-87d67ced6345"

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            testFetchNearestCity()
        }
    }

    func testFetchScheduleBetween() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )

                let service = ScheduleBetweenService(
                    client: client,
                    apikey: apikey
                )

                print("Fetching schedule between stations...")
                let schedule = try await service.getScheduleBetweenStations(
                    from: "s9813094",
                    to: "s9857048"
                )

                print("Successfully fetched schedule between stations: \(schedule)")
            } catch {
                print("Error fetching schedule between stations: \(error)")
            }
        }
    }

    func testFetchStationSchedule() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )

                let service = StationScheduleService(
                    client: client,
                    apikey: apikey
                )

                print("Fetching station schedule...")
                let schedule = try await service.getStationSchedule(station: "s9600213")

                print("Successfully fetched station schedule: \(schedule)")
            } catch {
                print("Error fetching station schedule: \(error)")
            }
        }
    }

    func testFetchRouteStations() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )

                let service = RouteStationsService(
                    client: client,
                    apikey: apikey
                )

                print("Fetching route stations...")
                let stations = try await service.getRouteStations(uid: "FV-5553_251101_c8565_12")

                print("Successfully fetched route stations: \(stations)")
            } catch {
                print("Error fetching route stations: \(error)")
            }
        }
    }

    func testFetchNearestStations() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )

                let service = NearestStationsService(
                    client: client,
                    apikey: apikey
                )

                print("Fetching stations...")
                let stations = try await service.getNearestStations(
                    lat: 59.864177,
                    lng: 30.319163,
                    distance: 50
                )

                print("Successfully fetched stations: \(stations)")
            } catch {
                print("Error fetching stations: \(error)")
            }
        }
    }

    func testFetchNearestCity() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )

                let service = NearestCityService(
                    client: client,
                    apikey: apikey
                )

                print("Fetching nearest city...")
                let city = try await service.getNearestCity(
                    lat: 50.453624,
                    lng: 40.130439
                )

                print("Successfully fetched nearest city: \(city)")
            } catch {
                print("Error fetching nearest city: \(error)")
            }
        }
    }

    func testFetchCopyright() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )

                let service = CopyrightService(
                    client: client,
                    apikey: apikey
                )

                print("Fetching copyright...")
                let copyright = try await service.getCopyright()

                print("Successfully fetched copyright: \(copyright)")
            } catch {
                print("Error fetching copyright: \(error)")
            }
        }
    }
}

#Preview {
    ContentView()
}
