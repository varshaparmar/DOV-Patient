//
//  DOVMyAppointment_VC.swift
//  DOV - Patient
//
//  Created by Admin on 4/26/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class DOVMyAppointment_VC: BaseViewController {

    // MARK: - Life cycle-------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
           addSlideMenuButton()
   self.title = "My Appointment"
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
// MARK: - table view delegates ****************************************************************
extension DOVMyAppointment_VC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if self.Member.count == nil {
//            return 0
//        }
        return 12
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyappointmentCell", for: indexPath) as! MyappointmentCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("")
    }
    
}
