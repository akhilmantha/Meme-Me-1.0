//
//  MemeMeDetailViewController.swift
//  Meme Me 1.0
//
//  Created by akhil mantha on 01/04/18.
//  Copyright © 2018 akhil mantha. All rights reserved.
//

import UIKit

class MemeMeDetailViewController: UIViewController {
    
    
    var selectedMeme : Meme!
    
    @IBOutlet weak var detailImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailImageView.image = selectedMeme.memedImage
        detailImageView.contentMode = .scaleAspectFit
    }

  

}
