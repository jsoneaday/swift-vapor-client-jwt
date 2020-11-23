//
//  ListTodoView.swift
//  insta-clone-client
//
//  Created by David Choi on 10/9/20.
//

import SwiftUI

struct ListTodoView: View {
    let textMinWidth:CGFloat = 240
    @EnvironmentObject var store: ObservableStore
    
    var body: some View {
        List(store.todos) { todo in
            VStack(alignment: .leading) {
                HStack {
                    Text("Title")
                        .font(.system(.title3))
                    Spacer()
                    Text(todo.title)
                        .frame(minWidth: textMinWidth, alignment: .leading)
                }
                HStack {
                    Text("Description")
                        .font(.system(.title3))
                    Spacer()
                    Text(todo.desc)
                        .frame(minWidth: textMinWidth, alignment: .leading)
                }
            }
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray)
                )
        }
    }
}

