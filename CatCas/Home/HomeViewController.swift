//
//  HomeViewController.swift
//  CatCas
//
//  Created by Владимир Кацап on 07.09.2024.
//

import UIKit


var gamesArr: [Game] = []

protocol HomeViewControllerDelegate: AnyObject {
    func reload()
}

class HomeViewController: UIViewController {
    
    //topView
    var topStatLabel, botStatLabel: UILabel?
    let progressView = CircularProgressView(frame: CGRect(x: 0, y: 0, width: 60, height: 60), lineWidth: 20, rounded: false)
    var biggestLostLabel, biggestWonLabel: UILabel?
    var collection: UICollectionView?
    
    var twoLastGamesArray: [Game] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.setValue("1", forKey: "tab")
        view.backgroundColor = UIColor(hex: "#0E021C")
        gamesArr = loadAthleteArrFromFile() ?? []
        createView()
        check()
    }
    

    func createView() {
        let topLabel = UILabel()
        topLabel.text = "Home"
        topLabel.textColor = .white
        topLabel.font = .systemFont(ofSize: 34, weight: .bold)
        view.addSubview(topLabel)
        topLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(15)
        }
        
        let topView: UIView = {
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
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(topLabel.snp.bottom).inset(-15)
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
            make.top.equalTo(topView.snp.bottom).inset(-5)
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
            make.top.equalTo(topView.snp.bottom).inset(-5)
            make.left.equalTo(view.snp.centerX).offset(2.5)
        }
        
        let combinationsButton: UIButton = {
            let button = UIButton()
            button.layer.cornerRadius = 12
            button.backgroundColor = .white.withAlphaComponent(0.05)
            let leftImageView = UIImageView(image: .comb)
            button.addSubview(leftImageView)
            leftImageView.snp.makeConstraints { make in
                make.height.width.equalTo(24)
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().inset(20)
            }
            
            let label = UILabel()
            label.text = "Combinations"
            label.textColor = .white
            label.font = .systemFont(ofSize: 16, weight: .bold)
            button.addSubview(label)
            label.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalTo(leftImageView.snp.right).inset(-30)
            }
            
            let arrowImageView = UIImageView(image: .arrow)
            button.addSubview(arrowImageView)
            arrowImageView.snp.makeConstraints { make in
                make.height.width.equalTo(20)
                make.right.equalToSuperview().inset(15)
                make.centerY.equalToSuperview()
            }
            
            return button
        }()
        
        view.addSubview(combinationsButton)
        combinationsButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(rightView.snp.bottom).inset(-5)
            make.height.equalTo(65)
        }
        combinationsButton.addTarget(self, action: #selector(openCombinations), for: .touchUpInside)
        
        let settingsButton: UIButton = {
            let button = UIButton(type: .system)
            button.setImage(.settings.withRenderingMode(.alwaysTemplate).resize(targetSize: CGSize(width: 24, height: 24)), for: .normal)
            button.tintColor = UIColor(red: 225/255, green: 28/255, blue: 165/255, alpha: 1)
            button.backgroundColor = .white.withAlphaComponent(0.05)
            button.layer.cornerRadius = 12
            return button
        }()
        view.addSubview(settingsButton)
        settingsButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(combinationsButton.snp.bottom).inset(-5)
            make.height.width.equalTo(64)
        }
        settingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        
        let fullAnalyceButton: UIButton = {
            let button = UIButton()
            button.backgroundColor = .white.withAlphaComponent(0.05)
            button.layer.cornerRadius = 12
            let imageView = UIImageView(image: .fullanalist)
            button.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.height.width.equalTo(20)
                make.left.equalToSuperview().inset(15)
                make.centerY.equalToSuperview()
            }
            
            let label = UILabel()
            label.text = "Full analytics"
            label.textColor = .white
            label.font = .systemFont(ofSize: 16, weight: .bold)
            button.addSubview(label)
            label.snp.makeConstraints { make in
                make.left.equalTo(imageView.snp.right).inset(-20)
                make.centerY.equalToSuperview()
            }
            let arrowImageView = UIImageView(image: .arrow)
            button.addSubview(arrowImageView)
            arrowImageView.snp.makeConstraints { make in
                make.height.width.equalTo(20)
                make.right.equalToSuperview().inset(15)
                make.centerY.equalToSuperview()
            }

            return button
        }()
        view.addSubview(fullAnalyceButton)
        fullAnalyceButton.snp.makeConstraints { make in
            make.left.equalTo(settingsButton.snp.right).inset(-5)
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(65)
            make.centerY.equalTo(settingsButton)
        }
        fullAnalyceButton.addTarget(self, action: #selector(openFullAnalyce), for: .touchUpInside)
        
        let recentLabel = UILabel()
        recentLabel.textColor = .white
        recentLabel.font = .systemFont(ofSize: 22, weight: .bold)
        recentLabel.text = "Recent games"
        view.addSubview(recentLabel)
        recentLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(settingsButton.snp.bottom).inset(-15)
        }
        
        let seeAllButton = UIButton(type: .system)
        seeAllButton.setTitle("See All", for: .normal)
        seeAllButton.setTitleColor(UIColor(red: 225/255, green: 28/255, blue: 165/255, alpha: 1), for: .normal)
        seeAllButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        view.addSubview(seeAllButton)
        seeAllButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(recentLabel)
        }
        seeAllButton.addTarget(self, action: #selector(seeAllGames), for: .touchUpInside)
        
        collection = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.backgroundColor = .clear
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            collection.showsVerticalScrollIndicator = false
            layout.scrollDirection = .vertical
            collection.delegate = self
            collection.dataSource = self
            return collection
        }()
        view.addSubview(collection!)
        collection?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.top.equalTo(recentLabel.snp.bottom).inset(-15)
        })
        
    }
    
    @objc func seeAllGames() {
        print("all")
    }
    
    @objc func openFullAnalyce() {
        print("an")
    }
    
    @objc func openSettings() {
        self.present(SettingsViewController(), animated: true)
    }
    
    @objc func openCombinations() {
        self.navigationController?.pushViewController(CombinationsViewController(), animated: true)
    }
    
    func loadAthleteArrFromFile() -> [Game]? {
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to get document directory")
            return nil
        }
        let filePath = documentDirectory.appendingPathComponent("game.plist")
        do {
            let data = try Data(contentsOf: filePath)
            let athleteArr = try JSONDecoder().decode([Game].self, from: data)
            return athleteArr
        } catch {
            print("Failed to load or decode athleteArr: \(error)")
            return nil
        }
    }
    

    
    func check() {
        twoLastGamesArray.removeAll()
        if gamesArr.count > 0 {
            let lastTwoElements = gamesArr.suffix(2)
            twoLastGamesArray = Array(lastTwoElements)
            
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
            let progress: Float = Float(gamesArr.count) / Float(win)
            progressView.setProgress(to: progress)
            topStatLabel?.text = "\(win)"
            botStatLabel?.text = "\(lose)"
            let biggestWon = gamesArr.filter({ $0.result })
                .map({ $0.amount })
                .max()
            let biggestLose =  gamesArr.filter({ $0.result == false })
                .map({ $0.amount })
                .max()
            biggestWonLabel?.text = "$ \(biggestWon)"
            biggestLostLabel?.text = "-$ \(biggestLose)"
           
        }
    }
    
    

}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if twoLastGamesArray.count > 0 {
            return twoLastGamesArray.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if twoLastGamesArray.count > 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
            cell.subviews.forEach { $0.removeFromSuperview() }
            cell.backgroundColor = .red
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
            cell.subviews.forEach { $0.removeFromSuperview() }
            cell.layer.cornerRadius = 20
            cell.backgroundColor = .white.withAlphaComponent(0.05)
            let imageView = UIImageView(image: .noGames)
            cell.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.left.right.top.bottom.equalToSuperview().inset(15)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if twoLastGamesArray.count > 0 {
            return CGSize(width: collectionView.frame.width, height: 121)
        } else {
            return CGSize(width: collectionView.frame.width, height: 200)
        }
    }
    
}


extension HomeViewController: HomeViewControllerDelegate {
    func reload() {
        check()
    }
    
    
}
