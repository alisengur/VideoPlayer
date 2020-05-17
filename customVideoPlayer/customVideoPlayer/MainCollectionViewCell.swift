//
//  MainCollectionViewCell.swift
//  customVideoPlayer
//
//  Created by Ali Şengür on 7.05.2020.
//  Copyright © 2020 Ali Şengür. All rights reserved.
//

import UIKit
import Kingfisher

protocol MainCollectionViewCellDelegate {
    func didTapPlayButton(index: Int)
}


class MainCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playButton: UIButton! {
        didSet {
            playButton.isHidden = isHiddenPlayButton
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var delegate: MainCollectionViewCellDelegate?
    var index: IndexPath?
    var isHiddenPlayButton: Bool = false
    
    
    func cellInit(imageURL: String, description: String) {
        let url = URL(string: imageURL)
        imageView.kf.setImage(with: url)
        descriptionLabel.text = description
        descriptionLabel.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        setCellShadow()
        setPlayButton()
    }
    
    func setCellShadow() {
        self.contentView.layer.cornerRadius = 2.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)//CGSizeMake(0, 2.0);
        self.layer.shadowRadius = 8.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
    
    fileprivate func setPlayButton() {
        let origImage = UIImage(named: "play")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        playButton.setImage(tintedImage, for: .normal)
        playButton.tintColor = .white
        
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        delegate?.didTapPlayButton(index: index!.row)
    }
}
