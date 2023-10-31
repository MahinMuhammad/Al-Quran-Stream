//
//  ContentView.swift
//  Al Quran Stream
//
//  Created by Md. Mahinur Rahman on 10/30/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @State var selected:Int?
    var body: some View {
        NavigationStack {
            VStack {
                List(viewModel.surahs, selection:$selected){ surah in
                    Button{
                        viewModel.loadAudio(of: String(surah.id))
                    }label: {
                        HStack{
                            Text(surah.name.transliteration.en)
                            Spacer()
                            Text(surah.name.short)
                            Image(systemName: K.audioStatusIcon.downloadingIcon)
                                .foregroundStyle(Color(UIColor.tintColor))
                        }
                    }
                }
                .listStyle(.plain)
                
                RoundedRectangle(cornerRadius: 48)
                    .stroke(lineWidth: 1)
                    .frame(height: 100)
                    .overlay {
                        HStack{
                            Button{
                                if (selected != nil && selected != 1){
                                    selected! -= 1
                                }
                            }label: {
                                Image(systemName: "chevron.left.to.line")
                                    .resizable()
                                    .frame(width: 30, height: 40)
                                    .foregroundStyle(Color(UIColor.label))
                            }
                            
                            Spacer()
                            
                            Button{
                                viewModel.playPauseButtonPressed()
                            }label: {
                                Image(systemName: /*viewModel.player.isPlaying ? "pause.circle" :*/ "play.circle")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundStyle(Color(UIColor.label))
                            }
                            
                            Spacer()
                            
                            Button{
                                if (selected != nil && selected != viewModel.surahs.count){
                                    selected! += 1
                                }
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
