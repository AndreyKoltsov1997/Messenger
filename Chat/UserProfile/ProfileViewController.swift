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
import CoreData

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Outlets
    
    
    @IBOutlet weak var userDiscriptionField: UITextView!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var profilePictureImage: UIImageView!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var sendViaGCDbutton: UIButton!
    @IBOutlet weak var sendViaOperationsButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properies
    
    private var profile = ProfileModel()
    public func getProfileModel() -> ProfileModel {
        return profile
    }
    

    
    
    // MARK: - Outlet methods
    
    @IBAction func onSaveViaOperationsClicked(_ sender: UIButton) {
        if (self.isUserDataUpdated()) {
            //self.saveViaOperations()
            self.profile.saveInfo()
        } else {
            print("Data couldn't be saved with operations.")
        }
    }
    
    @IBAction func onSaveViaGCDclicked(_ sender: UIButton) {
        if (isUserDataUpdated()) {
            self.saveViaGCD()
            setButtonInteraction(avaliable: false)
        }
    }
    
    @IBAction func dismissBtnClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func chooseImageButtonPressed(_ sender: UIButton) {
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
    
    
    // MARK: - ViewController methods
    
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
    
    private func showActionDoneAlert(message : String) {
        let alert  = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
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
    
    private func isUserDataUpdated() -> Bool {
        // TODO: check if image has been updated
        return ((self.userNameField.text != self.profile.name) || (self.userDiscriptionField.text != self.profile.discripton))
    }
    
    private func saveViaOperations() {
        activityIndicator.startAnimating()
        let operationManager = OperationDataManager()
        
        // TODO: Update profile saving
//        operationManager.saveProfile(sender: self, profile: self.profileInfo)
    }
    
    private func setButtonInteraction(avaliable isEnabled: Bool) {
        sendViaOperationsButton.isEnabled = isEnabled
        sendViaGCDbutton.isEnabled = isEnabled
        
        if (isEnabled) {
            sendViaGCDbutton.backgroundColor = .white
            sendViaOperationsButton.backgroundColor = .white
        } else {
            sendViaGCDbutton.backgroundColor = .lightGray
            sendViaOperationsButton.backgroundColor = .lightGray
        }
    }
    
    private func saveViaGCD() {
        let gcdDataManager = GCDDataManager()
        gcdDataManager.saveProfile(sender: self)
    }
    
    // MARK: - ProfileViewController lifecycle
    
    @IBAction func userNameDidChange(_ sender: Any) {
        checkIfSaveIsAvaliable()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Возникла проблема: мы не можем распечатать свойства frame'a. На этом этапе компилятор связывает файл интерфейс-билдера (.xib) c  ViewController'ом, чтобы затем загружать из него нужные нам View.
        // Соответственно, в данный момент, доступ к этим самым используемым View отсутствует.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadProfileData()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureLayout()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profile.delegate = self
        print("viewDidLoad")
        setUpLayoutSources()
        userDiscriptionField.delegate = self
    }
    
    
    private func loadProfileData() {
        activityIndicator.startAnimating()
        let gcdDataManager = GCDDataManager()
        if (!isUserDataUpdated()) {
            gcdDataManager.loadProfile(sender: self)
        } else {
            setButtonInteraction(avaliable: true)
        }
    }
    
    
    // when we recive a touch event, we can do something
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        userDiscriptionField.resignFirstResponder() // when we touch outside of the field, the keyboard will dismiss and handle here
    }
    
    // MARK: UI configuring methods
    
    private func setUpLayoutSources() {
        // NOTE: Here I'm setting up initial values for sources that could be changed in a runtime
        
        // userNameLabel sources
        userNameField.text = self.profile.name
        
        // userDiscriptionLabel sources
        userDiscriptionField.text = self.profile.discripton
        userDiscriptionField.textColor = Constants.USER_DISCRIPTION_TEXT_DEFAULT_COLOR
        userDiscriptionField.textAlignment = .justified
        
        // userProfilePicture sources
        profilePictureImage.image = UIImage(named: Constants.PROFILE_PICTURE_PLACEHOLDER_IMAGE_NAME)
        
        
        // sendViaGCDbutton sources
        sendViaGCDbutton.backgroundColor = .white
        sendViaGCDbutton.layer.borderColor = UIColor.black.cgColor
        sendViaGCDbutton.setTitleColor(UIColor.black, for: .normal)
        
        // sendViaOperationsButton sources
        sendViaOperationsButton.backgroundColor = .white
        sendViaOperationsButton.layer.borderColor = UIColor.black.cgColor
        sendViaOperationsButton.setTitleColor(UIColor.black, for: .normal)
        
    }
    
    private func configureLayout() {
        activityIndicator.hidesWhenStopped = true
        
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
        userNameField.font = UIFont.boldSystemFont(ofSize: userNameFontSize)
        
        // NOTE: configuring userDiscriptionLabel
        
        // NOTE: multiplierForRelativeFontDiscriptionFontSize was calculated manually (I realized font size 20 works fine for iPhone 8 Plus, ...
        // ... but it was too big for iPhone SE. By dividing it's font size by its frame height I've got the value and then adjusted it by testing.
        let multiplierForRelativeFontDiscriptionFontSize = CGFloat(0.03)
        let userDiscriptionFontSize = self.view.frame.height * multiplierForRelativeFontDiscriptionFontSize
        userDiscriptionField.font = UIFont.systemFont(ofSize: userDiscriptionFontSize, weight: .regular)
        
        
        // NOTE: configuring sendViaOperationsButton
        sendViaOperationsButton.layer.cornerRadius = Constants.ROUNDED_BUTTONS_DEFAULT_RADIUS
        sendViaOperationsButton.layer.borderWidth = Constants.BUTTON_BORDER_DEFAULT_WIDTH
        sendViaOperationsButton.titleLabel?.font = sendViaOperationsButton.titleLabel?.font.withSize(self.view.frame.height * multiplierForRelativeFontDiscriptionFontSize)
        
        // NOTE: configuring sendViaGCDbutton
        sendViaGCDbutton.layer.cornerRadius = Constants.ROUNDED_BUTTONS_DEFAULT_RADIUS
        sendViaGCDbutton.layer.borderWidth = Constants.BUTTON_BORDER_DEFAULT_WIDTH
        sendViaGCDbutton.titleLabel?.font = sendViaGCDbutton.titleLabel?.font.withSize(self.view.frame.height * multiplierForRelativeFontDiscriptionFontSize)
        
        // NOTE: DO NOT set default's avaliability to false, because when the page reloads, it re-configures the buttons.
        
        checkIfSaveIsAvaliable()
        // NOTE: configuring dismissButton
        
        dismissButton.layer.cornerRadius = Constants.ROUNDED_BUTTONS_DEFAULT_RADIUS
        dismissButton.layer.borderWidth = Constants.BUTTON_BORDER_DEFAULT_WIDTH
        dismissButton.titleLabel?.font = dismissButton.titleLabel?.font.withSize(self.view.frame.height * multiplierForRelativeFontDiscriptionFontSize)
    }
    
    
    private func checkIfSaveIsAvaliable() {
        isUserDataUpdated() ? setButtonInteraction(avaliable: true) : setButtonInteraction(avaliable: false)
    }
    
    // MARK: UIImagePickerDelegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profilePictureImage.image = selectedImage
            setButtonInteraction(avaliable: true)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextViewDelegate
extension ProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkIfSaveIsAvaliable()
    }
}

// MARK: - ProfileViewControllerDelegate
extension ProfileViewController: ProfileViewControllerDelegate {
    func updateName(_ name: String) {
        self.userNameField.text = name
    }
    
    func updateDiscription(_ discription: String) {
        self.userDiscriptionField.text = discription
    }
    
    func updateImage(_ image: Data) {
        self.profilePictureImage.image =  UIImage(data: image, scale: 1.0)
    }
    
    func finishLoading(_ model: ProfileModel) {
        self.userNameField.text = model.name
        self.userDiscriptionField.text = model.discripton
        if let image = model.image {
            self.profilePictureImage.image = UIImage(data: image, scale: 1.0)
        }
        self.showActionDoneAlert(message: "Profile info has been updated")
        self.activityIndicator.stopAnimating()
    }
    
    
}
