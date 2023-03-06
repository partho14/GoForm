//
//  NavViewCollectionViewCell.swift
//  GoForm
//
//  Created by Annanovas IT on 27/1/23.
//

import UIKit

class NavViewCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var cellView: UIView!{
        didSet{
            cellView.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var cellIcon: UIImageView!
    @IBOutlet weak var cellTittle: UILabel!{
        didSet{
            cellTittle.numberOfLines = 1
            cellTittle.adjustsFontSizeToFitWidth = true
            cellTittle.textAlignment = .center
        }
    }
}
