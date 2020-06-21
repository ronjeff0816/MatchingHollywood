//
//  CardCollectionViewCell.swift
//  MatchApp
//
//  Created by Ron Jefferson on 2020/05/15.
//  Copyright © 2020年 Ron Jefferson. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    func configureCell(card:Card) {
        
        // Keep track of the card this cell represents
        self.card = card 
        
        // 表カードを設定
        frontImageView.image = UIImage(named: card.imageName)
        
        // Reset the state of the cell by checking the flipped status of the card and then showing the front or the back imageview accordingly
        if card.isMatched == true {
            backImageView.alpha = 0
            frontImageView.alpha = 0
            return
        }
        else {
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        
        if card.isFlipped == true {
            
            //表のカードを表示
            flipUp(speed: 0)
            
        }
        else {
          
            //裏のカードを表示
            flipDown(speed: 0, delay: 0)
            
        }
        
    }
    
    func flipUp(speed:TimeInterval = 0.3) {
        
        // 裏から表を表示するアニメーション
        UIView.transition(from: backImageView, to: frontImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        
        // カードのステータスを設定
        card?.isFlipped = true
        
    }
    
    func flipDown(speed: TimeInterval = 0.3, delay:TimeInterval = 0.5) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
         
        // 表から裏を表示するアニメーション
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
            
        }
        
        // カードものステータスを設定
        card?.isFlipped = false
        
    }
    
    func remove() {
        
        // マッチしたカードの裏面をviewから消す(0~1 opacity)
        backImageView.alpha = 0
        
        // マッチしたカードの表面をviewから消す (アニメーション付)
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            
            self.frontImageView.alpha = 0
            
        }, completion: nil)
        
    }
    
}
