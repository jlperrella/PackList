//
//  CollectionViewswift
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
    contentView.layer.cornerRadius = 14.0
    contentView.layer.borderWidth = 1.0
    contentView.layer.borderColor = UIColor.clear.cgColor
    contentView.layer.masksToBounds = true
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize(width: 0, height: 2.0)
    layer.shadowRadius = 2.0
    layer.shadowOpacity = 0.5
    layer.masksToBounds = false
    layer.shadowPath = UIBezierPath(roundedRect:bounds, cornerRadius:contentView.layer.cornerRadius).cgPath
  }
  
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
  
  
  

}
