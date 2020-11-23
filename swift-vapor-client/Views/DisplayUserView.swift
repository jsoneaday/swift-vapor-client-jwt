//
//  DisplayUserView.swift
//  insta-clone-client
//
//  Created by David Choi on 10/8/20.
//

import SwiftUI

struct DisplayUserView: View {
    @EnvironmentObject var store: ObservableStore
           
    var body: some View {
        VStack {
            HStack {
                Text("user: \(self.store.me?.userName ?? "")")
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray)
            )
        }
        .padding(5)
    }    
}
