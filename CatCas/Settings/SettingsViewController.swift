//
//  SettingsViewController.swift
//  CatCas
//
//  Created by Владимир Кацап on 09.09.2024.
//


import UIKit
import StoreKit
import WebKit


class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 37/255, green: 37/255, blue: 37/255, alpha: 1)
        createInterface()
    }
    

    func createInterface() {
        let hideView = UIView()
        hideView.backgroundColor = UIColor(red: 127/255, green: 127/255, blue: 127/255, alpha: 0.4)
        hideView.layer.cornerRadius = 2.5
        view.addSubview(hideView)
        hideView.snp.makeConstraints { make in
            make.height.equalTo(5)
            make.width.equalTo(36)
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
        }
        
        let settingsLabel = UILabel()
        settingsLabel.text = "Settings"
        settingsLabel.textColor = .white
        settingsLabel.font = .systemFont(ofSize: 20, weight: .bold)
        view.addSubview(settingsLabel)
        settingsLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(hideView.snp.bottom).inset(-15)
        }
        
        let shareButton = createButton(image: .share, title: "Share the app")
        view.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(54)
            make.top.equalTo(settingsLabel.snp.bottom).inset(-30)
        }
        shareButton.addTarget(self, action: #selector(shareApps), for: .touchUpInside)
        
        let rateButton = createButton(image: .rate, title: "Rate our app")
        view.addSubview(rateButton)
        rateButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(54)
            make.top.equalTo(shareButton.snp.bottom).inset(-20)
        }
        rateButton.addTarget(self, action: #selector(rateApps), for: .touchUpInside)
        
        let usageButton = createButton(image: .policy, title: "Usage Policy")
        view.addSubview(usageButton)
        usageButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(54)
            make.top.equalTo(rateButton.snp.bottom).inset(-20)
        }
        usageButton.addTarget(self, action: #selector(policy), for: .touchUpInside)
        
        
        
    }
    
    func createButton(image: UIImage, title: String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .white.withAlphaComponent(0.05)
        button.layer.cornerRadius = 24
        let imageView = UIImageView(image: image)
        button.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(15)
        }
        
        let label = UILabel()
        label.text = title
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .bold)
        button.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        let arrowImageView = UIImageView(image: .arrow)
        button.addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15)
        }
        
        return button
    }
    
    @objc func policy() {
        let webVC = WebViewController()
        webVC.urlString = "pol"
        present(webVC, animated: true, completion: nil)
    }
    
    @objc func rateApps() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            if let url = URL(string: "id") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    @objc func shareApps() {
        let appURL = URL(string: "id")!
        let activityViewController = UIActivityViewController(activityItems: [appURL], applicationActivities: nil)
        
        // Настройка для показа в виде popover на iPad
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        self.present(activityViewController, animated: true, completion: nil)
    }
    

}


class WebViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var urlString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
        // Загружаем URL
        if let urlString = urlString, let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
    }
}
