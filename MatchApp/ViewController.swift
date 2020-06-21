//
//  ViewController.swift
//  MatchApp
//
//  Created by Ron Jefferson on 2020/05/15.
//  Copyright © 2020年 Ron Jefferson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    let model = CardModel()
    var cardsArray = [Card]()
    var firstFlippedCardIndex:IndexPath?
    var timer:Timer?
    var milliseconds:Int = 25 * 1000
    var soundPlayer = SoundManager()

    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        cardsArray = model.getCards()
        
        // ViewControllerがcollectionViewのdatasourceとdelegateになるようにて設定
        // self = このファイル自体 = ViewController
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Initialize the timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timeFired), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        // シャッフル音を再生
        soundPlayer.playSound(effect: .shuffle)
        
    }
    
    
    
    // MARK: - Timer Methods
    
    
    @objc func timeFired() {
        
        // Decrement the counter
        milliseconds -= 1
        
        // Update the label
        let seconds:Double = Double(milliseconds)/1000.0
        timerLabel.text = String(format: "Time Remaining: %.2f", seconds)
        
        // ０秒になったらタイマーを赤にして、止める
        if milliseconds == 0 {
            
            timerLabel.textColor = UIColor.red
            timer?.invalidate()
         
            // 全カードをクリアしたかチェック
            checkForGameEnd()
            
        }
        
    }
    
    
    
    // MARK: - Collection View Delegate Methods
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // カードを何枚にするか設定
        return cardsArray.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // セルを取得
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // セルをreturn
        return cell
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // Configure the state of the cell based on the properties of the Card that it represents
        
        let cardCell = cell as? CardCollectionViewCell
        
        // cardArrayからcardを取得
        let card = cardsArray[indexPath.row]
        
        // Finish configuring the cell
        cardCell?.configureCell(card: card)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // タイマーがゼロになったら、もうプレーできないようにする
        if milliseconds <= 0 {
            return
        }
        
        // どのセルがタップされたかを特定する
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        // Check the status of the card to determine how to flip it
        if cell?.card?.isFlipped == false && cell?.card?.isMatched == false {
            
            // カードをフリップして表にする
            cell?.flipUp()
            
            // 表にフリップされた時の音を再生
            soundPlayer.playSound(effect: .flip)
            
            
            // １枚目にフリップされたカードか2枚目なのかをチェック
            if firstFlippedCardIndex == nil {
                
                // これが１枚目のカード
                firstFlippedCardIndex = indexPath
                
            }
            else {
                
                // これが２枚目のカードの場合
                // 比較するロジックを実行
                checkForMatch(indexPath)
                
            }
        }
        
    }

    
    
    // MARK: - Game Logic Methods
    
    
    func checkForMatch(_ secondFlippedCardIndex:IndexPath) {
        
        // Get the two card objects for the two indices and see if they match
        
        let cardOne = cardsArray[firstFlippedCardIndex!.row]
        let cardTwo = cardsArray[secondFlippedCardIndex.row]
        
        // Get the two collection view cells that represent cardOne and cardTwo
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // 2つのカード名を比較
        if cardOne.imageName == cardTwo.imageName {
            
            // 同名 = マッチだったら、
            // マッチした時の音を再生
            soundPlayer.playSound(effect: .match)
            // ステータスを変更し、対象外にする
            cardOne.isMatched = true
            cardTwo.isMatched = true
            // セルを削除
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // マッチしたのは最後のペア？
            checkForGameEnd()
            
        }
        else {
            
            // 同名じゃない = マッチじゃない
            // マッチじゃない時の音を再生
            soundPlayer.playSound(effect: .nomatch)
            
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // ２枚ともまた裏返す
            cardOneCell?.flipDown()
            cardTwoCell?.flipDown()
            
        }
        
        // firstFlippedCardIndexプロパティをリセット
        firstFlippedCardIndex = nil
        
    }
    
    
    
    func checkForGameEnd() {
        
        // まだマッチされてないカードあるかチェック
        // ユーザーが勝利したという設定で, ループを使って全カードがマッチされたか確認する
        var hasWon = true
        
        for card in cardsArray {
            
            if card.isMatched == false {
                // まだマッチされてないカードを発見
                hasWon = false
                break
            }
        }
        
        if hasWon == true {
            
            // ユーザーが勝利した > 勝ちのアラートを表示
            showAlert(title: "おめでとう!", message: "全てをマッチさせました！")
            
        }
        else {
            
            // まだ勝利してない > まだタイマーに時間あるかを調査 > ０の場合は負けのアラートを表示
            if milliseconds <= 0 {
                
                showAlert(title: "終了！", message: "ドンマイです")
                
            }
            
        }
        
    }
    
    
    
    func showAlert(title:String, message:String) {
        
        // アラートを作成
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Alertを消すためのOKボタンを追加
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        // アラートを表示
        present(alert, animated: true, completion: nil)
    
    }
    
    
    
}

