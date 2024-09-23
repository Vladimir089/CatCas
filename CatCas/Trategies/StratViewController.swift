//
//  StratViewController.swift
//  CatCas
//
//  Created by Владимир Кацап on 23.09.2024.
//

import UIKit
import Combine
import CombineCocoa

var stratArr: [Strategies] = []

class StratViewController: UIViewController {
    
    
    //other
    var cancellable = [AnyCancellable]()
    var arrButtons: [UIButton] = []
    var selectedButton = ""
    var sortedArr = stratArr
    
    var stratPublisher = PassthroughSubject<Any, Never>()
    
    //ui
    var collection: UICollectionView?
    lazy var noStratView = UIView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#0E021C")
        fillButtons()
        stratArr = loadAthleteArrFromFile() ?? []
        createInterface()
        sortedArr = stratArr
        checkStratArr()
        stratPublisher
            .sink { _ in
                self.sortedArr.removeAll()
                self.buttonTapped(sender: self.arrButtons[0])
                
                
                self.checkStratArr()
                self.collection?.reloadData()
            }
            .store(in: &cancellable)
    }
    

    func createInterface() {
        let backButt = UIButton(type: .system)
        backButt.setBackgroundImage(.backButtn, for: .normal)
        view.addSubview(backButt)
        backButt.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(44)
            make.width.equalTo(70)
        }
        
        backButt.tapPublisher
            .sink { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellable)
        
        let addStratButton = UIButton(type: .system)
        addStratButton.setBackgroundImage(.addStrat, for: .normal)
        view.addSubview(addStratButton)
        addStratButton.snp.makeConstraints { make in
            make.height.width.equalTo(44)
            make.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        addStratButton.tapPublisher
            .sink { _ in
                let vc = AddStrategyViewController()
                vc.isNew = true
                vc.stratPublisher = self.stratPublisher
                self.present(vc, animated: true)
            }
            .store(in: &cancellable)
        
        let topLabel = UILabel()
        topLabel.text = "Strategies"
        topLabel.textColor = .white
        topLabel.font = .systemFont(ofSize: 34, weight: .bold)
        view.addSubview(topLabel)
        topLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(backButt.snp.bottom)
        }
        
        let oneStackView = createStackView(items: [arrButtons[0], arrButtons[1], arrButtons[2]])
        view.addSubview(oneStackView)
        oneStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(37)
            make.top.equalTo(topLabel.snp.bottom).inset(-15)
        }
        
        let twoStackView = createStackView(items: [arrButtons[3], arrButtons[4], arrButtons[5]])
        view.addSubview(twoStackView)
        twoStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(37)
            make.top.equalTo(oneStackView.snp.bottom).inset(-5)
        }
        
        let threeStackView = createStackView(items: [arrButtons[6], arrButtons[7], arrButtons[8]])
        view.addSubview(threeStackView)
        threeStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(37)
            make.top.equalTo(twoStackView.snp.bottom).inset(-5)
        }
        
        let fourStackView = createStackView(items: [arrButtons[9], arrButtons[10], arrButtons[11]])
        view.addSubview(fourStackView)
        fourStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(37)
            make.top.equalTo(threeStackView.snp.bottom).inset(-5)
        }
        
        noStratView.backgroundColor = .white.withAlphaComponent(0.05)
        noStratView.layer.cornerRadius = 20
        let imageView = UIImageView(image: .noGames)
        noStratView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview().inset(15)
        }
        view.addSubview(noStratView)
        noStratView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(fourStackView.snp.bottom).inset(-15)
            make.height.equalTo(200)
        }
        
        collection = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.backgroundColor = .clear
            collection.showsVerticalScrollIndicator = false
            layout.scrollDirection = .vertical
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            collection.delegate = self
            collection.dataSource = self
            return collection
        }()
        view.addSubview(collection!)
        collection?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.top.equalTo(fourStackView.snp.bottom).inset(-15)
        })
    }
    
    func sortArr() {
        sortedArr.removeAll()
        for i in stratArr {
            if selectedButton == i.typeGame {
                sortedArr.append(i)
            }
        }
        checkStratArr()
        collection?.reloadData()
    }
    
    func checkStratArr() {
        if sortedArr.count > 0 {
            noStratView.alpha = 0
            collection?.alpha = 1
        } else {
            noStratView.alpha = 1
            collection?.alpha = 0
        }
        
    }
    
    func loadAthleteArrFromFile() -> [Strategies]? {
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to get document directory")
            return nil
        }
        let filePath = documentDirectory.appendingPathComponent("strat.plist")
        do {
            let data = try Data(contentsOf: filePath)
            let athleteArr = try JSONDecoder().decode([Strategies].self, from: data)
            return athleteArr
        } catch {
            print("Failed to load or decode athleteArr: \(error)")
            return nil
        }
    }
    
    
    @objc func buttonTapped(sender: UIButton) {
        for i in arrButtons {
            i.backgroundColor = .white.withAlphaComponent(0.05)
            i.setTitleColor(.white.withAlphaComponent(0.2), for: .normal)
        }
        
        selectedButton = sender.titleLabel?.text ?? ""
        sender.backgroundColor = UIColor(red: 225/255, green: 28/255, blue: 165/255, alpha: 1)
        sender.setTitleColor(.white, for: .normal)
        sortArr()
    }
    
    func fillButtons() {
        let items = ["Texas Holdem", "Holdem 6+", "Chinese Poker", "Omaha", "Omaha hi-lo", "Stud", "Lowball", "Badugi", "H.O.R.S.E.", "Razz", "Draw Poker", "Other"]
        var tag = 0
        
        for i in items {
            let button = UIButton(type: .system)
            button.setTitle(i, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 11, weight: .bold)
            button.backgroundColor = .white.withAlphaComponent(0.05)
            button.setTitleColor(.white.withAlphaComponent(0.2), for: .normal)
            button.layer.cornerRadius = 12
            button.tag = tag
            button.tapPublisher
                .sink { _ in
                    self.buttonTapped(sender: button)
                }
                .store(in: &cancellable)
            arrButtons.append(button)
            tag += 1
        }
    }
    
    func createStackView(items: [UIButton]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: items)
        stackView.axis = .horizontal
        stackView.backgroundColor = .clear
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }
     
    
}

