//
//  SearchViewController.swift
//  GoogleMapTest
//
//  Created by Admin on 06/02/21.
//

import UIKit

class SearchViewController: UIViewController,UITableViewDelegate {
    @IBOutlet weak var m_searchTextField: CustomSearchTextField!
    
    
    var cityViewModel: CityViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cityViewModel = CityViewModel(self)

        self.cityViewModel.parseJson()

    }

    @IBAction func showAiportdetailsButtonTapped(_ sender: Any) {
//        m_searchTextField.nearestAirportArray
    }
        
    

}
extension SearchViewController: CityListViewModelDelegate {
    func parseCitysSuccess() {
        
    }
    
    func parseCityFailedWithMessage(_ message: String) {
        self.showError(nil, message: message)
    }
}
