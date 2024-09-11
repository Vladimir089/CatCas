//
//  ListGamesViewController.swift
//  CatCas
//
//  Created by Владимир Кацап on 09.09.2024.
//

import UIKit

protocol ListGamesViewControllerDelegate: AnyObject {
    func reloadItems(array: [Game])
}

class ListGamesViewController: UIViewController {
    
    weak var delegate: HomeViewControllerDelegate?
    
    var arrButtons: [UIButton] = []
    var arrCategories = ["Domestic", "Casino", "Online"]
    
    var selectedButton = ""
    var selectedSegmented = ""
    
    var sortedArray: [Game] = gamesArr
    
    var collection: UICollectionView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: "#0E021C")
        let backButtonAppearance = UIBarButtonItem.appearance()
        backButtonAppearance.tintColor = UIColor(red: 225/255, green: 28/255, blue: 165/255, alpha: 1)
        if let backButton = navigationController?.navigationBar.topItem?.backBarButtonItem {
            backButton.tintColor = UIColor(red: 225/255, green: 28/255, blue: 165/255, alpha: 1)
        }
        fillButtons()
        createInterface()
    }
    

    func createInterface() {
        
        let topLabel = UILabel()
        topLabel.text = "List of games"
        topLabel.textColor = .white
        topLabel.font = .systemFont(ofSize: 34, weight: .bold)
        view.addSubview(topLabel)
        topLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
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
        
        let addButton: UIButton = {
            let button = UIButton()
            button.setImage(.addGame, for: .normal)
            button.backgroundColor = UIColor(red: 38/255, green: 14/255, blue: 67/255, alpha: 1)
            button.layer.cornerRadius = 14
            return button
        }()
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.height.width.equalTo(28)
            make.right.equalToSuperview().inset(15)
            make.top.equalTo(fourStackView.snp.bottom).inset(-15)
        }
        addButton.addTarget(self, action: #selector(createNewGame), for: .touchUpInside)
        
        let segementedControl: UISegmentedControl = {
            let segmentedControl = UISegmentedControl(items: arrCategories)
            segmentedControl.selectedSegmentTintColor = .white
            segmentedControl.selectedSegmentTintColor = UIColor(red: 99/255, green: 99/255, blue: 102/255, alpha: 1)
            segmentedControl.backgroundColor = UIColor(red: 120/255, green: 120/255, blue: 128/255, alpha: 0.24)
            
            let normalTextAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.white
            ]
            
            segmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
            
            return segmentedControl
        }()
        segementedControl.addTarget(self, action: #selector(segmentedControlTapped(sender:)), for: .valueChanged)
        view.addSubview(segementedControl)
        segementedControl.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.height.equalTo(28)
            make.right.equalTo(addButton.snp.left).inset(-15)
            make.top.equalTo(fourStackView.snp.bottom).inset(-15)
        }
        
        collection = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.backgroundColor = .clear
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            collection.showsVerticalScrollIndicator = false
            layout.scrollDirection = .vertical
            collection.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
            collection.delegate = self
            collection.dataSource = self
            return collection
        }()
        view.addSubview(collection!)
        collection?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.top.equalTo(segementedControl.snp.bottom).inset(-5)
        })
    }
    
    @objc func createNewGame() {
        let vc = NewGameViewController()
        vc.delegate = self
        vc.isNew = true
        self.present(vc, animated: true)
    }
    
    @objc func segmentedControlTapped(sender: UISegmentedControl) {
        selectedSegmented = arrCategories[sender.selectedSegmentIndex]
        reload()
    }
    
    @objc func buttonTapped(sender: UIButton) {
        for i in arrButtons {
            i.backgroundColor = .white.withAlphaComponent(0.05)
            i.setTitleColor(.white.withAlphaComponent(0.2), for: .normal)
        }
        
        selectedButton = sender.titleLabel?.text ?? ""
        sender.backgroundColor = UIColor(red: 225/255, green: 28/255, blue: 165/255, alpha: 1)
        sender.setTitleColor(.white, for: .normal)
        reload()
    }
    
    func createStackView(items: [UIButton]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: items)
        stackView.axis = .horizontal
        stackView.backgroundColor = .clear
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }
    
    func reload() {
        sortedArray.removeAll()
        
        if selectedButton != "" || selectedSegmented != "" {
            for i in gamesArr {
                if ((i.place == selectedSegmented && selectedSegmented != "") || (i.type == selectedButton && selectedButton != "")) || ((i.place == selectedSegmented && selectedSegmented != "") && (i.type == selectedButton && selectedButton != "")) {
                    sortedArray.append(i)
                }
            }
        } else {
            sortedArray = gamesArr
        }
        
        
        collection?.reloadData()
        
        
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
            button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
            arrButtons.append(button)
            tag += 1
        }
        
    }

}

extension ListGamesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if sortedArray.count > 0 {
            return sortedArray.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if sortedArray.count > 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
            cell.subviews.forEach { $0.removeFromSuperview() }
            cell.backgroundColor = .white.withAlphaComponent(0.05)
            cell.layer.cornerRadius = 12
            
