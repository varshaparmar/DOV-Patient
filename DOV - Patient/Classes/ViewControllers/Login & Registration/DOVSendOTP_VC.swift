//
//  DOVSendOTP_VC.swift
//  DOV - Patient
//
//  Created by Admin on 4/27/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class DOVSendOTP_VC: UIViewController {
    
    @IBOutlet var txtOTP:UITextField!
  

       // MARK: - Life cycle-------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    // MARK: - Private methods----------------------------------------------------------------------
    
    // MARK: - Action methods-----------------------------------------------------------------------
    
    @IBAction func Click_submitOTP(sender:Any)
    {
        let storyboard = UIStoryboard.init(name: "DOVDashboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DOVDashboard_VC")
        let navigationController = UINavigationController(rootViewController: vc)
        appDelegate.window?.rootViewController = navigationController
    }
    
    // MARK: - API Methods--------------------------------------------------------------------------

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
