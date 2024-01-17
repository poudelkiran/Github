//
//  UserListCell.swift
//  Github
//
//  Created by FMI-PC-LT-48 on 12/01/2024.
//

import SwiftUI

struct UserListCell: View {
    var user: User
    var body: some View {
        HStack{
            RoundedRectangle(cornerRadius: 9)
                .stroke(.gray.opacity(0.35), lineWidth: 2)
                .frame(width: 54, height: 54)
                .overlay(
                    
                    AsyncImage(url: URL(string: user.avatar)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else if phase.error != nil {
                            Image(Images.github).resizable().aspectRatio(contentMode: .fit).frame(width: 30, height: 30)
                        } else {
                            ProgressView()
                                .frame(width: 50, height: 50)
                        }
                    }
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 9)))
            VStack(alignment: .leading){
                Text("# "+String(user.id)).font(.footnote)
                Text(user.userName)
            }
        }
    }
}
