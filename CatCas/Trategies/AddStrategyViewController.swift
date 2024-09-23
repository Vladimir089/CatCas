//
//  AddStrategyViewController.swift
//  CatCas
//
//  Created by Владимир Кацап on 23.09.2024.
//

import UIKit
import Combine
import CombineCocoa

class AddStrategyViewController: UIViewController {
    
    var stratPublisher: PassthroughSubject<Any, Never>?
    var isNew = true
    
    //edit
    var index = 0
    var item: Strategies?
    
    //work
    var selectedButton = ""
    lazy var titleTextField = UITextField()
    lazy var dateTextField = UITextField()
    lazy var deskTextView = UITextView()
    
    //ui
    lazy var topLabel = UILabel()
    var cancellable = [AnyCancellable]()
    var arrButtons: [UIButton] = []
    lazy var saveButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        fillButtons()
        createInterface()
        view.backgroundColor = UIColor(hex: "#0E021C")
    }
    
    func checkIsNew() {
        if isNew == false {
            topLabel.text = "Edit an entry"
            for i in 0..<arrButtons.count {
                if arrButtons[i].titleLabel?.text == item?.typeGame {
                    buttonTapped(sender: arrButtons[i])
                    selectedButton = arrButtons[i].titleLabel?.text ?? ""
                    break
                }
            }
            titleTextField.text = item?.title
            dateTextField.text = item?.date
            deskTextView.text = item?.description
        }
    }
    
    func createInterface() {
        
        let hideView = UIView()
        hideView.backgroundColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.3)
        hideView.layer.cornerRadius = 2.5
        view.addSubview(hideView)
        hideView.snp.makeConstraints { make in
            make.height.equalTo(5)
            make.width.equalTo(36)
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
        }
        
        topLabel.text = "Add an entry"
        topLabel.textColor = .white
        topLabel.font = .systemFont(ofSize: 17, weight: .bold)
        view.addSubview(topLabel)
        topLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(hideView.snp.bottom).inset(-10)
        }
        
        let typeGamesLabel = createLabel(text: "Type of game")
        view.addSubview(typeGamesLabel)
        typeGamesLabel.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).inset(-15)
            make.left.equalToSuperview().inset(15)
        }
        
        let oneStackView = createStackView(items: [arrButtons[0], arrButtons[1], arrButtons[2]])
        view.addSubview(oneStackView)
        oneStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(37)
            make.top.equalTo(typeGamesLabel.snp.bottom).inset(-10)
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
        
        let titleLabel = createLabel(text: "Title")
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(fourStackView.snp.bottom).inset(-15)
        }
        
        titleTextField  = createTextField()
        view.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(54)
            make.top.equalTo(titleLabel.snp.bottom).inset(-10)
        }
        
        let dateLabel = createLabel(text: "Date")
        view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(titleTextField.snp.bottom).inset(-15)
        }
        
        dateTextField = createTextField()
        view.addSubview(dateTextField)
        dateTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(54)
            make.top.equalTo(dateLabel.snp.bottom).inset(-10)
        }
        
        let hideKBGesture = UITapGestureRecognizer(target: self, action: nil)
        view.addGestureRecognizer(hideKBGesture)
        hideKBGesture.tapPublisher
            .sink { _ in
                self.view.endEditing(true)
                UIView.animate(withDuration: 0.3) {
                      self.view.transform = .identity
                  }
            }
            .store(in: &cancellable)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
       
        dateTextField.inputView = datePicker
        
        let deskLabel = createLabel(text: "Description")
        view.addSubview(deskLabel)
        deskLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(dateTextField.snp.bottom).inset(-15)
        }
        
        deskTextView.backgroundColor = .white.withAlphaComponent(0.05)
        deskTextView.layer.cornerRadius = 12
        deskTextView.delegate = self
        deskTextView.font = .systemFont(ofSize: 17, weight: .regular)
        deskTextView.textColor = .white
        deskTextView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        view.addSubview(deskTextView)
        deskTextView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(160)
            make.top.equalTo(deskLabel.snp.bottom).inset(-10)
        }
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = .white.withAlphaComponent(0.05)
        saveButton.layer.cornerRadius = 12
        saveButton.isUserInteractionEnabled = false
        saveButton.alpha = 0.5
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(15)
        }
        saveButton.tapPublisher
            .sink { _ in
                self.save()
            }
            .store(in: &cancellable)
        
        checkIsNew()
    }
    
    func checkButton() {
        if selectedButton != "" , titleTextField.text?.count ?? 0 > 0 , dateTextField.text?.count ?? 0 > 0, deskTextView.text.count > 0 {
            saveButton.alpha = 1
            saveButton.backgroundColor = UIColor(red: 225/255, green: 28/255, blue: 165/255, alpha: 1)
            saveButton.isUserInteractionEnabled = true
        } else {
            saveButton.isUserInteractionEnabled = false
            saveButton.alpha = 0.5
            saveButton.backgroundColor = .white.withAlphaComponent(0.05)
        }
    }
    
    @objc func dateChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM, dd" // Формат: April, 08
        dateTextField.text = dateFormatter.string(from: sender.date)
        checkButton()
    }
    
    func createTextField() -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = .white.withAlphaComponent(0.05)
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.rightViewMode = .always
        textField.leftViewMode = .always
        textField.layer.cornerRadius = 12
        textField.delegate = self
        textField.textColor = .white
        return textField
    }
    
    func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .white.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }
    
    func save() {
        let title: String = titleTextField.text ?? ""
        let date: String = dateTextField.text ?? ""
        let desk: String = deskTextView.text ?? ""
        
        let strategy = Strategies(typeGame: selectedButton, title: title, date: date, description: desk)
        
        if isNew == true {
            stratArr.append(strategy)
        } else {
            stratArr[index] = strategy
        }
        
        do {
            let data = try JSONEncoder().encode(stratArr)
            try saveAthleteArrToFile(data: data)
           
            stratPublisher?.send(0)
            self.dismiss(animated: true)
            
        } catch {
            print("Failed to encode or save athleteArr: \(error)")
        }
        
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
    
    @objc func buttonTapped(sender: UIButton) {
        for i in arrButtons {
            i.backgroundColor = .white.withAlphaComponent(0.05)
            i.setTitleColor(.white.withAlphaComponent(0.2), for: .normal)
        }
        
        selectedButton = sender.titleLabel?.text ?? ""
        sender.backgroundColor = UIColor(red: 225/255, green: 28/255, blue: 165/255, alpha: 1)
        sender.setTitleColor(.white, for: .normal)
        checkButton()
    }

}

extension AddStrategyViewController: UITextFieldDelegate, UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.3) {
              self.view.transform = .identity
          }
        checkButton()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -300)
            
        }
        checkButton()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        checkButton()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        checkButton()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkButton()
        view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkButton()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        checkButton()
        return true
    }
    
    
}
