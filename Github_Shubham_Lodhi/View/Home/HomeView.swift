//
//  HomeView.swift
//  Shubham_Lodhi_ios
//
//  Created by SHUBHAM on 16/07/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, onSearchButtonClicked: {
                    viewModel.resetSearch()
                    viewModel.searchRepositories(query: searchText)
                })
                if viewModel.isLoading && viewModel.repositories.isEmpty {
                    ProgressView("Loading...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    List {
                        ForEach(viewModel.repositories) { repository in
                            NavigationLink(destination: RepoDetailView(repository: repository)) {
                                RepositoryRow(repository: repository)
                                    .onAppear {
                                        if viewModel.repositories.last == repository {
                                            viewModel.searchRepositories(query: searchText)
                                        }
                                    }
                            }
                        }
                        
                        if viewModel.isLoading && !viewModel.repositories.isEmpty {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Repositories")
        }
        .onAppear {
            viewModel.searchRepositories(query: "swift") // Default search query
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    var onSearchButtonClicked: () -> Void
    
    var body: some View {
        HStack {
            TextField("Search repositories", text: $text, onCommit: onSearchButtonClicked)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: onSearchButtonClicked) {
                Text("Search")
            }
            .padding(.trailing)
        }
    }
}

struct RepositoryRow: View {
    var repository: Repository
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(repository.name ?? "No name")
                .font(.headline)
            Text(repository.description ?? "No description")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}


#Preview {
    HomeView()
}
