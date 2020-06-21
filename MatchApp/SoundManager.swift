//
//  SoundManager.swift
//  MatchApp
//
//  Created by Ron Jefferson on 2020/05/18.
//  Copyright © 2020年 Ron Jefferson. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect {
        
        case flip
        case match
        case nomatch
        case shuffle
        
    }
    
    func playSound(effect:SoundEffect) {
        
        var soundFilename = ""
        
        switch effect {
            
            case .flip:
                soundFilename = "cardflip"
            
            case .match:
                soundFilename = "dingcorrect"
            
            case .nomatch:
                soundFilename = "dingwrong"
            
            case .shuffle:
                soundFilename = "shuffle"
            
        }
        
        // 音源へのパスをし取得
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: ".wav")
        
        // bundlePathがnilではないことをチェック
        guard bundlePath != nil else {
            // 音源を見つからない場合は, exit
            return
        }
        
        let url = URL(fileURLWithPath: bundlePath!)
        
        do {
            
            // 音源プレヤーを生成
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            
            // 効果音を再生
            audioPlayer?.play()
            
        }
        catch {
            print("音源を再生できません")
            return
        }
        
    }
    
}
