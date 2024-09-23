

import UIKit
import SnapKit

class LoadViewController: UIViewController {
    
    var timer: Timer?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 225/255, green: 28/255, blue: 165/255, alpha: 1)
        createInterface()
        timer = Timer.scheduledTimer(withTimeInterval: 7, repeats: false, block: { [self] _ in //поменять тайминтервал на 7
            timer?.invalidate()
            timer = nil
            if isBet == false {
                if UserDefaults.standard.value(forKey: "tab") != nil {
                    self.navigationController?.setViewControllers([HomeViewController()], animated: true)
                } else {
                    self.navigationController?.setViewControllers([OnbUserViewController()], animated: true)
                }
            } else {
                
            }
        })
    }
    
    func createInterface() {
        let imageView = UIImageView(image: .loadLog)
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(244)
            make.center.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.color = .white
        activityView.startAnimating()
        view.addSubview(activityView)
        activityView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).inset(-90)
        }
    }
    
    


}


extension UIViewController {
    func hideNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func showNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}


extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
