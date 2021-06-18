//
//  RandomBeerView.swift
//  SwiftUI-MV
//
//  Created by GoEun Jeong on 2021/05/12.
//

import SwiftUI

struct RandomBeerView: View {
    @ObservedObject var viewModel = RandomBeerViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                SingleBeerView(beer: $viewModel.beer)
                VStack {
                    Button(action: {
                        viewModel.apply(.getRandom)
                    }) {
                        VStack {
                            Text("Roll Random")
                                .foregroundColor(.white)
                                .background(Rectangle().foregroundColor(.orange).frame(width: UIFrame.UIWidth - 100, height: 40))
                        }
                    }.padding(.top, UIFrame.UIHeight / 1.5)
                }
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2.0, anchor: .center)
                }
            }.navigationBarTitle("Random Beer", displayMode: .large)
        }.onAppear {
            viewModel.apply(.getRandom)
        }
    }
}

struct RandomBeerView_Previews: PreviewProvider {
    static var previews: some View {
        RandomBeerView(viewModel: RandomBeerViewModel())
    }
}
