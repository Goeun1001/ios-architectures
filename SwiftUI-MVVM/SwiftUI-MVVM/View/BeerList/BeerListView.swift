//
//  BeerListView.swift
//  SwiftUI-MV
//
//  Created by GoEun Jeong on 2021/05/12.
//

import SwiftUI
import Kingfisher
import Introspect

struct BeerListView: View {
    @ObservedObject var viewModel = BeerListViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(viewModel.beers, id: \.id) { beer in
                        ZStack {
                            BeerListRow(beer: beer)
                                .onAppear {
                                    viewModel.checkNextPage(id: beer.id ?? 0)
                                }
                            NavigationLink(
                                destination: DetailBeerView(beer: beer)) { }
                                .frame(width: 0, height: 0)
                                .hidden()
                        }
                    }
                    
                }.listStyle(PlainListStyle())
                .introspectTableView { scrollView in
                    let refresh = UIRefreshControl()
                    refresh.addTarget(viewModel, action: #selector(viewModel.refresh), for: .valueChanged)
                    scrollView.refreshControl = refresh
                    viewModel.refreshControl = refresh
                }
                
                ActivityIndicator(isAnimating: $viewModel.isLoading, style: .large)
            }
            
            .alert(isPresented: $viewModel.isErrorAlert) {
                Alert(title: Text(""), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
            }
            .navigationBarTitle("BeerList", displayMode: .large)
        }
        
        .onAppear() {
            viewModel.onAppear()
        }
    }
}

struct BeerListRow: View {
    let beer: Beer
    
    var body: some View {
        HStack {
            KFImage(URL(string: beer.imageURL ?? ""))
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            VStack(alignment: .leading) {
                Text(String(beer.id ?? 0))
                    .foregroundColor(.orange)
                    .font(.caption)
                Text(beer.name ?? "")
                Text(beer.description ?? "")
                    .foregroundColor(.gray)
                    .lineLimit(3)
            }
        }
    }
}

struct BeerListView_Previews: PreviewProvider {
    static var previews: some View {
        BeerListView(viewModel: BeerListViewModel())
    }
}
