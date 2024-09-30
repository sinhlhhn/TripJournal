import Foundation

struct AuthRequest: Encodable {
    let username: String
    let password: String
}

/// An object that can be used to create a new trip.
struct TripCreate: Encodable {
    let name: String
    let startDate: Date
    let endDate: Date
}

/// An object that can be used to update an existing trip.
struct TripUpdate: Encodable {
    let name: String
    let startDate: Date
    let endDate: Date
}

/// An object that can be used to create a media.
struct MediaCreate: Encodable {
    let eventId: Event.ID
    let base64Data: Data
}

/// An object that can be used to create a new event.
struct EventCreate: Encodable {
    let tripId: Trip.ID
    let name: String
    let note: String?
    let date: Date
    let location: Location?
    let transitionFromPrevious: String?
}

/// An object that can be used to update an existing event.
struct EventUpdate: Encodable {
    var name: String
    var note: String?
    var date: Date
    var location: Location?
    var transitionFromPrevious: String?
}
