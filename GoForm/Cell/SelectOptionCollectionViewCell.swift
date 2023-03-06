//
//  SelectOptionCollectionViewCell.swift
//  GoForm
//
//  Created by Annanovas IT on 24/1/23.
//

import UIKit

class SelectOptionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellView: UIView!{
        didSet{
            cellView.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var cellTextField: UILabel!{
        didSet{
            cellTextField.numberOfLines = 1
            cellTextField.adjustsFontSizeToFitWidth = true
            cellTextField.textAlignment = .center
        }
    }
    @IBOutlet weak var cellImage: UIImageView!
}
