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
                        .font(.title3)
                        .fontWeight(.medium)
                    Spacer()
                    Text(surah.name.short)
                }
                .listRowBackground(Color.clear)
            }
            .padding()
            .listStyle(.plain)
            .onChange(of: selected) { numberOfSurah in
                if let numberOfSurah{
                    viewModel.loadAudio(of: String(numberOfSurah))
                }
            }
            
            RoundedRectangle(cornerRadius: 50)
                .foregroundStyle(Color(K.CustomColors.Pest))
                .opacity(0.5)
                .overlay {
                    HStack{
                        Button{
                            if (selected != nil && selected != 1){
                                viewModel.buttonStatus = .playPause
                                selected! -= 1
                            }
                        }label: {
                            Image("next")
                                .resizable()
                                .scaleEffect(x: -1, y: 1)
                                .frame(width: 60, height: 60)
                                .foregroundStyle(Color(UIColor.label))
                        }
                        
                        Spacer()
                        
                        if viewModel.buttonStatus == .playPause{
                            Button{
                                viewModel.playPauseButtonPressed()
                            }label: {
                                Image(systemName: viewModel.playing ? "pause.circle.fill" : "play.circle.fill")
                                    .resizable()
                                    .frame(width: 90, height: 90)
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
                            Image("next")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundStyle(Color(UIColor.label))
                        }
                    }
                    .padding(50)
                }
                .frame(height: 150)
                .padding(.bottom, -35)
        }
        
        .onAppear{
            viewModel.loadSurah()
        }
        .onReceive(viewModel.finishPlayingNotification){ _ in
            viewModel.playing = false
            viewModel.buttonStatus = .reload
        }
        .background{
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
    }
}

#Preview {
    HomeView()
}
