//
//  optionTableViewCell.swift
//  GlobalDisease
//
//  Created by 姚思妤 on 2020/6/14.
//  Copyright © 2020 姚思妤. All rights reserved.
//

import UIKit

class optionTableViewCell: UITableViewCell {

    @IBOutlet weak var headlineLable: UILabel!
    @IBOutlet weak var severityLable: UILabel!
    @IBOutlet weak var sentLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
