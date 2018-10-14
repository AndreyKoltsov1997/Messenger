//
//  ProfileViewController.swift
//  Chat
//
//  Created by Andrey Koltsov on 30/09/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userDiscriptionLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var profilePictureImage: UIImageView!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBAction func dismissBtnClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    // MARK: Outlet methods
    
    @IBAction func chooseImageButtonPressed(_ sender: UIButton) {
        print(Constants.CHOOSE_IMAGE_BTN_PRESSED_LOG)
        let chooseImageAlertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // NOTE: chooseImageAlertVC actions
        let chooseImageFromGalleryAction = UIAlertAction(title: Constants.OPTION_OPEN_LIBRARY_DEFAULT_TITLE, style: .default) {
            _ in self.processImageChoosingFromGallery()
        }
        chooseImageAlertVC.addAction(chooseImageFromGalleryAction)
        
        let cameraSource = UIImagePickerControllerSourceType.camera
        if UIImagePickerController.isSourceTypeAvailable(cameraSource) {
            let takePhotoAction = UIAlertAction(title: Constants.OPTION_TAKE_PHOTO_DEFAULT_TITLE, style: .default) {
                _ in self.openCameraIfAvaliable(forSource: cameraSource)
            }
            chooseImageAlertVC.addAction(takePhotoAction)
        }
        
        self.present(chooseImageAlertVC, animated: true) {
            chooseImageAlertVC.view.superview?.subviews.first?.isUserInteractionEnabled = true
            chooseImageAlertVC.view.superview?.subviews.first?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.actionDismissChooseImageAlert)))
        }
    }
    
    // MARK: ViewController methods
    
    @objc func actionDismissChooseImageAlert() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func openCameraIfAvaliable(forSource cameraSource: UIImagePickerControllerSourceType) {
        // NOTE: Check camera permission
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = cameraSource
                imagePicker.allowsEditing = true
                imagePicker.delegate = self
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                let misleadingMessage = "Camera can't be used without permission"
                self.showRequestSourceAlert(message: misleadingMessage)
            }
        }
    }
    
    private func processImageChoosingFromGallery() {
        let photoLibrarySource = UIImagePickerControllerSourceType.photoLibrary
        if UIImagePickerController.isSourceTypeAvailable(photoLibrarySource) {
            self.openGalleryIfAvaliable(forSource: photoLibrarySource)
        } else {
            let misleadingMessage = "Photo library is not avaliable"
            self.showActionNotAvaliableAlert(message: misleadingMessage)
        }
    }
    
    private func openGalleryIfAvaliable(forSource photoLibrarySource: UIImagePickerControllerSourceType) {
        let photoLibraryAccessStatus = PHPhotoLibrary.authorizationStatus()
        if photoLibraryAccessStatus == .notDetermined {
            PHPhotoLibrary.requestAuthorization( { status in
                if status == .authorized {
                    self.openGallery(source: photoLibrarySource)
                } else {
                    let misleadingMessage = "Profile picture couldn't be selected from library without access."
                    self.showActionNotAvaliableAlert(message: misleadingMessage)
                }
            })
        } else if (photoLibraryAccessStatus == .denied || photoLibraryAccessStatus == .restricted) {
            let misleadingMessage = "In order to select image from library, set \"Photo Library\" access for the app in Settings."
            self.showRequestSourceAlert(message: misleadingMessage)
        } else {
            self.openGallery(source: photoLibrarySource)
        }
    }
    
    private func showRequestSourceAlert(message: String) {
        let alert = UIAlertController(title: Constants.ALERT_RESOURCE_NOT_AVALIABLE_DEFAULT_TITLE, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.OPTION_OPEN_SETTINGS_DEFAULT_TITLE, style: .default) { action in
            self.openSettings()
        })
        alert.addAction(UIAlertAction(title: Constants.OPTION_DISMISS_FEAULT_TITLE, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showActionNotAvaliableAlert(message:String) {
        let alert  = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func openSettings() {
        UIApplication.shared.open(URL.init(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
    }
    
    private func openGallery(source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: ProfileViewController lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Возникла проблема: мы не можем распечатать свойства frame'a. На этом этапе компилятор связывает файл интерфейс-билдера (.xib) c  ViewController'ом, чтобы затем загружать из него нужные нам View.
        // Соответственно, в данный момент, доступ к этим самым используемым View отсутствует.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let methodTag = "viewDidAppear"
        print("[ProfileViewController.\(methodTag)] Edit button configuration: \(editProfileButton.frame)")
        /* Изменились значения: minY, width. Это происзошло из-за того, что, после загрузки view из файла интерфейс билдера (.xib), беруться значения frame'a superview того девайся, который был использован при проектировании (в нашем случае - iPhone SE). После того, как view появилось на запускаемом девайсе, размера editProfileButton (кнопки редактирования) изменяются. В нашем случае, произошли следующие изменения:
         minY - изменился в соответствии с указанными констрейнтами (и приоритетами) по отношению к userDiscriptionLabel, учитывая бОльший экран iPhone 8 Plus;
         width - изменился, т.к. отступы по краям остались такими же (20), а ширина самого экрана увеличилась;
         */
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayoutSources()
        let methodTag = "viewDidLoad"
        print("[ProfileViewController.\(methodTag)] Edit button configuration: \(editProfileButton.frame)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UI configuring methods
    
    private func setUpLayoutSources() {
        // NOTE: Here I'm setting up initial values for sources that could be changed in a runtime
        
        // profilePictureImage sources
        profilePictureImage.image = UIImage(named: Constants.PROFILE_PICTURE_PLACEHOLDER_IMAGE_NAME)
        
        // userNameLabel sources
        userNameLabel.text = Constants.DEFAULT_USERNAME
        
        // userDiscriptionLabel sources
        userDiscriptionLabel.text = Constants.DEFAULT_USER_DISCRIPTION
        userDiscriptionLabel.textColor = Constants.USER_DISCRIPTION_TEXT_DEFAULT_COLOR
        userDiscriptionLabel.textAlignment = .justified
        
        // editProfileButton sources
        editProfileButton.backgroundColor = .white
        editProfileButton.layer.borderColor = UIColor.black.cgColor
        editProfileButton.setTitleColor(UIColor.black, for: .normal)
    }
    
    private func configureLayout() {
        let multiplierToFormCircle = CGFloat(0.5)
        let CORNER_RADIUS_FOR_PROFILE_ICON = chooseImageButton.bounds.height * multiplierToFormCircle
   
        
        
        // NOTE: configuring chooseImageButton
        let paddingValueInPercentage = CGFloat(0.1)
        let paddingForBackgroundPicture = self.chooseImageButton.frame.size.width * paddingValueInPercentage
        chooseImageButton.backgroundColor = Constants.PROFILE_VC_BLUE_COLOR
        chooseImageButton.layer.cornerRadius = CORNER_RADIUS_FOR_PROFILE_ICON
        self.chooseImageButton.contentEdgeInsets = UIEdgeInsets(
            top: paddingForBackgroundPicture,
            left: paddingForBackgroundPicture,
            bottom: paddingForBackgroundPicture,
            right: paddingForBackgroundPicture
        )
        
        // NOTE: configuring profilePicture
        profilePictureImage.layer.masksToBounds = true
        profilePictureImage.layer.cornerRadius = CORNER_RADIUS_FOR_PROFILE_ICON
        
        // NOTE: configuring userNameLabel
        // NOTE: multiplierForRelativeUserNameFontSize was calculated manually (I realized font size 20 works fine for iPhone 8 Plus, ...
        // ... but it was too big for iPhone SE. By dividing it's font size by its frame height I've got the value and then adjusted it by testing.        l
        let multiplierForRelativeUserNameFontSize = CGFloat(0.046)
        let userNameFontSize = self.view.frame.height * multiplierForRelativeUserNameFontSize
        userNameLabel.font = UIFont.boldSystemFont(ofSize: userNameFontSize)
        
        // NOTE: configuring userDiscriptionLabel

        // NOTE: multiplierForRelativeFontDiscriptionFontSize was calculated manually (I realized font size 20 works fine for iPhone 8 Plus, ...
        // ... but it was too big for iPhone SE. By dividing it's font size by its frame height I've got the value and then adjusted it by testing.
        let multiplierForRelativeFontDiscriptionFontSize = CGFloat(0.03)
        let userDiscriptionFontSize = self.view.frame.height * multiplierForRelativeFontDiscriptionFontSize
        userDiscriptionLabel.font = UIFont.systemFont(ofSize: userDiscriptionFontSize, weight: .regular)
        
        
        // NOTE: configuring editProfileButton
        editProfileButton.layer.cornerRadius = Constants.ROUNDED_BUTTONS_DEFAULT_RADIUS
        editProfileButton.layer.borderWidth = Constants.BUTTON_BORDER_DEFAULT_WIDTH
        editProfileButton.titleLabel?.font = editProfileButton.titleLabel?.font.withSize(self.view.frame.height * multiplierForRelativeFontDiscriptionFontSize)
        
        // NOTE: configuring dismissButton

        dismissButton.layer.cornerRadius = Constants.ROUNDED_BUTTONS_DEFAULT_RADIUS
        dismissButton.layer.borderWidth = Constants.BUTTON_BORDER_DEFAULT_WIDTH
        dismissButton.titleLabel?.font = editProfileButton.titleLabel?.font.withSize(self.view.frame.height * multiplierForRelativeFontDiscriptionFontSize)
    }
    
    // MARK: UIImagePickerDelegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profilePictureImage.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
