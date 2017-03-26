//
//  timePicker.swift
//  GeoApp
//
//  Created by Xinrui on 23/03/17.
//  Copyright © 2017 Xinrui. All rights reserved.
//

import Foundation
import UIKit


protocol TimePickerDelegate {
    func acceptData(data: AnyObject)
}
class TimePicker: UIViewController {
    
    var delegate : TimePickerDelegate?
    var data : AnyObject?
    var strDate = Date()
    
    @IBOutlet weak var myDatePicker: UIDatePicker!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBAction func submitTime(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isBeingDismissed {
            self.delegate?.acceptData(data: strDate as AnyObject!)
        }
        print("viewWillDisappear")
    }
    
    @IBAction func datePickerAction(_ sender: Any) {
        
        strDate = myDatePicker.date
        print("date : ", strDate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myDatePicker.maximumDate = Date()
    }
}
