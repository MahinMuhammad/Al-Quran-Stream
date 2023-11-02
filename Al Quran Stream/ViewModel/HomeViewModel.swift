//
//  HomeViewModel.swift
//  Al Quran Stream
//
//  Created by Md. Mahinur Rahman on 10/30/23.
//

import Foundation
import AVFoundation
import SwiftUI

enum MasterButtonStatus{
    case playPause
    case reload
}

final class HomeViewModel:ObservableObject{
    let networkManager = NetworkManager()
    @Published var surahs:[SurahModel] = []
    
    @Published var player:AVPlayer?
    @Published var playing = false
    @Published var buttonStatus = MasterButtonStatus.playPause
    
    let impactMed = UIImpactFeedbackGenerator(style: .soft)
    let finishPlayingNotification = NotificationCenter.default.publisher(for: AVPlayerItem.didPlayToEndTimeNotification)
    
    
    func loadSurah(){
        networkManager.fetchData { surahs, error in
            if surahs.count > 0{
                self.surahs = surahs
            }
        }
    }
    
    func replaySurah(){
        impactMed.impactOccurred()
        player?.seek(to: .zero)
        player?.play()
        playing = true
        buttonStatus = .playPause
    }
    
    func playPauseButtonPressed(){
        if let player{
            impactMed.impactOccurred()
            if player.timeControlStatus == .playing{
                player.pause()
                playing = false
            }else{
                player.play()
                playing = true
            }
        }else{
            print("AVPlayer not loaded")
        }
    }
    
    func selectSurah(_ number:Int){
        for index in 0..<surahs.count{
            if surahs[index].number == number{
                surahs[index].playing = true
            }else{
                surahs[index].playing = false
            }
        }
    }
    
    func getSelectedSurahNumber()->Int?{
        for surah in surahs{
            if surah.playing ?? false{
                return surah.number
            }
        }
        return nil
    }
    
    func getSelectedSurahName()->String?{
        for surah in surahs{
            if surah.playing ?? false{
                return "\(surah.name.transliteration.en) \(surah.name.short)"
            }
        }
        return nil
    }
    
    func loadAudio(of number:Int){
        if let url = URL(string: "https://cdn.islamic.network/quran/audio-surah/128/ar.alafasy/\(number).mp3"){
            withAnimation {
                selectSurah(number)
            }
            impactMed.impactOccurred()
            let item = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: item)
            player?.play()
            buttonStatus = .playPause
            playing = true
        }
    }
}
