//
//  ReposListCell.swift
//  Github
//
//  Created by FMI-PC-LT-48 on 15/01/2024.
//


import SwiftUI

struct ReposListCell: View {
    var repo: Repo
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            Text(repo.name)        .font(.system(size: 18, weight: .bold, design: .default))
                .fontWidth(Font.Width.compressed)
            
            if let description = repo.description {
                Text(description).font(.system(size: 16)).foregroundColor(.gray)
            }
            HStack (spacing: 4){
                Image(systemName: "star")
                    .font(.system(size: 14)).foregroundColor(.indigo)
                Text(String(repo.stars)).font(.system(size: 14)).foregroundColor(.indigo)
                Spacer(minLength: 20)
                switch(repo.languages) {
                case .idle:
                    ProgressView()
                case .loaded(let languages, _):
                    Text(String(languages.name.joined(separator: " | "))).font(.system(size: 14)).foregroundColor(.indigo)
                default:
                    EmptyView()
                }
            }
        }
        
    }
    
}
