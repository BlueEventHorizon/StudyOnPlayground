//
//  StudyCombine.swift
//  JikkenApp
//
//  Created by Katsuhiko Terada on 2021/07/28.
//

import Foundation
import Combine

enum StudyCombineError: Error {
    case fatal(String)
}

var cancellables: Set<AnyCancellable> = []

// https://qiita.com/shiz/items/f089c93bdebfaef2196f#share
func sharePublisher() {
    print("****** Publisherを .shareで共有すると ******")

    let shared = URLSession.shared
        .dataTaskPublisher(for: URL(string: "https://www.google.com")!)
        .map(\.data)
        //.map{$0.data}
        //.map(\.response)
        .receive(on: DispatchQueue.main)
        .mapError { error in
            StudyCombineError.fatal(error.localizedDescription)
        }
        .print("✳️ ")
        .share() // **ここでshareを呼んでいる**

    
    print("subscribe 1回目")

    shared
        .sink( receiveCompletion: { _ in },
               receiveValue: { print("✴️ subscription1 receiveValue: '\($0)'") })
        .store(in: &cancellables)

    print("subscribe 2回目")
    shared
        .sink( receiveCompletion: { _ in },
               receiveValue: { print("✴️ subscription2 receiveValue: '\($0)'") })
        .store(in: &cancellables)

    /*
     Publisherを .shareで共有すると
     🔵 subscribe 1回目 -- sharePublisher()
     ✳️ : receive subscription: (ReceiveOn)
     ✳️ : request unlimited
     🔵 subscribe 2回目 -- sharePublisher()
     2021-12-02 19:07:24.655045+0900 JikkenApp[7201:99264] [boringssl] boringssl_metrics_log_metric_block_invoke(144) Failed to log metrics
     ✳️ : receive value: (16042 bytes)
     ✴️ subscription2 receiveValue: '16042 bytes'
     ✴️ subscription1 receiveValue: '16042 bytes'
     ✳️ : receive finished
     */
}

sharePublisher()


func noSharePublisher() {
    print("****** Publisherを .shareがないと ******")

    let instance = URLSession.shared
        .dataTaskPublisher(for: URL(string: "https://www.google.com")!)
        .map(\.data)
        //.map{$0.data}
        //.map(\.response)
        .receive(on: DispatchQueue.main)
        .mapError { error in
            //log.debug("")
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
    
    /*
     🔵 subscribe 1回目 -- noSharePublisher()
     ✳️ : receive subscription: (ReceiveOn)
     ✳️ : request unlimited
     🔵 subscribe 2回目 -- noSharePublisher()
     ✳️ : receive subscription: (ReceiveOn)
     ✳️ : request unlimited
     2021-12-02 19:06:12.956302+0900 JikkenApp[7148:97848] [boringssl] boringssl_metrics_log_metric_block_invoke(144) Failed to log metrics
     ✳️ : receive value: (16042 bytes)
     ✴️ subscription2 receiveValue: '16042 bytes'
     ✳️ : receive finished
     ✳️ : receive value: (16041 bytes)
     ✴️ subscription1 receiveValue: '16041 bytes'
     ✳️ : receive finished
     */
}

noSharePublisher()
