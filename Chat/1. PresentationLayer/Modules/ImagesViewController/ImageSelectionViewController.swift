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
    public var profileImageDelegate: ProfileImageDelegate?

    private let IMAGE_REUSABLE_CELL_ID = "ImageCollectionViewCell"
    private let IMAGE_NIB_NAME = "ImageCollectionViewCell"

    private var imagesAmount: Int = 0 {
        didSet {
            imagesCollectionView.reloadData()
        }
    }
    
    // MARK: - Dependencies
    private var imageDownloadService: IImageManagerService?

    
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
        
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        
        DispatchQueue.global().async { [weak self] in
            self?.imageDownloadService?.performRequest { (itemsCount) in
                DispatchQueue.main.async {
                    self?.imagesAmount = itemsCount
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    public func configureViewController(service: IImageManagerService) {
        self.imageDownloadService = service
    }
    
}

// MARK: - UICollectionViewDataSource

extension ImageSelectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imagesAmount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.IMAGE_REUSABLE_CELL_ID, for: indexPath) as? ImageCollectionViewCell else {
            let misleadingMsg = "Unable to get image collection cell instance."
            print(misleadingMsg)
            fatalError()
            
        }
        guard let image = cell.loadingImage else {
            let misleadingMsg = "Loading image instance hasn't been loaded."
            print(misleadingMsg)
            return UICollectionViewCell()
        }
        
        image.frame = cell.bounds
        
        if let url = imageDownloadService?.getWebFormatURL(index: indexPath.row) {
            DispatchQueue.global().async {
                image.loadImage(from: url)
            }
        }
        
        return cell
    }
    
}


// MARK: - UICollectionViewDelegateFlowLayout

extension ImageSelectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let amountOfImagesInRow = CGFloat(3.0)
        
        let cellWidth = width / amountOfImagesInRow
        let targetSize = CGSize(width: cellWidth, height: cellWidth)
        return targetSize
    }
}

// MARK: - UICollectionViewDelegate

extension ImageSelectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let imageURL = imageDownloadService?.getWebFormatURL(index: indexPath.row) else {
            let misleadingMsg = "Unable to get image URL."
            print(misleadingMsg)
            return
        }
        
        self.imageDownloadService?.load(url: imageURL) { (image) in
            DispatchQueue.main.async { [weak self] in
               self?.profileImageDelegate?.setImage(image: image)
                self?.dismiss(animated: true, completion: nil)
            }
        }
        
    }
}
