//
//  Constant.swift
//  Bosala
//


import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate


//************************** Constants for Device **************************//
//************************** Screen size and Device type macros **************************//

struct ScreenSize {
    static let width                    = UIScreen.main.bounds.size.width
    static let height                   = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.width, ScreenSize.height)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.width, ScreenSize.height)
}

struct Device {
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}

struct iOSVersion {
    static let SYS_VERSION_FLOAT = (UIDevice.current.systemVersion as NSString).floatValue
    static let iOS7 = (iOSVersion.SYS_VERSION_FLOAT < 8.0 && iOSVersion.SYS_VERSION_FLOAT >= 7.0)
    static let iOS8 = (iOSVersion.SYS_VERSION_FLOAT >= 8.0 && iOSVersion.SYS_VERSION_FLOAT < 9.0)
    static let iOS9 = (iOSVersion.SYS_VERSION_FLOAT >= 9.0 && iOSVersion.SYS_VERSION_FLOAT < 10.0)
}


//************************** Constants for Segue **************************//

//************************** Constants for color **************************// 

let colorLightGray      = UIColor(red: 221/255, green: 229/255, blue: 235/255, alpha: 1.0)
let colorMidGray        = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1.0)
let colorDarkGray       = UIColor(red: 51/255,  green: 51/255,  blue: 51/255,  alpha: 1.0)
let colorBorderBG       = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1.0)
let colorBlue           = UIColor(red: 74/255,  green: 144/255,  blue: 226/255, alpha: 1.0)
let colorGreen          = UIColor(red: 88/255, green: 179/255, blue: 21/255,  alpha: 1.0)
let colorViewBG         = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
let colorOrange         = UIColor(red: 243/255, green: 128/255, blue: 22/255,  alpha: 1.0)
let colorRedGray        = UIColor(red: 246/255, green: 225/255, blue: 216/255, alpha: 1.0)



let colorClear          = UIColor.clear
let colorWhite          = UIColor.white
let colorBlack          = UIColor.black



//************************** Constants for Font **************************//

let AppFontLight        = "billcorporatenarrow-light"
let AppFontMedium       = "billcorporatenarrow-medium"
let AppFontBook         = "billcorporatenarrow-book"
let AppFontSemiBold     = "billcorporatenarrow-semibold"


//************************** Constants for User default **************************//

let Key_UD_IsUserLoggedIn           = "isUserLoggedIn"
let Key_UD_IsLogoutAPIPending       = "isLogoutAPIPending"


//************************** Constants for Alert messages **************************//

let msgSorry                         = "Sorry something went wrong."
let msgTimeOut                       = "Request timed out."
let msgCheckConnection               = "Please check your connection and try again."
let msgConnectionLost                = "Network connection lost."
let Key_Alert                        = "Doctor on Visit"


//************************** Constants for APNS **************************//
let Key_APNS                         = "aps"
let Key_APNSAlert                    = "alert"
let Key_APNSBadge                    = "badge"
let Key_APNSAction                   = "action"
let Key_APNSMetadata                 = "Metadata"
let Key_APNSType                     = "type"



//************************** Constants for Post Notification Key **************************//

//** This notification is posted when First time network become available
let notificationNetworkBecomeAvailableFirstTime     = "com.Poshrite.NetworkBecomeAvailableFirstTime"
let notificationHideContainerView                   = "com.Poshrite.HideContainerView"
let notificationMyProfileContainerView              = "com.Poshrite.MyProfileContainerView"

let kAPI_Key_XRequestedWith     = "X-Requested-With"
let kAPI_XMLHttpRequest         = "XMLHttpRequest"


//************************** Other Constants **************************//

//************************** The order of pragma marks methods in every class **************************//


// MARK: - Properties
// MARK: - Initialization
// MARK: - Lifecycle Methods
// MARK: - Notification Methods (Observer Listener methods)
// MARK: - Action Methods
// MARK: - Private Methods
// MARK: - Public Methods
// MARK: - API Methods
// MARK: - Protocol conformance
// MARK: - UITextFieldDelegate
// MARK: - UITextViewDelegate
// MARK: - UITableViewDataSource
// MARK: - UITableViewDelegate
