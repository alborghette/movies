//
//  PosterViewController.swift
//  movies
//
//  Created by Murilo Alves Alborghette on 8/20/19.
//  Copyright © 2019 Alborghette. All rights reserved.
//

import UIKit
import Kingfisher

class PosterViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var posterImageView: UIImageView!
    
    var posterUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        posterImageView.kf.setImage(with: posterUrl)
    }
    
    private func setupLayout() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        closeButton.setTitle(R.string.localizable.posterViewCloseButtonTitle(), for: .normal)
        posterImageView.roundCorners(withRadius: 5)
    }

    @IBAction func closeDidTap() {
        dismiss(animated: true, completion: nil)
    }

}
