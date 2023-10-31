//
//  SurahModel.swift
//  Al Quran Stream
//
//  Created by Md. Mahinur Rahman on 10/31/23.
//

import Foundation

struct Result:Decodable{
    let data:SurahModel
}

struct SurahModel:Decodable, Identifiable{
    var id:Int{
        return number
    }
    let number:Int
    let name:Name
    let numberOfVerses:Int
    let verses:[Verse]
}

struct Name:Decodable{
    let short:String
    let transliteration:Transliteration
}

struct Transliteration:Decodable{
    let en:String
}

struct Verse:Decodable{
    let audio:Audio
}

struct Audio:Decodable{
    let primary:String
}
