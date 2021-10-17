//
//  ContentView.swift
//  SwiftUI-MV
//
//  Created by GoEun Jeong on 2021/05/12.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            BeerListView()
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("Beer List")
                }
            SearchBeerView()
                .tabItem {
                    Image(systemName: "2.circle")
                    Text("Search ID")
                }

            RandomBeerView()
                .tabItem {
                    Image(systemName: "3.circle")
                    Text("Random")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
