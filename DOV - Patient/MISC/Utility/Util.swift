//
//  Util.swift
//  Bosala
//


import Foundation
import UIKit

//** MARK: Global Properties
var isNetworkAvailable = false

class Util : NSObject
{
    enum UserType: Int {
        case customer   = 2
        case salon      = 3
        case feelancer  = 4
    }

    
    //****************************************************
    // MARK: - Properties
    //****************************************************
    
    static var documentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.endIndex - 1]
        }()
    
    static var cacheDirectory: URL = {
        let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return urls[urls.endIndex - 1]
        }()
    
    //****************************************************
    // MARK: - Validations Methods
    //****************************************************
    
    class func isValidEmail(_ emailStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
         return emailTest.evaluate(with: emailStr)
    }
    
    class func getValidString(_ string: String?) -> (String) {
        if string == nil || string == "nil" || string!.isKind(of: NSNull.self) || string == "null" || string == "<null>" || string == "(null)" {
            
            return ""
        }
        return string!.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    class func convertStringToDictionary(_ text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }

    class func isValidString(_ string: String) -> (Bool) {
        let str = getValidString(string)
        return !str.isEmpty
    }
    
    class func removeInLineWhiteSpace(_ string: String) -> (String){
       return string.replacingOccurrences(of: " ", with: "")
    }
    
    class func encodedURL(_ string: String) -> (String){
        return string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
    class func getValidPrice(_ string: String?) -> (String) {
        
        if isValidString(string!){
            
            let price = Double(string!)
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            
            var ValidPrice = ""
            
            if let amount = price {
                ValidPrice = ("£\(numberFormatter.string(from: NSNumber(value: amount))!)")
            } else {
                ValidPrice = ""
            }
            
            return ValidPrice
        }
            
        else{
            return ""
        }
    }
    
    
    class func getCapitalizedString(_ string: String?) -> (String) {
        
        if isValidString(string!){
            
            return (string!.capitalizingFirstLetter()) }
            
        else{
            return ""
        }
    }

    class func isValidUrl (urlString: String?) -> Bool {
        let urlRegEx = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: urlString)
    }

    
    //****************************************************
    // MARK: - Image
    //****************************************************

    class func base64StringFromImage(_ image: UIImage) -> (String) {
        let imageData = UIImagePNGRepresentation(image)
        let strBase64:String = imageData!.base64EncodedString(options: .lineLength64Characters)
        
        return strBase64
    }
    
    class func imgCompress(image:UIImage) -> UIImage {
        var imageDataOne: NSData? = UIImageJPEGRepresentation(image, 1.0) as NSData?
        
        var imageSize = (imageDataOne?.length)! / 1024
        print(imageSize)
        
        var img = UIImage()
        
        if imageSize > 9000 {
            imageDataOne = UIImageJPEGRepresentation(image, 0.02) as NSData?
            imageSize = (imageDataOne?.length)! / 1024
        } else if imageSize > 6000 {
            imageDataOne = UIImageJPEGRepresentation(image, 0.03) as NSData?
            imageSize = (imageDataOne?.length)! / 1024
        }
        else if imageSize > 5000 {
            imageDataOne = UIImageJPEGRepresentation(image, 0.05) as NSData?
            imageSize = (imageDataOne?.length)! / 1024
        }
        else if imageSize > 4000 {
            imageDataOne = UIImageJPEGRepresentation(image, 0.07) as NSData?
            imageSize = (imageDataOne?.length)! / 1024
        }
        else if imageSize > 3000 {
            imageDataOne = UIImageJPEGRepresentation(image, 0.1) as NSData?
            imageSize = (imageDataOne?.length)! / 1024
        }
        else if imageSize > 2000 {
            imageDataOne = UIImageJPEGRepresentation(image, 0.15) as NSData?
            imageSize = (imageDataOne?.length)! / 1024
        }
        else if imageSize > 1000 {
            imageDataOne = UIImageJPEGRepresentation(image, 0.3) as NSData?
            imageSize = (imageDataOne?.length)! / 1024
        }
        else if imageSize > 500 {
            imageDataOne = UIImageJPEGRepresentation(image, 0.4) as NSData?
            imageSize = (imageDataOne?.length)! / 1024
        }
        else if imageSize > 400 {
            imageDataOne = UIImageJPEGRepresentation(image, 0.5) as NSData?
            imageSize = (imageDataOne?.length)! / 1024
        }
        
        img = UIImage(data: imageDataOne! as Data)!
        
        return img
    }
    
    
    //****************************************************
    // MARK: - Alert Methods
    //****************************************************
    
    class func showNetWorkAlert() {
        showAlertWithMessage("Please check your connection and try again.", title:"No Network Connection")
    }
    
    class func showAlertWithMessage(_ message: String, title: String)
    {
        //** If any Alert view is alrady presented then do not show another alert
        if UIApplication.topViewController() != nil {
            if (UIApplication.topViewController()!.isKind(of: UIAlertController.self)) {
                return
            }
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        appDelegate.window?.rootViewController!.present(alert, animated: true, completion: nil)
    }
    
    
    //****************************************************
    // MARK: - Date Util Methods
    //****************************************************

    class func getDateFromatFromDateStringForNotification(_ dateString: String) -> String {
        return kAPI_ServerNotificationDateFormat
    }

    class func getDateFromatFromDateString(_ dateString: String) -> String {
       
        if (dateString.characters.count == 19)  {
            return "yyyy-MM-dd'T'HH:mm:ss"
        }
        if (dateString.characters.count == 22)  {
            return "yyyy-MM-dd'T'HH:mm:ss.SS"
        } else {
            return kAPI_ServerDateFormat
        }
    }
    
    class func getCurrentDateInUTCFormate() -> Date {

        let currentDate             = Date()
        let dateFormatter           = DateFormatter()
        
        dateFormatter.locale        = Locale(identifier: "en_US_POSIX")
        
        dateFormatter.timeZone      = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat    = kAPI_AppDateFormat
        let dateString              = dateFormatter.string(from: currentDate)
        //log.debug("currentDate:\(currentDate),\n UTC date:\(dateFormatter.dateFromString(dateString)!)")
        return dateFormatter.date(from: dateString)!
    }
    
    class func getUTCDateFromDateStringForNotification(_ dateString: String) -> Date? {
        return getUTCDateFromDateString(dateString, dateFormat: getDateFromatFromDateStringForNotification(dateString))
    }

    class func getUTCDateFromDateString(_ dateString: String) -> Date? {
        return getUTCDateFromDateString(dateString, dateFormat: getDateFromatFromDateString(dateString))
    }
    
    class func getUTCDateFromDateString(_ dateString: String, dateFormat: String) -> Date? {
    
        if !self.isValidString(dateString) {
           return nil
        }
        
        let dateFormatter        = DateFormatter()
        dateFormatter.locale     = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone   = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter.date(from: dateString)!
    }
    
    class func relativeDateStringForDate(_ date:  Date?) -> String {
        
        if date == nil {
            return ""
        }
        
        let strTime = getStringFromDate(date!, sourceFormat: "yyyy-MM-dd HH:mm:ss ZZZ", destinationFormat: "dd MMM")
        
        let gregorian = Calendar.current
        let units = NSCalendar.Unit(rawValue: UInt.max)
        
        let dateToday = getCurrentDateInUTCFormate()
        
        let components = (gregorian as NSCalendar).components(units, from: date!, to: dateToday, options: [])
        
        if components.year! > 0 {
            
            if components.year == 1 {
//                return "\(components.year!) year ago"
                return "\(strTime)"
            } else {
//                return "\(components.year!) years ago"
                return "\(strTime)"
            }
        }
        else if components.month! > 0 {
            
            if components.month == 1 {
//                return "\(components.month!) month ago"
                return "\(strTime)"

            } else {
//                return "\(components.month!) months ago"
                return "\(strTime)"
            }
        }
        else if components.weekOfYear! > 0 {
            
            if components.weekOfYear == 1 {
//                return "\(components.weekOfYear!) week ago"
                return "\(strTime)"
            } else {
                //return "\(components.weekOfYear!) weeks ago"
                return "\(strTime)"
            }
        }
        else if components.day! > 0 {
            
            if components.day == 1 {
                //return "\(components.day!) day ago"
                return "\(strTime)"
            } else {
                //return "\(components.day!) days ago"
                return "\(strTime)"
            }
        }
        else if components.hour! > 0 {

            if components.hour == 1 {
                return "\(components.hour!) hour ago"
            } else {
                return "\(components.hour!) hours ago"
            }
        }
        else if components.minute! > 0 {
            
            if components.minute == 1 {
                return "\(components.minute!) min ago"
            } else {
                return "\(components.minute!) mins ago"
            }
        }
        else if components.second! > 0  {
            if components.second == 1 {
               // return "\(components.second!) second  ago"
            } else {
               // return "\(components.second!) seconds  ago"
            }
            return "just now"
            
        }
        return ""
    }
    
    //*> Get week day name
    class func getDayOfWeekString(_ today:String) ->String? {
        
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let todayDate = formatter.date(from: today) {
            
            let myCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
            let myComponents = (myCalendar as NSCalendar).components(.weekday, from: todayDate)
            let weekDay = myComponents.weekday
            switch weekDay {
            case 1?:
                return "Sunday"
            case 2?:
                return "Monday"
            case 3?:
                return "Tuesday"
            case 4?:
                return "Wednesday"
            case 5?:
                return "Thursday"
            case 6?:
                return "Friday"
            case 7?:
                return "Saturday"
            default:
                print("Error fetching days")
                return "Day"
            }
        }
        else {
            return nil
        }
    }
    
    class func getDateStringInDesiredFormat(_ dateString: String, sourceFormat: String, destinationFormat: String) -> String {
                
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = sourceFormat
        let date = dateFormatter.date(from: dateString)
        
        dateFormatter.dateFormat = destinationFormat
        let desiredString = dateFormatter.string(from: date!)
        
        return desiredString
    }
    
    class func getStringFromDate(_ date: Date, sourceFormat: String, destinationFormat: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = sourceFormat
        
        dateFormatter.dateFormat = destinationFormat
        let desiredString = dateFormatter.string(from: date)
        
        return desiredString
    }
    
    class func getDateFromString(_ strDate: String, sourceFormat: String, destinationFormat: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = sourceFormat
        let date = dateFormatter.date(from: Util.getValidString(strDate))
                
        return date!
    }
    
    class func isGreaterThanDate(_ dateToCompare: Date) -> Bool {
        
        let strDate = Util.getStringFromDate(Date(), sourceFormat: "yyyy-MM-dd hh:mm:ss a ZZZ", destinationFormat: "yyyy/MM/dd")
        let date = Util.getDateFromString(strDate, sourceFormat: "yyyy/MM/dd", destinationFormat: "yyyy/MM/dd")
        
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if date.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    class func isLessThanDate(_ dateToCompare: Date) -> Bool {
        
        let strDate = Util.getStringFromDate(Date(), sourceFormat: "yyyy-MM-dd hh:mm:ss a ZZZ", destinationFormat: "yyyy/MM/dd")
        let date = Util.getDateFromString(strDate, sourceFormat: "yyyy/MM/dd", destinationFormat: "yyyy/MM/dd")

        //Declare Variables
        var isLess = false
        
        //Compare Values
        if date.compare(dateToCompare) == ComparisonResult.orderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    class func equalToDate(_ dateToCompare: Date) -> Bool {
        
        let strDate = Util.getStringFromDate(Date(), sourceFormat: "yyyy-MM-dd hh:mm:ss a ZZZ", destinationFormat: "yyyy/MM/dd")
        let date = Util.getDateFromString(strDate, sourceFormat: "yyyy/MM/dd", destinationFormat: "yyyy/MM/dd")

        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if date.compare(dateToCompare) == ComparisonResult.orderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    class func dateCompraisionStatus(_ compareType: String, date: Date) -> Bool {
        
        var isCompareStatus = false
    
        if compareType == "GreaterThan" {
            isCompareStatus = self.isGreaterThanDate(date)
        }
        else if compareType == "LessThan" {
            isCompareStatus = self.isLessThanDate(date)
        }
        else if compareType == "Equal"{
            isCompareStatus = self.equalToDate(date)
        }
        
        return isCompareStatus
    }
    
    //****************************************************
    // MARK: - UILable Line Spacing
    //****************************************************
    
    class func lableLineSpacing(text: String, fontName: String, lblName: UILabel) {
        let attributeLandlordInfo = [NSAttributedStringKey.font: UIFont(name: fontName, size: lblName.font.pointSize)!]
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.0
        
        var attrString = NSMutableAttributedString()
        
        attrString = NSMutableAttributedString(string: text)
        attrString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        attrString.addAttributes (attributeLandlordInfo, range: NSMakeRange(0, attrString.length))
        
        lblName.attributedText = attrString
    }
    
    //****************************************************
    // MARK: - UILable Line Spacing
    //****************************************************
    
}


/**
 * Find and retun top or visible view controller
 */
extension UIApplication {
    
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
}
//****************************************************
// MARK: - Global Methods
//****************************************************

func noop() {
    //** Global no operation function, useful for doing nothing in a switch option, and examples
}

