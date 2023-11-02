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
    @Published var surahs:[SurahModel] = [] //all the surah details not the audio
    
    @Published var player:AVPlayer?
    @Published var isPlaying = false //play pause button icon state
    @Published var buttonStatus = MasterButtonStatus.playPause //media player center button can be play pause button or reload button
    
    let impactMed = UIImpactFeedbackGenerator(style: .soft)
    let finishPlayingNotification = NotificationCenter.default.publisher(for: AVPlayerItem.didPlayToEndTimeNotification)
    let playPauseNotification = NotificationCenter.default.publisher(for: AVPlayer.rateDidChangeNotification)
    
    //to populate surahs[]
    func loadSurah(){
        networkManager.fetchData { surahs, error in
            if surahs.count > 0{
                self.surahs = surahs
            }
        }
    }
    
    //function to re-play a finished playing surah
    func replaySurah(){
        impactMed.impactOccurred()
        player?.seek(to: .zero)
        player?.play()
        buttonStatus = .playPause
    }
    
    func playPauseButtonPressed(){
        if let player{
            impactMed.impactOccurred()
            if player.timeControlStatus == .playing{
                player.pause()
            }else{
                player.play()
            }
        }else{
            print("AVPlayer not loaded")
        }
    }
    
    //mark a surah from surahs when it is being played
    func selectSurah(_ number:Int){
        for index in 0..<surahs.count{
            if surahs[index].number == number{
                surahs[index].playing = true
            }else{
                surahs[index].playing = false
            }
        }
    }
    
    //bellow two functions are to get number and name of the surahs being played
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
    
    //load the audio of a sura from url to AVPlayer
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
        }
    }
}
