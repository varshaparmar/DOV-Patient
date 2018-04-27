//
//  ViewController.swift
//  DOV - Patient
//
//  Created by Admin on 4/26/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    // MARK: - Property declaration-----------------------------------------------------------------
    @IBOutlet var txtPwd:UITextField!
    @IBOutlet var txtEmail:UITextField!
    
    
     // MARK: - Life cycle-----------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
   
    
    // MARK: - Action methods-----------------------------------------------------------------
    @IBAction func Click_Login(sender:Any)
    {
        let storyboard = UIStoryboard.init(name: "DOVDashboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DOVDashboard_VC")
        let navigationController = UINavigationController(rootViewController: vc)
        appDelegate.window?.rootViewController = navigationController
    }
    @IBAction func Click_Registration(sender:Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DOVRegistration_VC")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func Click_Forgotpassword(sender:Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DOVForgotpassword_VC")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    // MARK: - private methods------------------------------------------------------------------
    func CanLogin() -> Bool {
        
        if !Util.isValidString((txtEmail.text)!) {
            Util.showAlertWithMessage("Please enter Name", title: Key_Alert)
            return false
        }else if !Util.isValidString((txtPwd.text)!) {
            Util.showAlertWithMessage("Please enter Password", title: Key_Alert)
            return false
        }else if !Util.isValidEmail((txtEmail.text)!) {
            Util.showAlertWithMessage("Please enter valid email address", title: Key_Alert)
            return false
        }
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

