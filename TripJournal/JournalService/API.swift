//
//  API.swift
//  TripJournal
//
//  Created by Sam on 1/10/24.
//

import Foundation

enum HTTPMethods: String {
    case POST, GET, PUT, DELETE
}

enum MIMEType: String {
    case JSON = "application/json"
    case form = "application/x-www-form-urlencoded"
}

enum HTTPHeaders: String {
    case accept
    case contentType = "Content-Type"
    case authorization = "Authorization"
}

enum JournalServiceError: Error {
    case invalidResponse
    case invalidData
    case invalidToken
    case notFound
}

enum SessionError: Error {
    case expired
}

extension SessionError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .expired:
            return "Your session has expired. Please log in again."
        }
    }
}

enum EndPoints {
    static let base = "http://localhost:8000/"

    case register
    case login
    case trips
    case handleTrip(Int)
    case events
    case handleEvent(Int)
    case media
    case handleMedia(Int)

    private var stringValue: String {
        switch self {
        case .register:
            return EndPoints.base + "register"
        case .login:
            return EndPoints.base + "token"
        case .trips:
            return EndPoints.base + "trips"
        case .handleTrip(let tripId):
            return EndPoints.base + "trips/\(tripId)"
        case .events:
            return EndPoints.base + "events"
        case .handleEvent(let id):
            return EndPoints.base + "events/\(id)"
        case .media:
            return EndPoints.base + "media"
        case .handleMedia(let id):
            return EndPoints.base + "media/\(id)"
        }
    }

    var url: URL {
        return URL(string: stringValue)!
    }
}
