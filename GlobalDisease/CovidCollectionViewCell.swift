//
//  CovidCollectionViewCell.swift
//  GlobalDisease
//
//  Created by 姚思妤 on 2020/6/23.
//  Copyright © 2020 姚思妤. All rights reserved.
//

import UIKit

class CovidCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var people: UILabel!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = 13
    }
    
}
