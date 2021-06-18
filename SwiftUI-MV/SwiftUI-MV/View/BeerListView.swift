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
    @State var beers: [Beer] = .init()
    @State var page = 1
    @State var isLoading = false
    @State var isErrorAlert = false
    @State var errorMessage = ""
    
    let networkingApi = NetworkingAPI()
    let refreshHelper = RefreshHelper()
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(beers, id: \.id) { beer in
                        ZStack {
                            BeerListRow(beer: beer)
                                .onAppear {
                                    checkNextPage(id: beer.id ?? 0)
                                }
                            NavigationLink(
                                destination: DetailBeerView(beer: beer)) { }
                                .frame(width: 0, height: 0)
                                .hidden()
                        }
                    }
                    
                }.listStyle(PlainListStyle())
                .introspectTableView { scrollView in
                    
                    let refreshControl = UIRefreshControl()
                    refreshControl.addTarget(refreshHelper, action: #selector(refreshHelper.refresh), for: .valueChanged)
                    scrollView.refreshControl = refreshControl
                    refreshHelper.refreshControl = refreshControl
                    refreshHelper.getBeerList = self.getBeerList
                }
                
                ActivityIndicator(isAnimating: $isLoading, style: .large)
            }
            
            .alert(isPresented: $isErrorAlert) {
                Alert(title: Text(""), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
            .navigationBarTitle("BeerList", displayMode: .large)
        }
        
        .onAppear() {
            getBeerList()
        }
    }
    
    func checkNextPage(id: Int) {
        if id == page * 25 {
            self.page += 1
            self.appendBeerList()
        }
    }
    
    func getBeerList() {
        self.isLoading = true
        self.page = 1
        networkingApi.request(.getBeerList(page: page)) { result in
            switch result {
            case let .success(beers):
                self.beers = beers
            case let .failure(error):
                self.errorMessage = error.localizedDescription
                self.isErrorAlert = true
            }
        }
        self.isLoading = false
    }
    
    func appendBeerList() {
        self.isLoading = true
        networkingApi.request(.getBeerList(page: page)) { result in
            switch result {
            case let .success(beers):
                self.beers += beers
            case let .failure(error):
                self.errorMessage = error.localizedDescription
                self.isErrorAlert = true
            }
        }
        self.isLoading = false
    }
    
}

class RefreshHelper {
    var getBeerList: ()-> () = { print("ERROR") }
    var refreshControl: UIRefreshControl?
    
    @objc func refresh() {
        refreshControl?.beginRefreshing()
        getBeerList()
        refreshControl?.endRefreshing()
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
        BeerListView(beers: Bundle.getBeerListJson())
    }
}
