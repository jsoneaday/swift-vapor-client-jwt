//
//  swift_vapor_clientApp.swift
//  swift-vapor-client
//
//  Created by David Choi on 10/19/20.
//

import SwiftUI

@main
struct insta_clone_clientApp: App {
    let store: ObservableStore = ObservableStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}

class ObservableStore: ObservableObject {
    @Published var serverRoot = "http://localhost:8080"
    @Published var todos = [Todo]()
    @Published var me: Me?
    var token = ""
    private static let storeQueue = DispatchQueue(label: "StoreQueue")
        
    func setTodos(token: String) {
        let url = URL(string: "\(serverRoot)/todos")
        var urlReq = URLRequest(url: url!)
        urlReq.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlReq.httpMethod = "GET"
        _ = URLSession.shared.dataTaskPublisher(for: urlReq)
            .subscribe(on: ObservableStore.storeQueue)
            .map {
                return $0.data
            }
            .decode(type: [Todo].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { subscribeCompletion in
                switch subscribeCompletion {
                case .finished:
                    print("got todos")
                case .failure:
                    print("failed to get todos")
                }
            } receiveValue: { [weak self] todos in
                self?.todos = todos
            }
    }
        
    func setMe(token: String) {
        let url = URL(string: "\(self.serverRoot)/users/me")
        var urlReq = URLRequest(url: url!)
        urlReq.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlReq.httpMethod = "GET"
        let result = URLSession.shared.dataTask(with: urlReq) { (data, resp, err) in
            print("setMe finished")
            guard let gotData = data else {
                print("failed to get data")
                return
            }
                  
            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(Me.self, from: gotData)
                self.me = user                
                
            } catch {
                print("failed to decode user object")
            }
        }
        result.resume()
    }
}
