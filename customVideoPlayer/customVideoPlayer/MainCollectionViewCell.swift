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
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var delegate: MainCollectionViewCellDelegate?
    var index: IndexPath?
    
    
    func cellInit(imageURL: String, description: String) {
        let url = URL(string: imageURL)
        imageView.kf.setImage(with: url)
        descriptionLabel.text = description
        setPlayButton()
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
