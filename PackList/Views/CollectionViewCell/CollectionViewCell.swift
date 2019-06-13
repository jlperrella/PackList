//
//  CollectionViewCell.swift
//  PackList
//
//  Created by jp on 2019-06-13.
//  Copyright © 2019 Jordan Perrella. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var cellLabel: UILabel!

  func setCell(text:String, color:UIColor){
    cellLabel.text = text
    backgroundColor = color
    layer.cornerRadius = 14.0
  }
  
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
  
  
  

}
