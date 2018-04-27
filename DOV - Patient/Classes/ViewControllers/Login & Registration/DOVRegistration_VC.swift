//
//  DOVRegistration_VC.swift
//  DOV - Patient
//
//  Created by Admin on 4/26/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class DOVRegistration_VC: UIViewController {
    
    
    // MARK: - property declaration
    
    @IBOutlet var txtName:UITextField?
    @IBOutlet var txtEmail:UITextField?
    @IBOutlet var txtphonenumber:UITextField?
    @IBOutlet var txtpassword:UITextField?
    @IBOutlet var txtconfirmpassword:UITextField?
    
    // MARK: - Life cycle-------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    // MARK: - private methods------------------------------------------------------------------
    func CanRegister() -> Bool {
        
        if !Util.isValidString("") {
            Util.showAlertWithMessage("Please enter Name", title: Key_Alert)
            return false
        }else if !Util.isValidString("") {
            Util.showAlertWithMessage("Please enter Phone number", title: Key_Alert)
            return false
        }
        else if !Util.isValidString("") {
            Util.showAlertWithMessage("Please enter email address", title: Key_Alert)
            return false
        }
        else if !Util.isValidEmail("") {
            Util.showAlertWithMessage("Please enter valid email address", title: Key_Alert)
            return false
        } else if !Util.isValidString("") {
            Util.showAlertWithMessage("Please enter password", title: Key_Alert)
            return false
        }
        else if !Util.isValidString("") {
            Util.showAlertWithMessage("Please entr confirm password", title: Key_Alert)
            return false
        }
        return true
    }
    // MARK: - Action methods-----------------------------------------------------------------
    
    @IBAction func click_signin(sender:Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func click_signup(sender:Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DOVSendOTP_VC")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
  
    @IBAction func click_TermsAndCondition(sender:Any)
    {
        let storyboard = UIStoryboard.init(name: "DOVDashboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DOVTandC_VC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - APIs methods--------------------------------------------------------------------
    
    func RegisterAPI()  {
        
    }
    
    
    // MARK: - Memory deallocation---------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
