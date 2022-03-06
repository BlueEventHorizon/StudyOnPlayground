import Foundation
import Combine

var cancellables: Set<AnyCancellable> = []

// https://qiita.com/shiz/items/b69a596fbb5478af9851
func jikken_Deferred() {
    // Futureの場合、Subscribeされなくても、すぐインスタンスが生成される
    
    let _ = Future<String, Never> { promise in
        print("✳️ Futureの場合、Subscribeされなくても、すぐインスタンスが生成される")
        promise(.success("hello"))
    }
    
    // Deferredの場合、Subscribeされるまでインスタンスは生成されない

    let deferredPublisher = Deferred { () -> Just<String> in
        print("✳️ Deferredの場合、Subscribeされるまでインスタンスは生成されない")
        return Just("hello")
    }
    
    // Deferredの場合、Subscribeされるまで実行されない

    deferredPublisher
        // 5秒後にはこの関数を抜けている
        //.delay(for: 5.0, scheduler: DispatchQueue.main)
        .sink(receiveCompletion: {
            print("✴️ receiveCompletion \($0)")
        }, receiveValue: {
            print("✴️ receiveValue \($0)")
        })
        // storeされなければ、結果を受け取ることはない
        .store(in: &cancellables)

    print("exit")
}

jikken_Deferred()

func jikken_Deferred_Future() {
    
    let aFutureInt = Deferred {
      Future<Int, Never> { promise in
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            print("✳️ Deferredの場合、Subscribeされるまでインスタンスは生成されない")
            
            promise(.success(42))

            // Futureなので、２つめは実行されない
            promise(.success(1729))
        }
      }
    }

    aFutureInt
        .sink { value in
            print("✴️ receiveCompletion \(value)")
        } receiveValue: { value in
            print("✴️ receiveValue \(value)")
        }
        // storeされなければ、結果を受け取ることはない
        .store(in: &cancellables)
    
    print("exit")
}

jikken_Deferred_Future()
