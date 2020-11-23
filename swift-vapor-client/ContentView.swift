//
//  ContentView.swift
//  swift-vapor-client
//
//  Created by David Choi on 10/19/20.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("token") var token = ""
    @EnvironmentObject var store: ObservableStore
    @State var showLogin = false
    @State var userName = "dave"
    @State var password = "Test123"
    
    var body: some View {
        VStack(spacing: 10) {
            DisplayUserView()
            NewTodoView()
            ListTodoView()
            Button {
                self.showLogin = true
            } label: {
                Text("Login")
            }
            Spacer()
        }
        .onAppear {
            store.setMe(token: token)
            store.setTodos(token: token)
        }
        .sheet(isPresented: $showLogin) {
            Form {
                Section(
                    header: Text("Add Todo")
                            .font(.system(.title2))
                ) {
                    HStack {
                        Text("UserName")
                        TextField("", text: $userName)
                    }
                    
                    HStack {
                        Text("Password")
                        SecureField("", text: $password)
                    }
                    
                    Button {
                        login()
                    } label: {
                        Text("Login")
                    }
                }
            }
        }
    }
    
    func login() {
        do {
            let url = URL(string: "\(self.store.serverRoot)/users/login")
            var urlReq = URLRequest(url: url!)
            urlReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlReq.httpMethod = "POST"
            
            let encoder = JSONEncoder()
            let payload = try encoder.encode(UserLogin(userName: self.userName, password: self.password))
            print("login payload \(payload)")
            URLSession.shared.uploadTask(with: urlReq, from: payload) { (data, resp, err) in
                print("login attempt complete")
                guard let data = data else {
                    print("login failed")
                    return
                }
                
                let token = String(data: data, encoding: String.Encoding.utf8)
                print("login token \(String(describing: token))")
                self.showLogin = false
                self.token = token ?? ""
                self.store.setMe(token: self.token)
                self.store.setTodos(token: self.token)
            }
            .resume()
        } catch {
            print("Login failed during call.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
