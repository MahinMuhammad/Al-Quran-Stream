//
//  ContentView.swift
//  Al Quran Stream
//
//  Created by Md. Mahinur Rahman on 10/30/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @StateObject var networkState = MonitoringNetworkState()
    @State var selected:Int?
    @State var degrees: Double = 0
    var body: some View {
        let baseAnimation = Animation.easeInOut(duration: 1)
        let repeated = baseAnimation.repeatForever(autoreverses: true)
        ScrollViewReader{ scrollView in
            VStack {
                List(viewModel.surahs, selection:$selected){ surah in
                    HStack{
                        Text(surah.name.transliteration.en)
                            .fontWeight(surah.playing ?? false ? .semibold : .medium)
                        Spacer()
                        Text(surah.name.short)
                        if surah.playing ?? false{
                            Image(systemName: "waveform")
                                .foregroundStyle(.tint)
                                .rotation3DEffect(.degrees(degrees), axis: (x: 1, y: 0, z: 0))
                                .onAppear{
                                    withAnimation(repeated) {
                                        degrees = degrees == 0 ? 180 : 0
                                    }
                                }
                        }
                    }
                    .font(.system(size: surah.playing ?? false ? 25 : 19))
                    .foregroundStyle(surah.playing ?? false ? Color(UIColor.systemBackground) : Color(UIColor.label))
                    .listRowBackground(Color.clear)
                }
                .padding()
                .listStyle(.plain)
                .onChange(of: selected) { numberOfSurah in
                    if let numberOfSurah{
                        viewModel.loadAudio(of: numberOfSurah)
                    }
                }
                
                RoundedRectangle(cornerRadius: 50)
                    .foregroundStyle(Color(K.CustomColors.Pest))
                    .opacity(0.5)
                    .overlay {
                        VStack {
                            HStack{
                                Button{
                                    if (selected != nil && selected != 1){
                                        selected! -= 1
                                        withAnimation {
                                            if let number = viewModel.getSelectedSurahNumber(){
                                                scrollView.scrollTo(number-1)
                                            }
                                        }
                                    }
                                }label: {
                                    Image(K.NextIcon)
                                        .resizable()
                                        .scaleEffect(x: -1, y: 1)
                                        .frame(width: 30, height: 30)
                                        .foregroundStyle(Color(UIColor.label))
                                }
                                
                                Spacer()
                                
                                if viewModel.buttonStatus == .playPause{
                                    Button{
                                        viewModel.playPauseButtonPressed()
                                        withAnimation {
                                            if let number = viewModel.getSelectedSurahNumber(){
                                                scrollView.scrollTo(number)
                                            }
                                        }
                                    }label: {
                                        Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                            .resizable()
                                            .frame(width: 55, height: 55)
                                            .foregroundStyle(Color(UIColor.label))
                                    }
                                }else if viewModel.buttonStatus == .reload{
                                    Button{
                                        withAnimation {
                                            viewModel.replaySurah()
                                        }
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
                                        selected! += 1
                                        withAnimation {
                                            if let number = viewModel.getSelectedSurahNumber(){
                                                scrollView.scrollTo(number+1)
                                            }
                                        }
                                    }
                                }label: {
                                    Image(K.NextIcon)
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundStyle(Color(UIColor.label))
                                }
                            }
                            
                            Text(viewModel.getSelectedSurahName() ?? "")
                                .font(.callout)
                                .padding(5)
                        }
                        .padding(70)
                        .padding(.bottom,-20)
                    }
                    .frame(height: 150)
                    .padding(.bottom, -35)
            }
            .onReceive(viewModel.finishPlayingNotification){ _ in
                withAnimation {
                    viewModel.buttonStatus = .reload
                }
            }
            .onReceive(viewModel.playPauseNotification){ _ in
                if viewModel.player?.rate == 1.0{
                    viewModel.isPlaying = true
                }else if viewModel.player?.rate == 0.0{
                    viewModel.isPlaying = false
                }
            }
            .background{
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }
            .onAppear{
                viewModel.loadSurah()
            }
            //fatching data after being online
            .onChange(of: networkState.isConnected) { connected in
                if connected{
                    viewModel.loadSurah()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
