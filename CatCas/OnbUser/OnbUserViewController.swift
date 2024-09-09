//
//  OnbUserViewController.swift
//  CatCas
//
//  Created by Владимир Кацап on 07.09.2024.
//

import UIKit

class OnbUserViewController: UIViewController {
    
    var imageView: UIImageView?
    var topLabel: UILabel?
    var viewsArr: [UIView] = []
    
    var nextButton: UIButton?
    var tap = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        fillArr()
        view.backgroundColor = .white
        createInterface()
    }
    

    func createInterface() {
        imageView = UIImageView(image: .userOnb1)
        view.addSubview(imageView!)
        imageView?.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        
        topLabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = .white
            label.font = .systemFont(ofSize: 34, weight: .bold)
            label.numberOfLines = 2
            label.text = "Control your data in\none app"
            return label
        }()
        view.addSubview(topLabel!)
        topLabel?.snp.makeConstraints({ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
        })
        
        view.addSubview(viewsArr[0])
        viewsArr[0].backgroundColor = UIColor(hex: "#E11CA5")
        viewsArr[0].snp.makeConstraints { make in
            make.height.width.equalTo(10)
            make.centerX.equalToSuperview().offset(-8.5)
            make.top.equalTo(topLabel!.snp.bottom).inset(-20)
        }
        
        view.addSubview(viewsArr[1])
        viewsArr[1].snp.makeConstraints { make in
            make.height.width.equalTo(10)
            make.centerX.equalToSuperview().offset(8.5)
            make.top.equalTo(topLabel!.snp.bottom).inset(-20)
        }
        
        let blackView = UIView()
        blackView.layer.cornerRadius = 20
        blackView.backgroundColor = .black
        view.addSubview(blackView)
        blackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(116)
        }
        
        nextButton = {
            let button = UIButton(type: .system)
            button.setTitle("Next", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor(hex: "#E11CA5")
            button.layer.cornerRadius = 12
            return button
        }()
        blackView.addSubview(nextButton!)
        nextButton!.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(50)
            make.top.equalToSuperview().inset(15)
        }
        nextButton?.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
        
    }
    
    @objc func tapped() {
        tap += 1
        switch tap {
        case 1:
            UIView.animate(withDuration: 0.3) { [self] in
                imageView?.image = .useronb2
                viewsArr[0].backgroundColor = .white.withAlphaComponent(0.2)
                viewsArr[1].backgroundColor = UIColor(hex: "#E11CA5")
                topLabel?.text = "All statistics and\ngames in one place"
            }
        case 2:
            self.navigationController?.setViewControllers([HomeViewController()], animated: true)
        default:
            return
        }
    }
    
    func fillArr() {
        for _ in 0..<2 {
            let view = UIView()
            view.backgroundColor = .white.withAlphaComponent(0.2)
            view.layer.cornerRadius = 5
            viewsArr.append(view)
        }
    }

}




extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        let alpha = CGFloat(1.0)

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
