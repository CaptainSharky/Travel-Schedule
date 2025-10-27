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
            testFetchCopyright()
        }
    }

    func testFetchStations() {
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
