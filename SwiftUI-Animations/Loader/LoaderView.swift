//
//  LoaderView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 12/08/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI


struct LoaderView: View {
    
    @State var animateLoaders: Bool = false
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            ZStack {
                Loader(loaderState: .down, timerDuration: 0.35, startAnimating: $animateLoaders)
                Loader(loaderState: .right, timerDuration: 1.05, startAnimating: $animateLoaders)
                Loader(loaderState: .up, timerDuration: 1.75, startAnimating: $animateLoaders)
            }.offset(x: -40, y: -40)
        }.onTapGesture {
            self.animateLoaders.toggle()
            print(self.animateLoaders)
        }
    }
}

struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView()
    }
}
