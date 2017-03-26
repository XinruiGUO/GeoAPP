//
//  replayLocation.swift
//  GeoApp
//
//  Created by Xinrui on 23/03/17.
//  Copyright © 2017 Xinrui. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import CoreData
import PCLBlurEffectAlert

class ReplayController: UIViewController, TimePickerDelegate {
    
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var endBtn: UIButton!
    @IBOutlet weak var startTmLabel: UILabel!
    @IBOutlet weak var endTmLabel: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    
  
    var selectStartTimeF : Bool?
    var startTm = Date()
    var endTm = Date()
    typealias Point = (Double, Double, Date)
    let googleMapView = GoogleMapView()
    let replayDao = ReplayDao()

    override func viewDidLoad() {
        super.viewDidLoad()

        startBtn.roundButton(text: "Start time")
        endBtn.roundButton(text: "End time")
        submitBtn.roundButton(text: "Submit")
        
        googleMapView.loadReplayMap(bound: mapView.bounds)
        mapView.addSubview(googleMapView.mapView!)
    }

    
    @IBAction func selectStartTime(_ sender: Any) {
        selectStartTimeF = true
        let tvc = storyboard?.instantiateViewController(withIdentifier: "timePicker") as! TimePicker
        tvc.data = "-" as AnyObject?
        tvc.delegate = self
        self.present(tvc, animated: true, completion: nil)
    }
   
    @IBAction func selectEndTime(_ sender: Any) {
        selectStartTimeF = false
        let tvc = storyboard?.instantiateViewController(withIdentifier: "timePicker") as! TimePicker
        tvc.data = "-" as AnyObject?
        tvc.delegate = self
        self.present(tvc, animated: true, completion: nil)
    }
    
    
    @IBAction func submitTimeInterval(_ sender: Any) {
        print("startTm: ", startTm)
        // Need to do
        if startTmLabel.text != "Sélectez le start time" && endTmLabel.text != "Sélectez le end time"{
            if startTm < endTm {
                let coordinates = replayDao.fetchAndPrintEachCoordinate(startTm: startTm, endTm: endTm)
                if coordinates.count == 0 {
                    alert(title: "Auncun données trouvé", message: "Resélectionnez les dates, ou obtenez des données en utilisant le monitoring en temps-réel, s'il vous plaît.", btnTitle: "ok")
                }else {
                    googleMapView.mapView?.clear()
                    googleMapView.drawPolylineWithPointArray(coordinates: coordinates)
                }
            }else {
                alert(title: "Le start time ne peut pas superieur au end time.", message: "Resélectionnez les dates, s'il vous plaît.", btnTitle: "ok")
            }

        }else {
            alert(title: "", message: "Sélectionnez une période, s'il vous plaît.", btnTitle: "Annuler")
        }
    }
    
    func alert(title: String, message: String, btnTitle: String) {
        let alert = PCLBlurEffectAlert.Controller(title: title, message: message, effect: UIBlurEffect(style: .light), style: .alert)
        let alertBtn = PCLBlurEffectAlert.AlertAction(title: btnTitle, style: .cancel, handler: nil)
        alert.addAction(alertBtn)
        
        alert.configure(cornerRadius: 30)
        alert.configure(titleFont: UIFont.systemFont(ofSize: 17), titleColor: .white)
        alert.configure(messageFont: UIFont.systemFont(ofSize: 12), messageColor: .white)
        alert.configure(backgroundColor: .blue)
        alert.show()
    }

    
    
    func acceptData(data: AnyObject) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        if selectStartTimeF == true {
            let sdate = dateFormatter.string(from: data as! Date)
            startTmLabel.text = sdate

            startTm = data as! Date
        }else {
            let edate = dateFormatter.string(from: data as! Date)
            endTmLabel.text = edate
            endTm = data as! Date
        }
        
        print("data passed: ","\(data)")
    }

   
    @IBAction func back(_ sender: Any) {
        let mainFrameVC  :UIViewController = self.storyboard?.instantiateViewController(withIdentifier: "mainFrameVC") as! MainFrameController
        let navController = UINavigationController(rootViewController: mainFrameVC)
        navController.modalTransitionStyle = .crossDissolve
        self.present(navController, animated: true, completion: nil)
    }
}

extension UIButton {
    func roundButton(text: String) {
        let titleString = NSMutableAttributedString(string: text)
        
        self.setAttributedTitle(titleString, for: .normal)
        self.titleLabel?.textColor = .white
        self.layer.cornerRadius = self.bounds.size.height / 2
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor(colorLiteralRed: 106/255, green: 173/255, blue: 251/255, alpha: 0.85).cgColor
        self.clipsToBounds = true
        self.contentMode = .scaleToFill
    }
}
