//
//  alertController.swift
//  GeoApp
//
//  Created by Xinrui on 26/03/17.
//  Copyright © 2017 Xinrui. All rights reserved.
//

import PCLBlurEffectAlert

class AlertController {
    
 //   let inscriptionController = InscriptionController()
    
    func ageAlert() {
        var age = String()
        let alertPanel = PCLBlurEffectAlert.Controller(title: "", message: "", effect: UIBlurEffect(style: .dark), style: .alert)
        let btn0 = PCLBlurEffectAlert.AlertAction(title: "0 ~ 17", style: .default) { _ in
            age = "age_0_17"
            
        }

        
        let btn1 = PCLBlurEffectAlert.AlertAction(title: "18 ~ 24", style: .default) { _ in
            age = "age_18_24"
        }
        
        let btn2 = PCLBlurEffectAlert.AlertAction(title: "25 ~ 34", style: .default) { _ in
            age = "age_25_34"
        }
        
        let btn3 = PCLBlurEffectAlert.AlertAction(title: "35 ~ 44", style: .default) { _ in
            age = "age_35_44"
        }
        
        let btn4 = PCLBlurEffectAlert.AlertAction(title: "45 ~ 54", style: .default) { _ in
            age = "age_45_54"
        }
        
        let btn5 = PCLBlurEffectAlert.AlertAction(title: "55 ~ 64", style: .default) { _ in
            age = "age_55_64"
        }
        
        
        let cancelBtn = PCLBlurEffectAlert.AlertAction(title: "Annuler", style: .cancel, handler: nil)
        alertPanel.addAction(btn0)
        alertPanel.addAction(btn1)
        alertPanel.addAction(btn2)
        alertPanel.addAction(btn3)
        alertPanel.addAction(btn4)
        alertPanel.addAction(btn5)
        alertPanel.addAction(cancelBtn)
        
        alertPanel.configure(cornerRadius: 30)
        alertPanel.configure(titleFont: UIFont.systemFont(ofSize: 18), titleColor: .white)
        alertPanel.configure(backgroundColor: .blue)
        alertPanel.configure(buttonTextColor: [.default: .white,
                                               .cancel: .white,
                                               .destructive: .white])
        alertPanel.show()
    }
    var gender = String()
    func genderAlert(){
        
        
        let alertPanel = PCLBlurEffectAlert.Controller(title: "", message: "", effect: UIBlurEffect(style: .dark), style: .alert)
        let femaleBtn = PCLBlurEffectAlert.AlertAction(title: "Female", style: .default) { _ in
          //  self.inscriptionController.gender = "female"
            
            print("femaleBtn: ", self.gender)
        }
        
        let malBtn = PCLBlurEffectAlert.AlertAction(title: "Male", style: .default) { _ in
           // self.inscriptionController.gender = "male"
            print("maleBtn: ", self.gender)
            
        }
        
        let unknownBtn = PCLBlurEffectAlert.AlertAction(title: "Unknown", style: .default) { _ in
           // self.inscriptionController.gender = "unknown"
            print("unknown: ", self.gender)
        }
        
        let cancelBtn = PCLBlurEffectAlert.AlertAction(title: "Annuler", style: .cancel) { _ in
           // self.inscriptionController.gender = "unknown"
        }

        alertPanel.addAction(femaleBtn)
        alertPanel.addAction(malBtn)
        alertPanel.addAction(unknownBtn)
        alertPanel.addAction(cancelBtn)
        
        alertPanel.configure(cornerRadius: 30)
        alertPanel.configure(titleFont: UIFont.systemFont(ofSize: 18), titleColor: .white)
        alertPanel.configure(backgroundColor: .blue)
        alertPanel.configure(buttonTextColor: [.default: .white,
                                               .cancel: .white,
                                               .destructive: .white])
        alertPanel.show()
    }
    
    func alert(title: String, message: String, btnTitle: String) {
        let alert = PCLBlurEffectAlert.Controller(title: title, message: message, effect: UIBlurEffect(style: .dark), style: .alert)
        let alertBtn = PCLBlurEffectAlert.AlertAction(title: btnTitle, style: .cancel, handler: nil)
        alert.addAction(alertBtn)
        
        alert.configure(cornerRadius: 30)
        alert.configure(backgroundColor: .blue)
        alert.show()
    }
}
