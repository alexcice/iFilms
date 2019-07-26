//
//  DetalleTableViewCell.swift
//  iFilms
//
//  Created by Alejandro on 13/07/2019.
//  Copyright © 2019 Alejandro. All rights reserved.
//

import UIKit

class DetalleTableViewCell: UITableViewCell {

    
    @IBOutlet weak var textoLabel: UILabel!{
        didSet {
            textoLabel.numberOfLines = 0
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
