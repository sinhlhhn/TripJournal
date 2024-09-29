import Combine
import Foundation

enum JournalServiceError: Error {
    case invalidResponse
    case invalidData
    case invalidToken
    case notFound
}

/// An unimplemented version of the `JournalService`.
class JournalServiceImpl: JournalService {
    
    private let urlSession: URLSession
    @Published private var token: Token?

    init() {
        let configuration = URLSessionConfiguration.default
        self.urlSession = URLSession(configuration: configuration)
    }
    
    var isAuthenticated: AnyPublisher<Bool, Never> {
        $token
            .map { $0 != nil }
            .eraseToAnyPublisher()
    }

    //MARK: -Register
    func register(username : String, password: String) async throws -> Token {
        let request = try createRegisterRequest(username: username, password: password)
        
        let token: Token = try await performRequest(request)
        self.token = token
        
        return token
    }
    
    private func createRegisterRequest(username: String, password: String) throws -> URLRequest {
        let url = URL(string: "https://localhost:8080/register")!
        let body = AuthRequest(username: username, password: password)
        return try createPostRequest(url, with: body)
    }

    //MARK: -LogOut
    func logOut() {
        token = nil
    }

    //MARK: -LogIn
    func logIn(username: String, password: String) async throws -> Token {
        let request = try createLogInRequest(username: username, password: password)
        
        let token: Token = try await performRequest(request)
        self.token = token
        
        return token
    }
    
    private func createLogInRequest(username: String, password: String) throws -> URLRequest {
        let url = URL(string: "https://localhost:8080/token")!
        let body = AuthRequest(username: username, password: password)
        return try createPostRequest(url, with: body)
    }

    //MARK: -Trip
    func createTrip(with trip: TripCreate) async throws -> Trip {
        let request = try createTripRequest(trip: trip)
        
        let trip: Trip = try await performRequest(request)
        return trip
    }
    
    private func createTripRequest(trip: TripCreate) throws -> URLRequest {
        let url = URL(string: "https://localhost:8080/trips")!
        return try createPostRequest(url, with: trip)
    }

    func getTrips() async throws -> [Trip] {
        let url = URL(string: "https://localhost:8080/trips")!
        let request = try createGetRequest(url)
        
        let trips: [Trip] = try await performRequest(request)
        return trips
    }

    func getTrip(withId id: Trip.ID) async throws -> Trip {
        guard let trip = try await getTrips().first(where: { $0.id == id }) else {
            throw JournalServiceError.notFound
        }
        
        return trip
    }

    func updateTrip(withId id: Trip.ID, and trip: TripUpdate) async throws -> Trip {
        let url = URL(string: "https://localhost:8080/trips/\(id)")!
        let data = try JSONEncoder().encode(trip)
        let request = try createPutRequest(url, with: data)
        
        let trip: Trip = try await performRequest(request)
        return trip
    }

    func deleteTrip(withId id: Trip.ID) async throws {
        let url = URL(string: "https://localhost:8080/trips/\(id)")!
        let request = try createDeleteRequest(url)
        
        let _: String = try await performRequest(request)
    }
    
    //MARK: -Event
    func createEvent(with _: EventCreate) async throws -> Event {
        fatalError("Unimplemented createEvent")
    }

    func updateEvent(withId _: Event.ID, and _: EventUpdate) async throws -> Event {
        fatalError("Unimplemented updateEvent")
    }

    func deleteEvent(withId _: Event.ID) async throws {
        fatalError("Unimplemented deleteEvent")
    }

    func createMedia(with _: MediaCreate) async throws -> Media {
        fatalError("Unimplemented createMedia")
    }

    func deleteMedia(withId _: Media.ID) async throws {
        fatalError("Unimplemented deleteMedia")
    }
    
    //MARK: -Helpers
    private func performRequest<T: Decodable>(_ request: URLRequest) async throws -> T {
        guard let (data, response) = try await urlSession.data(for: request) as? (Data, HTTPURLResponse) else {
            throw URLError(.badURL)
        }
        
        if response.statusCode != 200 || data.isEmpty {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    private func createPostRequest<T: Encodable>(_ url: URL, with body: T) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = try JSONEncoder().encode(body)
        request.httpBody = data
        return request
    }
    
    private func createGetRequest(_ url: URL) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    private func createPutRequest<T: Encodable>(_ url: URL, with body: T) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = try JSONEncoder().encode(body)
        request.httpBody = data
        return request
    }
    
    private func createDeleteRequest(_ url: URL) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        return request
    }
}
