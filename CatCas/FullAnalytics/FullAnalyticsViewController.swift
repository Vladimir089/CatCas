//
//  FullAnalyticsViewController.swift
//  CatCas
//
//  Created by Владимир Кацап on 11.09.2024.
//

import UIKit

class FullAnalyticsViewController: UIViewController {
    
    var topStatLabel, botStatLabel: UILabel?
    var biggestLostLabel, biggestWonLabel: UILabel?
    let progressView = CircularProgressView(frame: CGRect(x: 0, y: 0, width: 60, height: 60), lineWidth: 20, rounded: false)
    
    var typeGamesArr: [(String,Int)] = []
    var collection: UICollectionView?

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let backButtonAppearance = UIBarButtonItem.appearance()
        backButtonAppearance.tintColor = UIColor(red: 225/255, green: 28/255, blue: 165/255, alpha: 1)
        if let backButton = navigationController?.navigationBar.topItem?.backBarButtonItem {
            backButton.tintColor = UIColor(red: 225/255, green: 28/255, blue: 165/255, alpha: 1)
        }
        view.backgroundColor = UIColor(red: 14/255, green: 2/255, blue: 28/255, alpha: 1)
        createInterface()
        fillArr()
        check()
    }
    

    func createInterface() {
        let topLabel = UILabel()
        topLabel.text = "Full analytics"
        topLabel.textColor = .white
        topLabel.font = .systemFont(ofSize: 34, weight: .bold)
        view.addSubview(topLabel)
        topLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        let topView: UIView = {
            let view = UIView()
            view.layer.cornerRadius = 12
            view.backgroundColor = UIColor(hex: "#260E43")
            
            let topLabel = UILabel()
            topLabel.textColor = UIColor(hex: "#E11CA5")
            topLabel.font = .systemFont(ofSize: 22, weight: .bold)
            var numb = 0
            
            if gamesArr.count > 0 {
                for i in gamesArr {
                    if i.result == true {
                        numb += i.amount
                    }
                }
            }
    
            topLabel.text = "$ \(numb)"
            view.addSubview(topLabel)
            topLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(view.snp.centerY)
            }
            
            let botlabel = UILabel()
            botlabel.text = "The total amount of winnings"
            botlabel.textColor = .white.withAlphaComponent(0.7)
            botlabel.font = .systemFont(ofSize: 12, weight: .regular)
            view.addSubview(botlabel)
            botlabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(view.snp.centerY).offset(5)
            }
            
            return view
        }()
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(topLabel.snp.bottom).inset(-15)
            make.height.equalTo(68)
        }
        
        let secondView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(hex: "#260E43")
            view.layer.cornerRadius = 12
            view.addSubview(progressView)
            progressView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.height.width.equalTo(60)
                make.right.equalToSuperview().inset(20)
            }
            topStatLabel = {
                let label = UILabel()
                label.text = "0"
                label.textColor = UIColor(hex: "#E11CA5")
                label.font = .systemFont(ofSize: 34, weight: .bold)
                return label
            }()
            view.addSubview(topStatLabel!)
            topStatLabel?.snp.makeConstraints({ make in
                make.bottom.equalTo(view.snp.centerY)
                make.right.equalTo(progressView.snp.left).inset(-15)
            })
            
            
            botStatLabel = {
                let label = UILabel()
                label.text = "0"
                label.textColor = .white.withAlphaComponent(0.2)
                label.font = .systemFont(ofSize: 34, weight: .bold)
                return label
            }()
            view.addSubview(botStatLabel!)
            botStatLabel?.snp.makeConstraints({ make in
                make.top.equalTo(view.snp.centerY)
                make.right.equalTo(progressView.snp.left).inset(-15)
            })
            
            return view
        }()
        view.addSubview(secondView)
        secondView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(topView.snp.bottom).inset(-5)
            make.height.equalTo(106)
        }
        
        let leftView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(hex: "#260E43")
            view.layer.cornerRadius = 12
            
            biggestWonLabel = {
                let label = UILabel()
                label.text = "$ 0"
                label.font = .systemFont(ofSize: 22, weight: .bold)
                label.textColor = UIColor(hex: "#E11CA5")
                return label
            }()
            view.addSubview(biggestWonLabel!)
            biggestWonLabel?.snp.makeConstraints({ make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().inset(15)
            })
            
            let botLabel = UILabel()
            botLabel.text = "The biggest gain"
            botLabel.textColor = .white.withAlphaComponent(0.7)
            botLabel.font = .systemFont(ofSize: 12, weight: .regular)
            view.addSubview(botLabel)
            botLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().inset(10)
            }
            
            return view
        }()
        view.addSubview(leftView)
        leftView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.height.equalTo(68)
            make.top.equalTo(secondView.snp.bottom).inset(-5)
            make.right.equalTo(view.snp.centerX).offset(-2.5)
        }
        
        let rightView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(hex: "#260E43")
            view.layer.cornerRadius = 12
            
            biggestLostLabel = {
                let label = UILabel()
                label.text = "-$ 0"
                label.font = .systemFont(ofSize: 22, weight: .bold)
                label.textColor = .white.withAlphaComponent(0.2)
                return label
            }()
            view.addSubview(biggestLostLabel!)
            biggestLostLabel?.snp.makeConstraints({ make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().inset(15)
            })
            
            let botLabel = UILabel()
            botLabel.text = "The biggest loser"
            botLabel.textColor = .white.withAlphaComponent(0.7)
            botLabel.font = .systemFont(ofSize: 12, weight: .regular)
            view.addSubview(botLabel)
            botLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().inset(10)
            }
            
            return view
        }()
        view.addSubview(rightView)
        rightView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(68)
            make.top.equalTo(secondView.snp.bottom).inset(-5)
            make.left.equalTo(view.snp.centerX).offset(2.5)
        }
        
        let separatorImageView = UIImageView(image: .separator)
        view.addSubview(separatorImageView)
        separatorImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(28)
            make.top.equalTo(rightView.snp.bottom).inset(-15)
        }
        
        collection = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.backgroundColor = .clear
            layout.scrollDirection = .vertical
            collection.showsVerticalScrollIndicator = false
            layout.minimumInteritemSpacing = 5
            layout.minimumLineSpacing = 5
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            collection.delegate = self
            collection.dataSource = self
            return collection
        }()
        view.addSubview(collection!)
        collection?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.top.equalTo(separatorImageView.snp.bottom).inset(-15)
        })
        
    }
    
    func fillArr() {
        let items = ["Texas Holdem", "Holdem 6+", "Chinese Poker", "Omaha", "Omaha hi-lo", "Stud", "Lowball", "Badugi", "H.O.R.S.E.", "Razz", "Draw Poker", "Other"]
        
        for i in items {
            typeGamesArr.append((i, 0))
        }
        
        for game in gamesArr {
            for (index, typeGame) in typeGamesArr.enumerated() {
                if typeGame.0 == game.type {
                    typeGamesArr[index].1 += 1
                }
            }
        }
        
        print(typeGamesArr)
    }
    
    func check() {
        if gamesArr.count > 0 {
            
            var win = 0
            var lose = 0
            
            for i in gamesArr {
                if i.result == true {
                    win += 1
                } else {
                    lose += 1
                }
                
            }
            
            collection?.reloadData()
            let progress: Float =  Float(win) / Float(gamesArr.count)
            progressView.setProgress(to: progress)
            topStatLabel?.text = "\(win)"
            botStatLabel?.text = "\(lose)"
            let biggestWon:Int = gamesArr.filter({ $0.result })
                .map({ $0.amount })
                .max() ?? 0
            let biggestLose:Int =  gamesArr.filter({ $0.result == false })
                .map({ $0.amount })
                .max() ?? 0
            biggestWonLabel?.text = "$ \(biggestWon)"
            biggestLostLabel?.text = "-$ \(biggestLose)"
           
        } else {
            collection?.reloadData()
            biggestWonLabel?.text = "$ 0"
            biggestLostLabel?.text = "-$ 0"
            progressView.setProgress(to: 0)
            topStatLabel?.text = "0"
            botStatLabel?.text = "0"
        }
    }

}


extension FullAnalyticsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return typeGamesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        cell.clipsToBounds = true
        
        cell.backgroundColor = UIColor(red: 38/255, green: 14/255, blue: 67/255, alpha: 1)
        cell.layer.cornerRadius = 12
        
        let mainLabel = UILabel()
        mainLabel.text = "\(typeGamesArr[indexPath.row].1)"
        mainLabel.textColor = .white
        mainLabel.font = .systemFont(ofSize: 34, weight: .bold)
        cell.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-5)
        }
        
        let botLabel = UILabel()
        botLabel.text = typeGamesArr[indexPath.row].0
        botLabel.textColor = .white.withAlphaComponent(0.7)
        botLabel.font = .systemFont(ofSize: 11, weight: .regular)
        cell.addSubview(botLabel)
        botLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainLabel.snp.bottom)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 117, height: 78)
    }
    
    
}
