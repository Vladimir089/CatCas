//
//  DetailStratViewController.swift
//  CatCas
//
//  Created by Владимир Кацап on 24.09.2024.
//

import UIKit
import Combine
import CombineCocoa

class DetailStratViewController: UIViewController {
    
    var publisher: PassthroughSubject<Any, Never>?
    var item: Strategies?
    var index = 0
    
    var cancellable = [AnyCancellable]()
    
    //ui
    lazy var topLabel = UILabel()
    lazy var dateLabel = UILabel()
    lazy var textView = UITextView()
    lazy var typeGame = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#0E021C")
        createInterface()
        
        publisher?
            .sink(receiveValue: { _ in
                guard self.index < stratArr.count else {
                    return
                }
                
                let strategy = stratArr[self.index]
                self.dateLabel.text = strategy.date
                self.topLabel.text = strategy.title
                self.textView.text = strategy.description
                self.typeGame.text = strategy.typeGame
            })
            .store(in: &cancellable)
    }
    
    
    func createInterface() {
        let backButton = UIButton(type: .system)
        backButton.setBackgroundImage(.backButtn, for: .normal)
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(44)
            make.width.equalTo(70)
        }
        backButton.tapPublisher
            .sink { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellable)
        
        let delStratButton = UIButton(type: .system)
        delStratButton.setBackgroundImage(.delStrat, for: .normal)
        view.addSubview(delStratButton)
        delStratButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.width.equalTo(44)
        }
        delStratButton.tapPublisher
            .sink { _ in
                
                stratArr.remove(at: self.index)
                
                do {
                    let data = try JSONEncoder().encode(stratArr) //тут мкассив конвертируем в дату
                    try self.saveAthleteArrToFile(data: data)
                    self.publisher?.send(0)
                    self.navigationController?.popViewController(animated: true)
                } catch {
                    print("Failed to encode or save athleteArr: \(error)")
                }
            }
            .store(in: &cancellable)
        
        topLabel.text = stratArr[index].title
        topLabel.textColor = .white
        topLabel.numberOfLines = 2
        topLabel.textAlignment = .left
        topLabel.font = .systemFont(ofSize: 34, weight: .bold)
        view.addSubview(topLabel)
        topLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(backButton.snp.bottom)
        }
        
        let dateImageView = UIImageView(image: .date)
        view.addSubview(dateImageView)
        dateImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(topLabel.snp.bottom).inset(-10)
            make.height.width.equalTo(16)
        }
        
        dateLabel.text = stratArr[index].date
        dateLabel.textColor = .white.withAlphaComponent(0.7)
        dateLabel.font = .systemFont(ofSize: 13, weight: .regular)
        view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(dateImageView.snp.right).inset(-5)
            make.centerY.equalTo(dateImageView)
        }
        
        textView.text = stratArr[index].date
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.isScrollEnabled = true
        textView.font = .systemFont(ofSize: 17, weight: .regular)
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(dateImageView.snp.bottom).inset(-15)
            make.height.equalTo(260)
        }
        
        let typeGameLabel = UILabel()
        typeGameLabel.text = "Type of game"
        typeGameLabel.font = .systemFont(ofSize: 11, weight: .regular)
        typeGameLabel.textColor = .white.withAlphaComponent(0.7)
        typeGameLabel.textAlignment = .right
        view.addSubview(typeGameLabel)
        typeGameLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.top.equalTo(textView.snp.bottom).inset(-5)
        }
        
        typeGame.text = stratArr[index].typeGame
        typeGame.textColor = .white
        typeGame.textAlignment = .right
        typeGame.font = .systemFont(ofSize: 12, weight: .bold)
        view.addSubview(typeGame)
        typeGame.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.top.equalTo(typeGameLabel.snp.bottom).inset(-5)
        }
        
        let editButton = UIButton(type: .system)
        editButton.setTitle("Edit", for: .normal)
        editButton.backgroundColor = UIColor(red: 225/255, green: 28/255, blue: 165/255, alpha: 1)
        editButton.isUserInteractionEnabled = true
        editButton.setTitleColor( .white, for: .normal)
        editButton.layer.cornerRadius = 12
        view.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(15)
        }
        editButton.tapPublisher
            .sink { _ in
                self.edit()
            }
            .store(in: &cancellable)
        
    }
    
    func edit() {
        let vc = AddStrategyViewController()
        vc.stratPublisher = publisher
        vc.index = index
        vc.item = item
        vc.isNew = false
        self.present(vc, animated: true)
    }
    
    func saveAthleteArrToFile(data: Data) throws {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent("strat.plist")
            try data.write(to: filePath)
        } else {
            throw NSError(domain: "SaveError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to get document directory"])
        }
    }

}
