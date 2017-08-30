//
//  BorderButton.swift
//  Apartments
//
//  Created by Ebubekir Ogden on 4/10/17.
//  Copyright © 2017 Ebubekir. All rights reserved.
//

import UIKit

class BorderButton: UIButton {

    override func awakeFromNib() {
        
        let corderRadius: CGFloat = 5.0
        
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = corderRadius
    }

}
