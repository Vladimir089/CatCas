//
//  NewGameViewController.swift
//  CatCas
//
//  Created by Владимир Кацап on 10.09.2024.
//

import UIKit

class NewGameViewController: UIViewController {
    
    //work
    var isNew = true
    weak var delegate: ListGamesViewControllerDelegate?
    var index = 0
    
    //ui
    var topLabel: UILabel?
    
    var segementedControl: UISegmentedControl?
    var amountTextField: UITextField?
    var isWin: Bool?
    var selectedType: String?
    var dateTextField, timeTextField: UITextField?
    
    var saveButton, deleteButton: UIButton?
    
    //other
    var arrButtons: [UIButton] = []
    var arrCategories = ["Domestic", "Casino", "Online"]
    var lossOrGainButtons: [UIButton] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#0E021C")
        fillLossOrGainArr()
        fillButtons()
        createInterface()
        checkIsNew()
    }
    
    func checkIsNew() {

        
        if isNew == true {
            deleteButton?.alpha = 0
            deleteButton?.snp.remakeConstraints({ make in
                make.left.right.equalToSuperview().inset(15)
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                make.height.equalTo(0)
            })
        } else {
            topLabel?.text = "Edit an entry"
            
            var indexSelected = 0
            for i in arrCategories {
                if i == gamesArr[index].place {
                    segementedControl?.selectedSegmentIndex = indexSelected
                } else {
                    indexSelected += 1
                }
            }
            
            amountTextField?.text = "\(gamesArr[index].amount)"
            if gamesArr[index].result == true {
                isWin = true
                lossOrGainButtons[1].tintColor = UIColor(red: 225/255, green: 28/255, blue: 165/255, alpha: 1)
            } else {
                isWin = false
                lossOrGainButtons[0].tintColor = UIColor(red: 225/255, green: 28/255, blue: 165/255, alpha: 1)
            }
            
            for i in arrButtons {
                if i.titleLabel?.text == gamesArr[index].type {
                    selectedType = gamesArr[index].type
                    buttonTapped(sender: i)
                }
            }
            
            dateTextField?.text = gamesArr[index].date
            timeTextField?.text = gamesArr[index].time
            
            saveButton?.isUserInteractionEnabled = true
            saveButton?.setTitleColor(.white, for: .normal)
            saveButton?.backgroundColor = UIColor(red: 225/255, green: 28/255, blue: 165/255, alpha: 1)
        }
    }
    
    
    func createInterface() {
        let hideView = UIView()
        hideView.layer.cornerRadius = 2.5
        hideView.backgroundColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.3)
        view.addSubview(hideView)
        hideView.snp.makeConstraints { make in
            make.height.equalTo(5)
            make.width.equalTo(36)
            make.top.equalToSuperview().inset(5)
            make.centerX.equalToSuperview()
        }
        
        topLabel = {
            let label = UILabel()
            label.text = "Add an entry"
            label.textColor = .white
            label.font = .systemFont(ofSize: 17, weight: .semibold)
            return label
        }()
        view.addSubview(topLabel!)
        topLabel?.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(hideView.snp.bottom).inset(-10)
        })
        
        segementedControl = {
            let segmentedControl = UISegmentedControl(items: arrCategories)
            segmentedControl.selectedSegmentTintColor = .white
            segmentedControl.selectedSegmentTintColor = UIColor(red: 99/255, green: 99/255, blue: 102/255, alpha: 1)
            segmentedControl.backgroundColor = UIColor(red: 120/255, green: 120/255, blue: 128/255, alpha: 0.24)
            segmentedControl.selectedSegmentIndex = 0
            let normalTextAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.white
            ]
            
            segmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
            
            return segmentedControl
        }()
        view.addSubview(segementedControl!)
        segementedControl?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(topLabel!.snp.bottom).inset(-15)
            make.height.equalTo(28)
        })
        
        let amountLabel = createLabel(text: "The amount")
        view.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(segementedControl!.snp.bottom).inset(-10)
        }
        
        amountTextField = createTextField()
        amountTextField?.keyboardType = .numberPad
        view.addSubview(amountTextField!)
        amountTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(54)
            make.top.equalTo(amountLabel.snp.bottom).inset(-5)
        })
        
        let lossOrGainLabel = createLabel(text: "Loss/gain")
        view.addSubview(lossOrGainLabel)
        lossOrGainLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(amountTextField!.snp.bottom).inset(-10)
        }
        
        view.addSubview(lossOrGainButtons[0])
        lossOrGainButtons[0].snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.height.equalTo(64)
            make.width.equalTo(56)
            make.top.equalTo(lossOrGainLabel.snp.bottom).inset(-10)
        }
        
        view.addSubview(lossOrGainButtons[1])
        lossOrGainButtons[1].snp.makeConstraints { make in
            make.left.equalTo(lossOrGainButtons[0].snp.right).inset(-5)
            make.height.equalTo(64)
            make.width.equalTo(56)
            make.top.equalTo(lossOrGainLabel.snp.bottom).inset(-10)
        }
        
        let typeLabel = createLabel(text: "Type of game")
        view.addSubview(typeLabel)
        typeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(lossOrGainButtons[1].snp.bottom).inset(-10)
        }
        
        let oneStackView = createStackView(items: [arrButtons[0], arrButtons[1], arrButtons[2]])
        view.addSubview(oneStackView)
        oneStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(37)
            make.top.equalTo(typeLabel.snp.bottom).inset(-10)
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
        
        let dateLabel = createLabel(text: "Date")
        view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(fourStackView.snp.bottom).inset(-10)
        }
        
        let timeLabel = createLabel(text: "Time")
        view.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(view.snp.centerX).offset(7.5)
            make.top.equalTo(fourStackView.snp.bottom).inset(-10)
        }
        
        dateTextField = createTextField()
        view.addSubview(dateTextField!)
        dateTextField?.snp.makeConstraints({ make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(dateLabel.snp.bottom).inset(-10)
            make.right.equalTo(view.snp.centerX).offset(-7.5)
            make.height.equalTo(54)
        })
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        // Настройка input view и accessory view
        dateTextField?.inputView = datePicker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        dateTextField?.inputAccessoryView = toolbar
        
        timeTextField = createTextField()
        view.addSubview(timeTextField!)
        timeTextField?.snp.makeConstraints({ make in
            make.right.equalToSuperview().inset(15)
            make.top.equalTo(dateLabel.snp.bottom).inset(-10)
            make.left.equalTo(view.snp.centerX).offset(7.5)
            make.height.equalTo(54)
        })
        
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            timePicker.preferredDatePickerStyle = .wheels
        }
        timePicker.addTarget(self, action: #selector(timeChanged(_:)), for: .valueChanged)
        
        // Настройка input view и accessory view
        timeTextField?.inputView = timePicker
        let toolbar1 = UIToolbar()
        toolbar1.sizeToFit()
        let doneButton1 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolbar1.setItems([doneButton1], animated: true)
        timeTextField?.inputAccessoryView = toolbar1
        
        saveButton = {
            let button = UIButton(type: .system)
            button.layer.cornerRadius = 12
            button.setTitle("Save", for: .normal)
            button.setTitleColor(.white.withAlphaComponent(0.5), for: .normal)
            button.backgroundColor = .white.withAlphaComponent(0.05)
            button.isUserInteractionEnabled = false
            return button
        }()
        
        deleteButton = {
            let button = UIButton(type: .system)
            button.layer.cornerRadius = 12
            button.setTitle("Delete", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .white.withAlphaComponent(0.05)
            return button
        }()
        
        view.addSubview(deleteButton!)
        deleteButton?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(50)
        })
        deleteButton?.addTarget(self, action: #selector(delGame), for: .touchUpInside)
        
        view.addSubview(saveButton!)
        saveButton?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(50)
            make.bottom.equalTo(deleteButton!.snp.top).inset(-10)
        })
        saveButton?.addTarget(self, action: #selector(saveGame), for: .touchUpInside)
        
        let hideGesture = UITapGestureRecognizer(target: self, action: #selector(hideKB))
        view.addGestureRecognizer(hideGesture)
    }
    
    @objc func delGame() {
        gamesArr.remove(at: index)
        do {
            let data = try JSONEncoder().encode(gamesArr) //тут мкассив конвертируем в дату
            try saveAthleteArrToFile(data: data)
           
            delegate?.reloadItems(array: gamesArr)
            self.dismiss(animated: true)
        } catch {
            print("Failed to encode or save athleteArr: \(error)")
        }
    }
    
    @objc func saveGame() {
        let place:String = arrCategories[segementedControl?.selectedSegmentIndex ?? 0]
        let amount:Int = Int(amountTextField?.text ?? "") ?? 0
        let result:Bool = isWin ?? true
        let type: String = selectedType ?? ""
        let date:String = dateTextField?.text ?? ""
        let time: String = timeTextField?.text ?? ""
        
        
        let game = Game(place: place, amount: amount, result: result, type: type, date: date, time: time)
        
        if isNew == true {
            gamesArr.append(game)
            
        } else {
            gamesArr[index] = game
        }
        
        do {
            let data = try JSONEncoder().encode(gamesArr) //тут мкассив конвертируем в дату
            try saveAthleteArrToFile(data: data)
           
            delegate?.reloadItems(array: gamesArr)
            self.dismiss(animated: true)
        } catch {
            print("Failed to encode or save athleteArr: \(error)")
        }
    }
    
    func saveAthleteArrToFile(data: Data) throws {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent("game.plist")
            try data.write(to: filePath)
        } else {
            throw NSError(domain: "SaveError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to get document directory"])
        }
    }
    
    
    func checkButton() {
        if amountTextField?.text?.count ?? 0 > 0, isWin != nil, selectedType != nil, dateTextField?.text?.count ?? 0 > 0, timeTextField?.text?.count ?? 0 > 0 {
            saveButton?.isUserInteractionEnabled = true
            saveButton?.setTitleColor(.white, for: .normal)
            saveButton?.backgroundColor = UIColor(red: 225/255, green: 28/255, blue: 165/255, alpha: 1)
        } else {
            saveButton?.isUserInteractionEnabled = false
            saveButton?.setTitleColor(.white.withAlphaComponent(0.5), for: .normal)
            saveButton?.backgroundColor = .white.withAlphaComponent(0.05)
        }
    }
    
    @objc func hideKB() {
        checkButton()
        view.endEditing(true)
    }
    
    @objc func timeChanged(_ sender: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        timeTextField?.text = timeFormatter.string(from: sender.date)
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM, dd"
        dateTextField?.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func donePressed() {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = .identity
        }
        checkButton()
        timeTextField?.resignFirstResponder()
        dateTextField?.resignFirstResponder()
    }
    
    
    func createStackView(items: [UIButton]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: items)
        stackView.axis = .horizontal
        stackView.backgroundColor = .clear
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
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
    
    @objc func buttonTapped(sender: UIButton) {
        for i in arrButtons {
            i.backgroundColor = .white.withAlphaComponent(0.05)
            i.setTitleColor(.white.withAlphaComponent(0.2), for: .normal)
        }
        
        selectedType = sender.titleLabel?.text ?? ""
        sender.backgroundColor = UIColor(red: 225/255, green: 28/255, blue: 165/255, alpha: 1)
        sender.setTitleColor(.white, for: .normal)
        checkButton()
    }
    
    
    func fillLossOrGainArr() {
        let images = [UIImage.loss, UIImage.gain]
        var tag = 0
        for i in images {
            let button = UIButton(type: .system)
            button.setImage(i.resize(targetSize: CGSize(width: 24, height: 24)).withRenderingMode(.alwaysTemplate), for: .normal)
            button.layer.cornerRadius = 12
            button.backgroundColor = .white.withAlphaComponent(0.05)
            button.tag = tag
            button.tintColor = .white.withAlphaComponent(0.2)
            button.addTarget(self, action: #selector(lossOrGainButtonTapped(sender:)), for: .touchUpInside)
            lossOrGainButtons.append(button)
            tag += 1
        }
    }
    
    func createTextField() -> UITextField {
        let textField = UITextField()
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.rightViewMode = .always
        textField.leftViewMode = .always
        textField.placeholder = "Text"
        textField.layer.cornerRadius = 12
        textField.textColor = .white
        textField.delegate = self
        textField.backgroundColor = .white.withAlphaComponent(0.05)
        return textField
    }
    
    func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .white.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }
    
    @objc func lossOrGainButtonTapped(sender: UIButton) {
        for i in lossOrGainButtons {
            i.tintColor = .white.withAlphaComponent(0.2)
        }
        isWin = sender.tag == 0 ? false : true
        sender.tintColor = UIColor(red: 225/255, green: 28/255, blue: 165/255, alpha: 1)
        checkButton()
    }
    
    
}



extension NewGameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        checkButton()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        checkButton()
        if textField == dateTextField || textField == timeTextField {
            UIView.animate(withDuration: 0.3) {
                self.view.transform = CGAffineTransform(translationX: 0, y: -150)
                
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkButton()
        UIView.animate(withDuration: 0.3) {
            self.view.transform = .identity
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        checkButton()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        checkButton()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkButton()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkButton()
        return true
    }
}
