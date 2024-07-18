//
//  RepoDetialView.swift
//  Github_Shubham_Lodhi
//
//  Created by SHUBHAM on 17/07/24.
//

import SwiftUI

struct RepoDetailView: View {
    
    @State var repository: Repository?
    @StateObject private var vm = RepoDetailViewModel()
    
    var body: some View {

        ScrollView(.vertical) {
            VStack(alignment: .center,spacing: 5, content: {
                    if let img = vm.contributors.first?.avatarURL {
                        AsyncImage(url: URL(string: img)) { image in
                            image.resizable()
                                .frame(width: 250, height: 250)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                                .clipped()
                        } placeholder: {
                            ProgressView()
                                .frame(width: 250, height: 250)
                                .background(.white.opacity(0.3))
                        }
                }else{
                    ZStack(content: {
                        Rectangle()
                            .frame(width: 250, height: 250)
                            .foregroundStyle(.gray.opacity(0.3))
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                        ProgressView()
                    })
                    
                }
                Text(repository?.fullName ?? "")
                    .font(.title)
                    .fontWeight(.medium)
                Spacer(minLength: 30)
                Text(repository?.description ?? "No description")
                    .font(.body)
                
                if let url = repository?.htmlURL, let urlLink = URL(string: url) {
                    Link(url, destination: urlLink)
                        .foregroundColor(.blue)
                }
                
                if vm.isloading  {
                    ProgressView("Loading Contributors...")
                        .foregroundStyle(.black)
                }else if let _  = vm.errorMessage  {
                }else {
                    Spacer(minLength: 30)
                    if vm.contributors.count != 0 {
                        Text("\(vm.contributors.count) Contributors")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.gray)
                    }
                    LazyVStack(alignment: .leading, spacing: 15) {
                        ForEach(vm.contributors) { contributor in
                            ContributorRow(contributor: contributor)
                        }
                    }
                }
                
                Spacer()
                if !vm.isNetwork {
                    Spacer(minLength: 10)
                    Text("Oops! no Inernet found")
                        .font(.title3)
                        .fontWeight(.regular)
                        .multilineTextAlignment(.center)
                        .background(.clear)
                        .foregroundStyle(.gray.opacity(0.7))
                }
                
                if vm.errorMessage != nil {
                    Spacer(minLength: 10)
                    Text(vm.errorMessage ?? "something went wrong")
                        .font(.title3)
                        .fontWeight(.regular)
                        .multilineTextAlignment(.center)
                        .background(.clear)
                        .foregroundStyle(.red)
                        .safeAreaPadding()
                }
            }).onAppear(perform: {
                if let url = repository?.contributorsURL {
                    vm.fetechContributors(url: url)
                }
            })
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            .navigationTitle(repository?.name ?? "Repository Detail")
        }
    }
}

#Preview {
    RepoDetailView(repository: nil)
}


struct ContributorRow: View {
    var contributor: Contributor
    
    var body: some View {
        HStack {
            if let avatarURL = contributor.avatarURL, let url = URL(string: avatarURL) {
                                    
                AsyncImage(url: url) { image in
                    image.resizable()
                        .frame(width: 40, height: 40)
                        .clipped()
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                        .frame(width: 40, height: 40)
                        .background(.white.opacity(0.3))
                }

            }
            Text(contributor.login ?? "Unknown")
                .font(.headline)
        }
    }
}
