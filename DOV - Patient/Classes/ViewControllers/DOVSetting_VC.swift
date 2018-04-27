//
//  DOVSetting_VC.swift
//  DOV - Patient
//
//  Created by Admin on 4/26/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class DOVSetting_VC: BaseViewController {

    // MARK: - Life cycle-------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
   addSlideMenuButton()
           self.title = "Setting"
        // Do any additional setup after loading the view.
    }

    // MARK: - Private methods----------------------------------------------------------------------
    
    // MARK: - Action methods-----------------------------------------------------------------------
    
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
