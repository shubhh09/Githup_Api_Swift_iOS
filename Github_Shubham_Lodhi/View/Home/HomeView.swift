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
                
                if viewModel.errorMessage == nil {
                    if viewModel.repositories.isEmpty && !viewModel.isLoading{
                        Spacer(minLength: 100)
                        Text("No data found")
                            .font(.title3)
                            .fontWeight(.regular)
                            .multilineTextAlignment(.center)
                            .background(.clear)
                            .foregroundStyle(.gray.opacity(0.7))
                    }
                }
                
                if viewModel.isLoading && viewModel.repositories.isEmpty {
                    ProgressView("Loading...")
                } else if let errorMessage = viewModel.errorMessage {
                    Spacer(minLength: 100)
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .safeAreaPadding()
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
                        .listStyle(.plain)
                        .listRowSeparator(.hidden)
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 5)
                                .background(.white)
                                .foregroundColor(.clear)
                                .padding(
                                    EdgeInsets(
                                        top: 2,
                                        leading: 0,
                                        bottom: 2,
                                        trailing: 0
                                    )
                                )
                        )
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
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            if !NetworkReachabilityManager.shared.isConnectedToNetwork || viewModel.repositories.isEmpty {
                viewModel.loadRepositoriesFromCoreData()
                return
            }
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
