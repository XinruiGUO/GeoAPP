//
//  MenuPage.swift
//  GeoApp
//
//  Created by Xinrui on 20/03/17.
//  Copyright © 2017 Xinrui. All rights reserved.
//

import Foundation
import UIKit
import PCLBlurEffectAlert

class MainFrameController: UIViewController {
    
    @IBOutlet weak var realTimeBtn: UIButton!
    @IBOutlet weak var replayBtn: UIButton!    

    @IBAction func mainMenu(_ sender: Any) {
        settingsAlert()
    }
 
    
    func settingsAlert() {
        
        let alertPanel = PCLBlurEffectAlert.Controller(title: "", message: "", effect: UIBlurEffect(style: .dark), style: .alert)
        let deconnectBtn = PCLBlurEffectAlert.AlertAction(title: "Déconnexion", style: .default) { _ in
            self.toLoginPage()
        }
        
        let cancelBtn = PCLBlurEffectAlert.AlertAction(title: "Annuler", style: .cancel, handler: nil)
        alertPanel.addAction(deconnectBtn)
        alertPanel.addAction(cancelBtn)
        
        alertPanel.configure(cornerRadius: 30)
        alertPanel.configure(titleFont: UIFont.systemFont(ofSize: 18), titleColor: .white)
        alertPanel.configure(backgroundColor: .blue)
        alertPanel.configure(buttonTextColor: [.default: .white,
                                               .cancel: .white,
                                               .destructive: .white])
        alertPanel.show()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realTimeBtn.cycleButton(text: "Temps-réel")
        replayBtn.cycleButton(text: "Replay")
    }
    
    func toLoginPage()  {
        let logVC  :UIViewController = self.storyboard?.instantiateViewController(withIdentifier: "loginController") as! LoginController
        logVC.modalTransitionStyle = .crossDissolve
        self.present(logVC, animated: true, completion: nil)
    }
}

extension UIButton {
    func cycleButton(text: String) {
        let titleString = NSMutableAttributedString(string: text)
        
        self.setAttributedTitle(titleString, for: .normal)
        self.titleLabel?.textColor = .white
        self.layer.cornerRadius = self.bounds.size.height / 2
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.white.cgColor
        self.clipsToBounds = true
        self.contentMode = .scaleToFill
    }
}
