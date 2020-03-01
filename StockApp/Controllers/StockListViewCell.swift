//
//  StockListViewCell.swift
//  StockApp
//
//  Created by Naoki on 2/29/20.
//  Copyright © 2020 Naoki. All rights reserved.
//

import UIKit

class StockListViewCell: UITableViewCell {

    @IBOutlet weak var stockName: UILabel!
    @IBOutlet weak var stockPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
