//
//  DetailBeerView.swift
//  SwiftUI-MV
//
//  Created by GoEun Jeong on 2021/05/12.
//

import Kingfisher
import SwiftUI

struct DetailBeerView: View {
    let beer: Beer

    var body: some View {
        VStack(spacing: 5) {
            KFImage(URL(string: beer.imageURL ?? ""))
                .resizable()
                .scaledToFit()
                .frame(height: UIFrame.UIHeight / 2.5)

            Text(String(beer.id ?? 0))
                .foregroundColor(.orange)
                .font(.caption)

            Text(beer.name ?? "")
            Text(beer.description ?? "")
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(.gray)

            Spacer()

        }.frame(width: UIFrame.UIWidth - 60)
    }
}

struct DetailBeerView_Previews: PreviewProvider {
    static var previews: some View {
        DetailBeerView(beer: Bundle.getSingleBeerJson().first!)
    }
}
