//
//  ImageSelectionViewController.swift
//  Chat
//
//  Created by Andrey Koltsov on 08/12/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import UIKit

class ImageSelectionViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    // MARK: - Properties
    private var imagesAmount: Int = 0 {
        didSet {
            imagesCollectionView.reloadData()
        }
    }
    
    weak var delegate: ProfileImageDelegate?
    
    private var imageDownloadService: IImageDownloadService?

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    //MARK: - Public Methods
    public func configureViewController(service: IImageDownloadService) {
        self.imageDownloadService = service
    }
}
