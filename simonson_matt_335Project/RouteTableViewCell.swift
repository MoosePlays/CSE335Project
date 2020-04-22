//
//  RouteTableViewCell.swift
//  simonson_matt_335Project
//
//  Created by Michael Figueroa on 4/21/20.
//  Copyright © 2020 mjsimons. All rights reserved.
//

import UIKit

class RouteTableViewCell: UITableViewCell {

    @IBOutlet weak var routeName: UILabel!
    @IBOutlet weak var routeGrade: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
