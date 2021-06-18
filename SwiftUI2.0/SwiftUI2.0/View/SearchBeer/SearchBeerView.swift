//
//  SearchBeerView.swift
//  SwiftUI-MV
//
//  Created by GoEun Jeong on 2021/05/12.
//

import SwiftUI

struct SearchBeerView: View {
    @ObservedObject var viewModel = SearchBeerViewModel()

    var body: some View {
        NavigationView {
            VStack {
                // MARK: - Search Bar

                HStack {
                    TextField("Search ...", text: $viewModel.text, onCommit: {
                        viewModel.apply(.search)
                    })
                        .padding(7)
                        .padding(.horizontal, 25)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 8)

                                if viewModel.isEditing {
                                    Button(action: {
                                        viewModel.text = ""
                                    }) {
                                        Image(systemName: "multiply.circle.fill")
                                            .foregroundColor(.gray)
                                            .padding(.trailing, 8)
                                    }
                                }
                            }
                        )
                        .padding(.horizontal, 10)
                        .onTapGesture {
                            viewModel.isEditing = true
                        }

                    if viewModel.isEditing {
                        Button(action: {
                            viewModel.isEditing = false
                            viewModel.text = ""

                            // Dismiss the keyboard
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }) {
                            Text("Cancel")
                        }
                        .padding(.trailing, 10)
                        .transition(.move(edge: .trailing))
                        .animation(.default)
                    }
                }
                ZStack {
                    VStack {
                        SingleBeerView(beer: $viewModel.beer)
                        Spacer()
                    }
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(2.0, anchor: .center)
                    }
                }

            }.navigationBarTitle("Search By ID", displayMode: .large)
        }
    }
}

struct SearchBeerView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBeerView(viewModel: SearchBeerViewModel())
    }
}
