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
            ZStack {
                VStack {
                    SingleBeerView(beer: $viewModel.beer)
                    Spacer(minLength: 0)
                }.searchable(text: $viewModel.text)
                    .onSubmit(of: .search, {
                        viewModel.apply(.search)
                    })
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2.0, anchor: .center)
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
