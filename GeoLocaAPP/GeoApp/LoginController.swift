//
//  ViewController.swift
//  GeoApp
//
//  Created by Xinrui on 20/03/17.
//  Copyright © 2017 Xinrui. All rights reserved.
//

import UIKit
import CoreData
import PCLBlurEffectAlert

class LoginController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var inscriBtn: UIButton!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    
    var email = String()
    var password = String()

        
    func alert(title: String, message: String, btnTitle: String) {
        let alertPanel = PCLBlurEffectAlert.Controller(title: title, message: message, effect: UIBlurEffect(style: .dark), style: .alert)
        let cancelBtn = PCLBlurEffectAlert.AlertAction(title: btnTitle, style: .cancel, handler: nil)
        alertPanel.addAction(cancelBtn)
        alertPanel.configure(cornerRadius: 30)
        alertPanel.configure(titleFont: UIFont.systemFont(ofSize: 15), titleColor: .white)
        alertPanel.configure(backgroundColor: .blue)
        alertPanel.show()
    }
    
    @IBAction func login(_ sender: Any) {
        
        if emailLabel.text?.isEmpty == true || passwordLabel.text?.isEmpty == true {
            alert(title: "Le champ est vide", message: "", btnTitle: "Annuler")
            return
        }
        let loginDao = LoginDao()
        let isLoginSuccess = loginDao.fetchAndPrintUser(email: email, password: password)
        if true == isLoginSuccess {
            let mainFrameVC  :UIViewController = self.storyboard?.instantiateViewController(withIdentifier: "mainFrameVC") as! MainFrameController
            let navController = UINavigationController(rootViewController: mainFrameVC)
            navController.modalTransitionStyle = .crossDissolve
            self.present(navController, animated: true, completion: nil)
        }else {
            alert(title: "Votre compte n'est pas correct", message: "", btnTitle: "Annuler")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeKeyboardNotifications()
        inscriBtn.underlineButton(text: "Pas encore inscrit?")
        emailLabel.attributedPlaceholder = NSAttributedString(string:"Adresse email", attributes: [NSForegroundColorAttributeName: UIColor.white])
        passwordLabel.attributedPlaceholder = NSAttributedString(string:"Mot de passe", attributes: [NSForegroundColorAttributeName: UIColor.white])
        hideKeyboardByTap()
    }

    /*Keyboard*/
    func hideKeyboardByTap() {
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardTap(recoginizer:)))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
    }

    
    fileprivate func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func keyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    func keyboardShow() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: -60, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    func hideKeyboardTap(recoginizer:UITapGestureRecognizer){

        self.view.endEditing(true)
    }
    
    
    /*UITextField*/
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        switch textField {
        case emailLabel:
            email = emailLabel.text!
        case passwordLabel:
            password = passwordLabel.text!
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}

extension UIButton {
    func underlineButton(text: String) {
        let titleString = NSMutableAttributedString(string: text)
        titleString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(0, text.characters.count))
        self.setAttributedTitle(titleString, for: .normal)
        self.titleLabel?.textColor = .white
    }
}
