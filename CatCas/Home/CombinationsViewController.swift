//
//  CombinationsViewController.swift
//  CatCas
//
//  Created by Владимир Кацап on 09.09.2024.
//

import UIKit

class CombinationsViewController: UIViewController {
    
    var combArr: [Comb] = []
    
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
        fillArr()
        createInterface()
    }
    
    func fillArr() {
        combArr.append(Comb(tite: "High card", desk: "The cards are different in suit and dignity.", image: .comb1.resize(targetSize: CGSize(width: 40, height: 40))))
        combArr.append(Comb(tite: "Pair", desk: "Two cards of the same rank.", image: .comb2.resize(targetSize: CGSize(width: 84, height: 40))))
        combArr.append(Comb(tite: "Two pair", desk: "Two pairs of cards of the same value.", image: .comb3.resize(targetSize: CGSize(width: 196, height: 40))))
        combArr.append(Comb(tite: "Three of a kind", desk: "Three cards of the same rank and two other cards.", image: .comb4.resize(targetSize: CGSize(width: 144, height: 40))))
        combArr.append(Comb(tite: "Straight", desk: "Five cards of different suits, following the rank one after another.", image: .comb5.resize(targetSize: CGSize(width: 248, height: 40))))
        combArr.append(Comb(tite: "Flush", desk: "Five cards of the same suit.", image: .comb6.resize(targetSize: CGSize(width: 248, height: 40))))
        combArr.append(Comb(tite: "Full house", desk: "Three cards of one value and two cards of another.", image: .comb7.resize(targetSize: CGSize(width: 248, height: 40))))
        combArr.append(Comb(tite: "Four of a kind", desk: "Four cards of the same value and any fifth card.", image: .comb8.resize(targetSize: CGSize(width: 196, height: 40))))
        combArr.append(Comb(tite: "Straight flush", desk: "Five cards of the same suit, starting from the king and below.", image: .comb9.resize(targetSize: CGSize(width: 248, height: 40))))
        combArr.append(Comb(tite: "Royal flush", desk: "Ace, king, queen, jack and ten of the same suit.", image: .comb10.resize(targetSize: CGSize(width: 248, height: 40))))
    }
    
    func createInterface() {
        let topLabel = UILabel()
        topLabel.text = "Combinations"
        topLabel.textColor = .white
        topLabel.font = .systemFont(ofSize: 34, weight: .bold)
        view.addSubview(topLabel)
        topLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        let collection: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.showsVerticalScrollIndicator = false
            layout.scrollDirection = .vertical
            collection.backgroundColor = .clear
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            collection.delegate = self
            collection.dataSource = self
            return collection
        }()
        view.addSubview(collection)
        collection.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.top.equalTo(topLabel.snp.bottom).inset(-5)
        }
        
    }
   
}

extension CombinationsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return combArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        cell.backgroundColor = .white.withAlphaComponent(0.05)
        cell.layer.cornerRadius = 12
        
        let topLabel = UILabel()
        topLabel.textColor = .white
        topLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        topLabel.text = combArr[indexPath.row].tite
        cell.addSubview(topLabel)
        topLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(15)
        }
        
        let secondLabel = UILabel()
        secondLabel.numberOfLines = 2
        secondLabel.textColor = .white.withAlphaComponent(0.7)
        secondLabel.font = .systemFont(ofSize: 13, weight: .regular)
        secondLabel.text = combArr[indexPath.row].desk
        secondLabel.textAlignment = .left
        cell.addSubview(secondLabel)
        secondLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(topLabel.snp.bottom).inset(-3)
            make.height.equalTo(36)
        }
        
        let imageView = UIImageView(image: combArr[indexPath.row].image)
        
        imageView.contentMode = .scaleAspectFit
        cell.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(15)
            make.top.equalTo(secondLabel.snp.bottom).inset(-3)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 134)
    }
    
    
}

struct Comb {
    let tite: String
    let desk: String
    let image: UIImage
    
    init(tite: String, desk: String, image: UIImage) {
        self.tite = tite
        self.desk = desk
        self.image = image
    }
}
