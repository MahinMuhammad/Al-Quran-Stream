//
//  SurahModel.swift
//  Al Quran Stream
//
//  Created by Md. Mahinur Rahman on 10/31/23.
//

/*
 Copyright 2023 Md. Mahinur Rahman
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Foundation

struct Result:Decodable{
    let data:[SurahModel]
}

struct SurahModel:Decodable, Identifiable{
    var id:Int{
        return number
    }
    let number:Int
    let name:Name
    let numberOfVerses:Int
    var playing:Bool?
}

struct Name:Decodable{
    let short:String
    let transliteration:Transliteration
}

struct Transliteration:Decodable{
    let en:String
}
