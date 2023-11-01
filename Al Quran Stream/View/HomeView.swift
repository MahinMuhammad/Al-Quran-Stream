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
        VStack {
            List(viewModel.surahs, selection:$selected){ surah in
                HStack{
                    Text(surah.name.transliteration.en)
                    Spacer()
                    Text(surah.name.short)
                }
            }
            .listStyle(.plain)
            .onChange(of: selected) { numberOfSurah in
                if let numberOfSurah{
                    viewModel.loadAudio(of: String(numberOfSurah))
                }
            }
            
            RoundedRectangle(cornerRadius: 48)
                .stroke(lineWidth: 1)
                .frame(height: 100)
                .overlay {
                    HStack{
                        Button{
                            if (selected != nil && selected != 1){
                                viewModel.buttonStatus = .playPause
                                selected! -= 1
                            }
                        }label: {
                            Image(systemName: "chevron.left.to.line")
                                .resizable()
                                .frame(width: 30, height: 40)
                                .foregroundStyle(Color(UIColor.label))
                        }
                        
                        Spacer()
                        
                        if viewModel.buttonStatus == .playPause{
                            Button{
                                viewModel.playPauseButtonPressed()
                            }label: {
                                Image(systemName: viewModel.playing ? "pause.circle.fill" : "play.circle.fill")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .foregroundStyle(Color(UIColor.label))
                            }
                        }else if viewModel.buttonStatus == .reload{
                            Button{
                                viewModel.replaySurah()
                            }label: {
                                Image(systemName: "arrow.2.circlepath")
                                    .resizable()
                                    .frame(width: 65, height: 55)
                                    .foregroundStyle(Color(UIColor.label))
                            }
                        }
                        
                        Spacer()
                        
                        Button{
                            if (selected != nil && selected != viewModel.surahs.count){
                                viewModel.buttonStatus = .playPause
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
            viewModel.loadSurah()
        }
        .onReceive(viewModel.finishPlayingNotification){ _ in
            viewModel.playing = false
            viewModel.buttonStatus = .reload
        }
    }
}

#Preview {
    HomeView()
}
