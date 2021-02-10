//
//  AirportDetailsTableViewCell.swift
//  GoogleMapTest
//
//  Created by Admin on 07/02/21.
//

import UIKit

class AirportDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var m_airportNameLable: UILabel!
    @IBOutlet weak var m_countryNameLabel: UILabel!
    @IBOutlet weak var m_runwayLengthLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
