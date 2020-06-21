//
//  CardModel.swift
//  MatchApp
//
//  Created by Ron Jefferson on 2020/05/15.
//  Copyright © 2020年 Ron Jefferson. All rights reserved.
//

import Foundation

class CardModel {
    
    // Cardというデータが入ってる配列を返す関数getCardsを定義
    func getCards() -> [Card] {
        
        // randomNumberを入れる空配列を生成
        var numbers = [Int]()
        // 生成したCardを入れる空配列を生成
        var generatedCards = [Card]()
        
        // 2枚組で８枚のカードをランダムに選択
        // generatedCardsの中身が16個未満である限りループする
        while generatedCards.count < 16 {
            
            // 1から13のランダムな数字を選択
            let randomNumber = Int.random(in: 14...25)
            
            // 選択されたランダムな数字がnumbers配列に既に入ってる場合、
            if numbers.contains(randomNumber) {
                
                // 何もしない
                
              // まだ入ってない場合、
            } else {
                
                // Cardを2つ生成
                let cardOne = Card()
                let cardTwo = Card()
                
                // 生成された2つのCardの写真プロパティ名を同じにする
                cardOne.imageName = "card\(randomNumber)"
                cardTwo.imageName = "card\(randomNumber)"
                
                // 2つのCardをgeneratedCards配列に追加
                generatedCards += [cardOne, cardTwo]
                // numbersにrandomNumberを追加
                numbers += [randomNumber]
                
            }
            
        }
        
        // generatedCards配列の中身をシャッフル
        generatedCards.shuffle()
        
        // returnとしてgeneratedCards配列を設定
        return generatedCards
        
    }
    
}
