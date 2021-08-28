//
//  SplashVC.swift
//  Loodos-OMDB
//
//  Created by Salim Uzun on 26.08.2021.
//

import UIKit
import FirebaseRemoteConfig
import Reachability

class SplashVC: UIViewController {
    @IBOutlet weak var remoteConfigLabel: UILabel!
    //Setup imported library variables
    var remoteConfig = RemoteConfig.remoteConfig()
    let reachability = try! Reachability()
    
    //Segue Variables
    var isReadyToSegue: Bool = false
    var segueTimeout: Double = 3
    var segueNameOfMainVC = "toMainVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        checkReachability()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setupRemoteConfig()
    }

    func checkReachability() {
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
                self.isReadyToSegue = true
            } else {
                print("Reachable via Cellular")
                self.isReadyToSegue = true
            }
        }
        reachability.whenUnreachable = { reachable in
            print("Not reachable")
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func setupRemoteConfig() {
        remoteConfig.fetchAndActivate{ (status, error) in
            if error != nil {
                self.showAlert(errorTitle: "Error", errorMessage: error?.localizedDescription ?? "Remote Config could not fetch & activate")
                print(error?.localizedDescription as Any)
            } else {
                if (status != .error && self.isReadyToSegue == true) {
                    self.readyToSegue()
                }
            }
        }
    }
    func readyToSegue() {
        self.remoteConfigLabel.text = self.remoteConfig["welcomeMessageConfigKey"].stringValue
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + segueTimeout) {
            self.performSegue(withIdentifier: "toMainVC", sender: nil)
        }
    }

}
