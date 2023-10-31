//
//  ContentView.swift
//  Al Quran Stream
//
//  Created by Md. Mahinur Rahman on 10/30/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    var body: some View {
        NavigationStack {
            VStack {
                List(viewModel.surahs){ surah in
                    HStack{
                        Text(surah.name.transliteration.en)
                        Spacer()
                        Text(surah.name.short)
                    }
                }
                .listStyle(.plain)
                
                RoundedRectangle(cornerRadius: 48)
                    .stroke(lineWidth: 1)
                    .frame(height: 100)
                    .overlay {
                        HStack{
                            Button{
                                
                            }label: {
                                Image(systemName: "chevron.left.to.line")
                                    .resizable()
                                    .frame(width: 30, height: 40)
                                    .foregroundStyle(Color(UIColor.label))
                            }
                            
                            Spacer()
                            
                            Button{
                                viewModel.playing.toggle()
                            }label: {
                                Image(systemName: viewModel.playing ? "play.circle" : "pause.circle")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundStyle(Color(UIColor.label))
                            }
                            
                            Spacer()
                            
                            Button{
                                
                            }label: {
                                Image(systemName: "chevron.right.to.line")
                                    .resizable()
                                    .frame(width: 30, height: 40)
                                    .foregroundStyle(Color(UIColor.label))
                            }
                        }
                        .padding(50)
                    }
            }
            .padding()
            .onAppear{
    //            viewModel.loadSurah()
            }
            .toolbar{
                ToolbarItem{
                    Button{
                        viewModel.loadSurah()
                    }label: {
                        Image(systemName: "icloud.and.arrow.down")
                    }
                }
        }
        }
    }
}

#Preview {
    HomeView()
}
