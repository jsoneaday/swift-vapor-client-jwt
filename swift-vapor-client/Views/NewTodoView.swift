//
//  NewTodoView.swift
//  insta-clone-client
//
//  Created by David Choi on 10/8/20.
//

import SwiftUI

struct NewTodoView: View {
    @AppStorage("token") var token = ""
    @EnvironmentObject var store: ObservableStore
    @State var title: String = ""
    @State var desc: String = ""
    
    var body: some View {
        VStack {
            Form {
                Section(
                    header: Text("Add Todo")
                            .font(.system(.title2))
                ) {
                    HStack {
                        Text("Title")
                        TextField("", text: $title)
                    }
                    
                    HStack {
                        Text("Description")
                        TextField("", text: $desc)
                    }
                    
                    Button {
                        createTodo()
                    } label: {
                        Text("Add")
                    }
                }
            }
            .frame(maxHeight: 200)
        }
    }
    
    func createTodo() {
        do {
            let url = URL(string: "\(self.store.serverRoot)/todos")
            var urlReq = URLRequest(url: url!)
            urlReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlReq.setValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
            urlReq.httpMethod = "POST"
            let encoder = JSONEncoder()
            let payload = try encoder.encode(Todo(title: self.title, desc: self.desc))
            URLSession.shared.uploadTask(with: urlReq, from: payload) { (data, resp, err) in
                guard let data = data else {
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(Todo.self, from: data)
                    self.store.setTodos(token: self.token)
                    print("todo created \(result)")
                } catch {
                    print("decode failed")
                }
            }
            .resume()
        } catch {
            print("add todo failed")
        }
    }
}

