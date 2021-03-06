//
//  TableOfContentsView.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/21/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct TableOfContentsView<E: ActionEvaluating>: View {
    @ObservedObject var selectableChapterTitles: ObservableArray<NumberedNamedEvaluatorAction<E.Action>>
    let evaluator: E
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var isShowingAbout = false
    
    var body: some View {
        ZStack {
            VStack {
                
                Spacer()
            }.zIndex(2)
            
            VStack {
                DismissButton(orientation: .right)
                    .zIndex(2)
                Spacer()
            }.zIndex(2)
            
            VStack(spacing: 0) {
                Spacer().frame(height:30)
                HStack {
                    Text("Table of Contents")
                        .multilineTextAlignment(.leading)
                        .font(Font.system(size: 18, weight: .semibold))
                    Spacer()
                }.padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
                Spacer().frame(height:15)
                
                ScrollView {
                    
                    // Chapters
                    
                    ForEach(self.selectableChapterTitles.array, id: \.id) { item in
                        Button(action: {
                            self.evaluator.evaluate(item.action)
                            afterWait(100) {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }) {
                            VStack(spacing: 0) {
                                Spacer().frame(height: 17)
                                
                                HStack {
                                    Text("\(item.number).   " + item.name)
                                    Spacer()
                                }
                                .padding(.trailing, 30)
                                .font(Font.body.monospacedDigit())
                                .multilineTextAlignment(.leading)
                                
                                Spacer().frame(height: 17)
                                
                                Divider()
                                    .opacity(0.45)
                            }
                        }
                        .foregroundColor(.primary)
                        .padding(.leading, 30)
                    }
                    
                    // About
                    Button(action: { self.isShowingAbout.toggle() }) {
                        HStack(spacing: 0) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Spacer().frame(width: 20)
                            Text("About Poet")
                            Spacer()
                        }
                        .foregroundColor(Color.primary)
                            .padding(EdgeInsets(top: 10, leading: 30, bottom: 8, trailing: 30))
                            .sheet(isPresented: self.$isShowingAbout) {
                                About.Screen()
                            }
                    }
                        
                    Divider()
                        .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 0))
                        .opacity(0.45)
                    
                    // Github
                    
                    Button(action: {
                        if let url = URL(string: "https://github.com/stevecotner/PoetForSwiftUI") {
                            UIApplication.shared.open(url as URL)
                        }
                    }) {
                        HStack(spacing: 0) {
                            Image(systemName: "cursor.rays")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Spacer().frame(width: 20)
                            Text("Github: PoetForSwiftUI")
                            Spacer()
                        }
                        .foregroundColor(Color.primary)
                            .padding(EdgeInsets(top: 10, leading: 30, bottom: 8, trailing: 30))
                            .sheet(isPresented: self.$isShowingAbout) {
                                About.Screen()
                            }
                    }
                }
                
                
            }.background(Rectangle().fill(Color(UIColor.systemBackground)))
        }
    }
}
