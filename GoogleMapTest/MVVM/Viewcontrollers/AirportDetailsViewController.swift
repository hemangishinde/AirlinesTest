//
//  AirportDetailsViewController.swift
//  GoogleMapTest
//
//  Created by Admin on 07/02/21.
//

import UIKit

class AirportDetailsViewController: UIViewController {
    @IBOutlet weak var m_airportDetailsTableView: UITableView!
    var tableViewDatasource: AirportDetailsTableViewDatasources!

    override func viewDidLoad() {
        super.viewDidLoad()
        m_airportDetailsTableView.estimatedRowHeight = 150
        m_airportDetailsTableView.rowHeight = UITableView.automaticDimension
        self.tableViewDatasource = AirportDetailsTableViewDatasources()
        m_airportDetailsTableView.dataSource = self.tableViewDatasource
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
