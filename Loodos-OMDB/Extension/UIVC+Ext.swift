

import Lottie
import UIKit

public extension UIViewController {
    func showActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            activityIndicator.style = .large
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            activityIndicator.center = CGPoint(x: self.view.bounds.size.width / 2, y: self.view.bounds.height / 2)
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
        }
    }
    
    func hideActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    func showAlert(errorTitle:String, errorMessage: String) {
        let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func zeroResultFound(label: UILabel) -> Int{
        label.text = "No results have found!"
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        label.center = CGPoint(x: self.view.bounds.size.width / 2, y: self.view.bounds.height / 2)
        self.view.addSubview(label)
        return 0
    }
    
    func hideZeroResultFound(label: UILabel) {
        label.removeFromSuperview()
    }
    
}

