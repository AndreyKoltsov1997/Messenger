//
//  Constants.swift
//  Chat
//
//  Created by Andrey Koltsov on 23/09/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    // MARK: - Data related constants
    static let PROFILE_MODEL_TAG = "ProfileModel"
    
    // MARK: - UI constants
    
    static let PROFILE_PICTURE_PLACEHOLDER_IMAGE_NAME = "profile-vc-userpic-placeholder"
    static let PROFILE_VC_BLUE_COLOR = UIColor(red:0.25, green:0.47, blue:0.94, alpha:1.0)
    static let USER_DISCRIPTION_TEXT_DEFAULT_COLOR = UIColor(red:0.41, green:0.41, blue:0.41, alpha:1.0)
    static let ONLINE_CONTACT_BACKGROUND_DEFAULT_COLOR = UIColor.yellow.withAlphaComponent(0.05)
    static let OFFLINE_CONTACT_BACKGROUND_DEFAULT_COLOR = UIColor.white
    static let ROUNDED_BUTTONS_DEFAULT_RADIUS = CGFloat(12)
    static let BUTTON_BORDER_DEFAULT_WIDTH = CGFloat(1.5)
    
    static let SENT_MESSAGE_CELL_BACKGROUND_RESOUCE_NAME = "sent-message-background"
    static let RECIVED_MESSAGE_CELL_BACKGROUND_RESOUCE_NAME = "recived-message-background"
    
    static let ONLINE_USERS_SECTION_HEADER = "Online"
    static let OFFLINE_USERS_SECTION_HEADER = "History"
    
    static let EMPTY_MESSAGE_HISTORY_TAG = "No messages yet..."
    static let SAVE_BUTTON_TITLE = "Save"
    
    // NOTE: There's 2 formats of displaying date possible:
    // ... 1. Message has been recived within the current day => hours and minutes would be displayed; (@param MESSAGE_RECIVED_TODAY_DATE_FORMAT)
    // ... 2. Message was has been recived in other day => date and month would be dispalyed; (@Param MESSAGE_RECIVED_IN_THE_PAST_DATE_FORMAT)
    static let MESSAGE_RECIVED_TODAY_DATE_FORMAT = "HH:mm"
    static let MESSAGE_RECIVED_IN_THE_PAST_DATE_FORMAT = "dd MMM"
    static let DATE_FORMAT_DEFAULT_LOCALE = Locale(identifier: "RU_ru")
    
    // Options for profile picture choosing
    static let OPTION_TAKE_PHOTO_DEFAULT_TITLE = "Take photo"
    static let OPTION_OPEN_LIBRARY_DEFAULT_TITLE = "Choose from library"
    
    // Default user info
    static let DEFAULT_USERNAME = "Andrey Koltsov"
    static let DEFAULT_USER_DISCRIPTION = "Love iOS Development, burritos, math, himself and autumn."
    
    // UIAlertAction actions and titles
    static let OPTION_DISMISS_FEAULT_TITLE = "Dismiss"
    static let OPTION_OPEN_SETTINGS_DEFAULT_TITLE = "Open settings"
    static let ALERT_RESOURCE_NOT_AVALIABLE_DEFAULT_TITLE = "Resource not avaliable"
    
    // MARK: Application states
    static let APP_NON_RUNNING_STATE_TAG = "'Non running'"
    static let APP_INACTIVE_STATE_TAG = "'Inactive'"
    static let APP_ACTIVE_STATE_TAG = "'Active'"
    static let BACKGROUND_STATE_TAG = "'Background'"
    // NOTE: @SUSPENDED_STATE_TAG is some sort of Background execution. Out app is going to be suspended ...
    //     ... because no code is being executed.
    static let SUSPENDED_STATE_TAG = "'Suspended'"
    // NOTE: if app keeps being in some state, the STATE_REMAINS_ADDITIONAL_TAG is going to be added into the tag
    static let STATE_REMAINS_ADDITIONAL_TAG = "(transition not completed yet)"
    
    // MARK: Other constants
    static let CHOOSE_IMAGE_BTN_PRESSED_LOG = "Выбери изображение профиля"
    static let DOCUMENT_DIRECTORY_PATH = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

}
