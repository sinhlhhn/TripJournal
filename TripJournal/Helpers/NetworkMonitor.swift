
import Combine
import Observation
import Network

@Observable
class NetworkMonitor {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    var isConnected: Bool = true
    var usingCellular: Bool = false

    private var previousIsConnected: Bool = true

    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                let newIsConnected = path.status == .satisfied
                if newIsConnected != self.previousIsConnected {
                    self.isConnected = newIsConnected
                    self.previousIsConnected = newIsConnected
                }
                self.usingCellular = path.isExpensive
            }
        }
        monitor.start(queue: queue)
    }
}
