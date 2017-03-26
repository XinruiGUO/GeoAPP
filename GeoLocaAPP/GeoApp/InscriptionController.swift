//
//  Inscription.swift
//  GeoApp
//
//  Created by Xinrui on 24/03/17.
//  Copyright © 2017 Xinrui. All rights reserved.
//

import UIKit
import CoreData
import PCLBlurEffectAlert

class InscriptionController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var password: UITextField!

    var email = String()
    var passw = String()
    let alertController = AlertController()
    
    let inscriDao = InscriptionDao()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeKeyboardNotifications()
        hideKeyboardByTap()
        
        mail.attributedPlaceholder = NSAttributedString(string:"Adresse email", attributes: [NSForegroundColorAttributeName: UIColor.white])
        password.attributedPlaceholder = NSAttributedString(string:"Mot de passe", attributes: [NSForegroundColorAttributeName: UIColor.white])
    }

    @IBAction func returnToLogin(_ sender: Any) {
        let logVC  :UIViewController = self.storyboard?.instantiateViewController(withIdentifier: "loginController") as! LoginController
        logVC.modalTransitionStyle = .crossDissolve
        self.present(logVC, animated: true, completion: nil)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        if mail.text?.isEmpty == true || password.text?.isEmpty == true {
            alertController.alert(title: "Le champ est vide", message: "", btnTitle: "Annuler")
        }else if validateEmail(candidate: mail.text!) == false {
            alertController.alert(title: "L'expression de l'adresse mail est incorrecte", message: "", btnTitle: "Annuler")
        }else {
            inscriDao.saveCoordinates(mailAddress: email, pass: passw)

            let mainFrameVC  :UIViewController = self.storyboard?.instantiateViewController(withIdentifier: "mainFrameVC") as! MainFrameController
            let navController = UINavigationController(rootViewController: mainFrameVC)
            navController.modalTransitionStyle = .crossDissolve
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    
    // Check the regular expression of textField
    func validateEmail(candidate: String) -> Bool
    {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
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
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    func keyboardShow() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: -80, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    func hideKeyboardTap(recoginizer:UITapGestureRecognizer){
        
        self.view.endEditing(true)
    }
    
    
    /*UITextField*/
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        switch textField {
        case mail:
            email = mail.text!
        case password:
            passw = password.text!
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
