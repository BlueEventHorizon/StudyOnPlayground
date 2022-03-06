import Foundation
import Combine

enum StudyCombineError: Error {
    case fatal(String)
}

var cancellables: Set<AnyCancellable> = []

func doMapError() {

    let instance = URLSession.shared
        .dataTaskPublisher(for: URL(string: "https://xxx.google.com")!)
        //.delay(for: 5.0, scheduler: DispatchQueue.main)
        .retry(1)
        //.map{$0.data}
        //.map(\.response)
        .map(\.data)
        .receive(on: DispatchQueue.main)
        .mapError { error in
            StudyCombineError.fatal(error.localizedDescription)
        }
        .print("✳️ ")

    
    print("subscribe 1回目")
    instance
        .sink( receiveCompletion: { _ in },
               receiveValue: { print("✴️ subscription1 receiveValue: '\($0)'") })
        .store(in: &cancellables)

    print("subscribe 2回目")
    instance
        .sink( receiveCompletion: { _ in },
               receiveValue: { print("✴️ subscription2 receiveValue: '\($0)'") })
        .store(in: &cancellables)
}

doMapError()

