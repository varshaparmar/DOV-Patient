//
//  DOVDashboard_VC.swift
//  DOV - Patient
//
//  Created by Admin on 4/26/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class DOVDashboard_VC: BaseViewController {
    
    // MARK: - property declaration
    @IBOutlet var btnLogin:UIButton!
    
    
       // MARK: - Life cycle-------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
         self.title = "Dashboard"
        // Do any additional setup after loading the view.
    }

    // MARK: - Private methods----------------------------------------------------------------------
    
    // MARK: - Action methods-----------------------------------------------------------------------
    
    // MARK: - API Methods--------------------------------------------------------------------------

 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