            let leftView = UIView()
            leftView.layer.cornerRadius = 12
            leftView.backgroundColor = .white.withAlphaComponent(0.05)
            cell.addSubview(leftView)
            leftView.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(15)
                make.top.bottom.equalToSuperview().inset(15)
                make.width.equalTo(56)
            }
            let imageView = UIImageView(image: .loss.withRenderingMode(.alwaysTemplate))
            leftView.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.height.equalTo(13)
                make.width.equalTo(19)
                make.center.equalToSuperview()
            }
            
            let amountLabel = UILabel()
            amountLabel.text = "The amount:"
            amountLabel.textColor = .white
            amountLabel.font = .systemFont(ofSize: 17, weight: .bold)
            cell.addSubview(amountLabel)
            amountLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(15)
                make.left.equalTo(leftView.snp.right).inset(-15)
            }
            
            let numberLabel = UILabel()
            numberLabel.font = .systemFont(ofSize: 17, weight: .bold)
            numberLabel.textAlignment = .right
            cell.addSubview(numberLabel)
            numberLabel.snp.makeConstraints { make in
                make.right.top.equalToSuperview().inset(15)
                make.left.equalTo(amountLabel.snp.right).inset(-5)
            }
            
            let dateImageView = UIImageView(image: .date)
            cell.addSubview(dateImageView)
            dateImageView.snp.makeConstraints { make in
                make.width.height.equalTo(20)
                make.left.equalTo(leftView.snp.right).inset(-15)
                make.top.equalTo(amountLabel.snp.bottom).inset(-5)
            }
            
            let dateLabel = UILabel()
            dateLabel.text = sortedArray[indexPath.row].date
            dateLabel.textColor = .white.withAlphaComponent(0.7)
            dateLabel.font = .systemFont(ofSize: 13, weight: .regular)
            cell.addSubview(dateLabel)
            dateLabel.snp.makeConstraints { make in
                make.centerY.equalTo(dateImageView)
                make.left.equalTo(dateImageView.snp.right).inset(-5)
            }
            
            let timeImageView = UIImageView(image: .time)
            cell.addSubview(timeImageView)
            timeImageView.snp.makeConstraints { make in
                make.width.height.equalTo(20)
                make.left.equalTo(dateLabel.snp.right).inset(-15)
                make.top.equalTo(amountLabel.snp.bottom).inset(-5)
            }
            let timeLabel = UILabel()
            timeLabel.text = sortedArray[indexPath.row].time
            timeLabel.textColor = .white.withAlphaComponent(0.7)
            timeLabel.font = .systemFont(ofSize: 13, weight: .regular)
            cell.addSubview(timeLabel)
            timeLabel.snp.makeConstraints { make in
                make.centerY.equalTo(dateImageView)
                make.left.equalTo(timeImageView.snp.right).inset(-5)
            }
            
            let typeGameLabel = UILabel()
            typeGameLabel.text = "Type of game"
            typeGameLabel.font = .systemFont(ofSize: 11, weight: .regular)
            typeGameLabel.textColor = .white.withAlphaComponent(0.5)
            cell.addSubview(typeGameLabel)
            typeGameLabel.snp.makeConstraints { make in
                make.left.equalTo(leftView.snp.right).inset(-15)
                make.top.equalTo(timeImageView.snp.bottom).inset(-15)
            }
            
            let typeLabel = UILabel()
            typeLabel.text = sortedArray[indexPath.row].type
            typeLabel.textColor = .white
            typeLabel.font = .systemFont(ofSize: 12, weight: .regular)
            cell.addSubview(typeLabel)
            typeLabel.snp.makeConstraints { make in
                make.left.equalTo(typeGameLabel.snp.left)
                make.bottom.equalToSuperview().inset(15)
            }
            
            let placeGameLabel = UILabel()
            placeGameLabel.text = "Place"
            placeGameLabel.font = .systemFont(ofSize: 11, weight: .regular)
            placeGameLabel.textColor = .white.withAlphaComponent(0.5)
            cell.addSubview(placeGameLabel)
            placeGameLabel.snp.makeConstraints { make in
                make.left.equalTo(cell.snp.centerX).offset(50)
                make.top.equalTo(timeImageView.snp.bottom).inset(-15)
            }
            let placeLabel = UILabel()
            placeLabel.text = sortedArray[indexPath.row].place
            placeLabel.textColor = .white
            placeLabel.font = .systemFont(ofSize: 12, weight: .regular)
            cell.addSubview(placeLabel)
            placeLabel.snp.makeConstraints { make in
                make.left.equalTo(placeGameLabel.snp.left)
                make.bottom.equalToSuperview().inset(15)
            }
            
            
            if sortedArray[indexPath.row].result == true {
                imageView.image = .gain.withRenderingMode(.alwaysTemplate)
                imageView.tintColor = UIColor(red: 225/255, green: 28/255, blue: 165/255, alpha: 1)
                numberLabel.textColor = UIColor(red: 225/255, green: 28/255, blue: 165/255, alpha: 1)
                numberLabel.text = "+$ \(sortedArray[indexPath.row].amount)"
            } else {
                imageView.image = .loss.withRenderingMode(.alwaysTemplate)
                imageView.tintColor = .systemRed
                numberLabel.textColor = .systemRed
                numberLabel.text = "-$ \(sortedArray[indexPath.row].amount)"
            }
            
            
            
            
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
        if sortedArray.count > 0 {
            return CGSize(width: collectionView.frame.width, height: 121)
        } else {
            return CGSize(width: collectionView.frame.width, height: 200)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var globalIndex = 0
        if sortedArray.count > 0 {
            let indexPathItem = sortedArray[indexPath.row]
            
            for i in gamesArr {
                if i.result == indexPathItem.result , i.amount == indexPathItem.amount, i.date == indexPathItem.date, i.place == indexPathItem.place, i.time == indexPathItem.time, i.type == indexPathItem.type {
                    let vc = NewGameViewController()
                    vc.delegate = self
                    vc.isNew = false
                    vc.index = globalIndex
                    self.present(vc, animated: true)
                } else {
                    globalIndex += 1
                }
            }
        }
        
    }
}


extension ListGamesViewController: ListGamesViewControllerDelegate{
    func reloadItems(array: [Game]) {
        self.sortedArray = array
        reload()
        delegate?.reload()
    }
    
    
}