extension StratViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortedArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        cell.backgroundColor = .white.withAlphaComponent(0.05)
        cell.layer.cornerRadius = 12
        
        let nameLabel = UILabel()
        nameLabel.text = stratArr[indexPath.row].title
        nameLabel.textColor = .white
        nameLabel.textAlignment = .left
        nameLabel.font = .systemFont(ofSize: 17, weight: .bold)
        cell.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(15)
        }
        
        let dateImageView = UIImageView(image: .date)
        cell.addSubview(dateImageView)
        dateImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(nameLabel.snp.bottom).inset(-10)
            make.height.width.equalTo(16)
        }
        
        let dateLabel = UILabel()
        dateLabel.text = stratArr[indexPath.row].date
        dateLabel.textColor = .white.withAlphaComponent(0.7)
        dateLabel.font = .systemFont(ofSize: 13, weight: .regular)
        cell.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(dateImageView.snp.right).inset(-5)
            make.centerY.equalTo(dateImageView)
        }
        
        
        let typeGame = UILabel()
        typeGame.text = stratArr[indexPath.row].typeGame
        typeGame.textColor = .white
        typeGame.textAlignment = .right
        typeGame.font = .systemFont(ofSize: 12, weight: .bold)
        cell.addSubview(typeGame)
        typeGame.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview().inset(10)
        }
        
        
        
        let typeGameLabel = UILabel()
        typeGameLabel.text = "Type of game"
        typeGameLabel.font = .systemFont(ofSize: 11, weight: .regular)
        typeGameLabel.textColor = .white.withAlphaComponent(0.7)
        typeGameLabel.textAlignment = .right
        cell.addSubview(typeGameLabel)
        typeGameLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(10)
            make.bottom.equalTo(typeGame.snp.top).inset(-5)
        }
        
        let textView = UITextView()
        textView.text = stratArr[indexPath.row].description
        textView.font = .systemFont(ofSize: 12, weight: .regular)
        textView.textColor = .white.withAlphaComponent(0.7)
        textView.isScrollEnabled = true
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = .clear
        cell.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(dateImageView.snp.bottom).inset(-10)
            make.bottom.equalTo(typeGameLabel.snp.top).inset(-15)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 209)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailStratViewController()
        vc.publisher = stratPublisher
        vc.item = sortedArr[indexPath.row]
        
        var index = 0
        for i in stratArr {
            if i.date == sortedArr[indexPath.row].date , i.description == sortedArr[indexPath.row].description , i.title == sortedArr[indexPath.row].title , i.typeGame  == sortedArr[indexPath.row].typeGame {
                vc.index = index
            } else {
                index += 1
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}


struct Strategies: Codable {
    var typeGame: String
    var title: String
    var date: String
    var description: String
    
    init(typeGame: String, title: String, date: String, description: String) {
        self.typeGame = typeGame
        self.title = title
        self.date = date
        self.description = description
    }
}
