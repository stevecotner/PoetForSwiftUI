//
//  ViewDemoListView.swift
//  Poet
//
//  Created by Steve Cotner on 6/8/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct ViewDemoListView: View {
    @ObservedObject var demoProviders: ObservableArray<NamedDemoProvider>
    let evaluator: ViewDemoList.Evaluator
    
    var body: some View {
        ScrollView {
            Text("View Demos")
                .font(Font.headline)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 22)
            
            Spacer().frame(height: 40)
            
            HStack {
                Text("Build your own demo:")
                    .font(Font.subheadline.bold())
                    .foregroundColor(Color.primary.opacity(0.4))
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(EdgeInsets(top: 0, leading: 30, bottom: 10, trailing: 30))
                Spacer()
            }
            
            Button(action: {
                self.evaluator.evaluate(ViewDemoList.Evaluator.Action.showDemoBuilder)
            }) {
                HStack {
                    Spacer().frame(width: 30)
                    Text("Demo Builder")
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .opacity(0.3)
                    Spacer().frame(width: 20)
                }
            }
            .foregroundColor(.primary)
            
            Spacer().frame(height: 40)
            
            HStack {
                Text("Or choose a view to see its demo:")
                    .font(Font.subheadline.bold())
                    .foregroundColor(Color.primary.opacity(0.4))
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(EdgeInsets(top: 0, leading: 30, bottom: 10, trailing: 30))
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 20) {
                ForEach(self.demoProviders.array, id: \.id) { provider in
                    Button(action: {
                        self.evaluator.evaluate(ViewDemoList.Evaluator.Action.showDemo(provider))
                    }) {
                        HStack {
                            Spacer().frame(width: 30)
                            Text(provider.title)
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .opacity(0.3)
                            Spacer().frame(width: 20)
                        }
                    }
                    .foregroundColor(.primary)
                }
                Spacer()
            
            }.frame(maxWidth: .infinity)
            
            Spacer()
        }
    }
}
