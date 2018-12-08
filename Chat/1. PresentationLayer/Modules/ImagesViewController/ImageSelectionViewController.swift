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
    weak var delegate: ProfileImageDelegate?
    private let IMAGE_REUSABLE_CELL_ID = "ImageCollectionViewCell"
    private let IMAGE_NIB_NAME = "ImageCollectionViewCell"
    
    private var imagesAmount: Int = 0 {
        didSet {
            imagesCollectionView.reloadData()
        }
    }
    
    // MARK: - Dependencies
    private var imageDownloadService: IImageDownloadService?


    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    

    
    //MARK: - Public Methods
    private func configure() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        imagesCollectionView.register(UINib.init(nibName: self.IMAGE_NIB_NAME, bundle: nil), forCellWithReuseIdentifier: self.IMAGE_REUSABLE_CELL_ID)
        
        
        
        DispatchQueue.global().async { [weak self] in
            self?.imageDownloadService?.performRequest { (itemsCount) in
                DispatchQueue.main.async {
                    self?.imagesAmount = itemsCount
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    public func configureViewController(service: IImageDownloadService) {
        self.imageDownloadService = service
    }
    
}
