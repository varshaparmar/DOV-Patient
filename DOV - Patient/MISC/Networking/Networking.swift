//
//  Networking.swift
//  Bosala


import UIKit
import AVFoundation
import MBProgressHUD
import Kingfisher
import SwiftyJSON
import Alamofire

struct Networking {
    
    enum Router: URLRequestConvertible {
        
        // MARK: - Register
        case signUp([String: AnyObject])
        // MARK: - Singin
        case Signin([String: AnyObject])
    
        case servicesList
        
        
        var method: HTTPMethod {
            
            switch self {
            //** Post Api
            case .signUp, .Signin:
                return .post
                
            //** GET Api
            case .servicesList:
                return .get
                
            //** PUT Api
         //   case .editStaff:
               // return .put
                
            //** DELETE Api
           // case  .deleteNotification:
           //     return .delete
            }
        }
        
        //** Intialize api path in |path|
        //** Intialize api path in |path|
        var path: String {
            
            switch self {
                
            case .Signin:
                return "signup.php"
            //** Login
            case .signUp:
                return "login.php"
            case .servicesList:
                return "uiiuiyu"
            }
        }
        
        
        //** MARK: URLRequestConvertible
        func asURLRequest() throws -> URLRequest {
            
            var strUrl = kAPI_BaseURL + path
            strUrl = Util.encodedURL(strUrl)
            
            let URL = Foundation.URL(string:strUrl)!
            var urlRequest = URLRequest(url: URL as URL)
            urlRequest.httpMethod = method.rawValue
        
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content")
            urlRequest.setValue("keep-alive", forHTTPHeaderField: "Connection")
            
            switch self {
                
            case .signUp(let parameters):
                urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
                
            case .Signin(let parameters):
                urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
                
          
                
            default:
                break
            }
            return urlRequest
        }
    }
    
    static func performApiCall(_ requestName: Networking.Router, callerObj: AnyObject, showHud: Bool, completionHandler:@escaping ( (DataResponse<Any>) -> Void)) {
        
        //** Show Hud
        if showHud {
            var hudTitle : String
            hudTitle = "Loading..."
            
            appDelegate.showHUD(hudTitle, onView: (callerObj as! UIViewController).view)
        }
        
        let request = Alamofire.request(requestName).validate().responseJSON { response in
            
            log.debug("Parsed JSON:=========== \(String(describing: response.result.value))")
            
            //** Hide Hud
            if showHud {
                appDelegate.hideHUD((callerObj as! UIViewController).view)
            }
            
            switch response.result {
                
            case .success:
                log.debug("Get Success response from server with status code:\(String(describing: response.response?.statusCode)), for api request:\(String(describing: response.request?.url))")
                
            //** Handle failure response
            case .failure:
                log.debug("Get response from server for api request:\(String(describing: response.request?.url)) in failure section")
                
                Networking.handleApiResponse(response)
            }
            completionHandler(response)
        }
        log.info("Request Added to Queue for exection. Request URL:\(request)")   // original URL request
    }
    
    static func handleApiResponse(_ response: DataResponse<Any>) {
        
        let errorCode = response.response?.statusCode
        if errorCode == nil {
            //errorCode = response.result.error?.code
        }
        log.debug("Get response from server with status code:\(String(describing: errorCode)), for api request:\(String(describing: response.request?.url))")
        
        let dataString = String(data: response.data!, encoding: String.Encoding.utf8)
        
        let result = Util.convertStringToDictionary(dataString!)
        
        var errorDescription = ""
        
        if let errorDes = result?["message"] {
            errorDescription = errorDes as! String
        }
        
        if errorDescription == "" && dataString != nil {
            errorDescription = dataString!
        }
        
        log.info("Api response error:\(errorDescription)")
        
        var strError = errorDescription as String
        
        if strError.characters.count > 150 {
            strError = ""
        }
        
        if let contentType = response.response?.allHeaderFields["Content-Type"] as? String {
            if contentType == "text/html" {
                strError = "Server error"
            }
        }
        
        if let httpStatusCode = errorCode {
            switch httpStatusCode {
                
            case 401:
                log.debug("Session Expired")
                let uiAlert = UIAlertController(title: "Session expire", message: "Your last session has expired, please log in again" , preferredStyle:UIAlertControllerStyle.alert)
                appDelegate.window?.rootViewController!.present(uiAlert, animated: true, completion: nil)
                
                uiAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    //LoggedInUser.sharedUser.logout()
                    //appDelegate.showLoginScreen()
                }))
                
            //** Almofire libarary error code
            case -999:
                log.debug("\(String(describing: response.request?.url)) request was cancelled")
            case -1001:
                Util.showAlertWithMessage(msgTimeOut, title:"Error")
            case -1003, -1004, -1009:
                Util.showAlertWithMessage(msgCheckConnection, title:"Error")
            case -1005:
                Util.showAlertWithMessage(msgConnectionLost, title:"Error")
            case -1200, -1201, -1202, -1203, -1204, -1205, -1206:
                Util.showAlertWithMessage("The secure connection failed for an unknown reason.", title:"SSL Server Error")
                
            default:
                if Util.isValidString(strError) {
                    Util.showAlertWithMessage(strError, title:"Error")
                }
                else {
                    Util.showAlertWithMessage(msgSorry, title:"Error")
                }
            }
        }
        else {
            Util.showAlertWithMessage(msgSorry, title:"Error")
        }
    }
    
    
    /**
     *   This method upload image(s) as a multipart data format
     * - parameter requestName: A perticular request that define in Router Enum. It may contain request parameter or may not be.
     * - parameter imageArray: Array of images it must not be nil
     * - parameter callerObj: Object of class which make api call
     * - parameter showHud: A boolean value that represent is need to display hud for the api or not
     * - parameter completionHandler: A closure that provide callback to caller after getting response
     */
    static func uploadImages(_ requestName: Networking.Router, imageArray: [UIImage], callerObj: AnyObject, showHud: Bool, completionHandler: ((SessionManager.MultipartFormDataEncodingResult) -> Void)?) {
        
        if imageArray.count < 1 {
            return
        }
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            var index = 1
            for image in imageArray {
                let imageData: Data = (UIImageJPEGRepresentation(image, 1.0) as Data?)!
                
                multipartFormData.append(imageData, withName: "home-\(index)", fileName: "home-\(index)", mimeType: "image/jpeg")
                
                index += 1
            }
            }, with: requestName, encodingCompletion: { result in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.responseJSON { response in
                        log.debug("Image(s) Uploaded successfully:\(response)")
                        Networking.handleApiResponse(response)
                    }
                case .failure(let encodingError):
                    log.debug("encodingError:\(encodingError)")
                }
                completionHandler!(result)
        })
        
    }
    
    
    /**
     *   This method upload image(s) as a multipart data format
     * - parameter requestName: A perticular request that define in Router Enum. It may contain request parameter or may not be.
     * - parameter imageArray: Array of images it must not be nil
     * - parameter callerObj: Object of class which make api call
     * - parameter showHud: A boolean value that represent is need to display hud for the api or not
     * - parameter completionHandler: A closure that provide callback to caller after getting response
     */
    static func uploadVideos(_ requestName: Networking.Router, videoArray: [URL], callerObj: AnyObject, showHud: Bool, completionHandler: ((SessionManager.MultipartFormDataEncodingResult) -> Void)?) {
        
        if videoArray.count < 1 {
            return
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            var index = 1
            for assetsUrl in videoArray {
                
                let videoData = NSData(contentsOf: assetsUrl)
                
                if videoData != nil {
                    //multipartFormData.append(videoData!, withName: "videos", fileName: "videos.mov", mimeType: "video/mov")
                    
                    multipartFormData.append(assetsUrl, withName: "videos", fileName: "videos.mov", mimeType: "video/mov")
                }
                index += 1
            }
            }, with: requestName, encodingCompletion: { (encodingResult) in
                switch encodingResult {
                case .success(let upload, _, _):
                    
                    upload.responseJSON { response in
                        log.debug("Image(s) Uploaded successfully:\(response)")
                        Networking.handleApiResponse(response)
                    }
                case .failure(let encodingError):
                    log.debug("encodingError:\(encodingError)")
                }
                completionHandler!(encodingResult)
        })
    }
    
    
    /**
     *   This method upload image(s) as a multipart data format
     * - parameter requestName: A perticular request that define in Router Enum. It may contain request parameter or may not be.
     * - parameter imageArray: Array of images it must not be nil
     * - parameter callerObj: Object of class which make api call
     * - parameter showHud: A boolean value that represent is need to display hud for the api or not
     * - parameter completionHandler: A closure that provide callback to caller after getting response
     */
    static func uploadImagesWithParams(_ requestName: Networking.Router, imageArray: [UIImage], strImageKey : String, dictParams: [String: AnyObject], callerObj: AnyObject, showHud: Bool, completionHandler: ((SessionManager.MultipartFormDataEncodingResult) -> Void)?) {
        
        if imageArray.count < 1 {
            return
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            var index = 1
            for image in imageArray {
                let imageData: NSData? = UIImageJPEGRepresentation(image, 1.0) as NSData?
                if imageData != nil {
                    
                    multipartFormData.append(imageData! as Data, withName: strImageKey, fileName: "image.jpeg", mimeType: "image/jpeg")
                    
                    for (key, value) in dictParams {
                        let data = "\(value)".data(using: .utf8)
                        multipartFormData.append(data! as Data, withName: key)
                    }
                }
                index += 1
            }
            }, with: requestName,encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    
                    upload.responseJSON { response in
                        log.debug("Image(s) Uploaded successfully:\(response)")
                        //Networking.handleApiResponse(response)
                    }
                case .failure(let encodingError):
                    log.debug("encodingError:\(encodingError)")
                    // Networking.handleApiResponse(response)
                    
                    Util.showAlertWithMessage(msgSorry, title:"Error")
                }
                completionHandler!(encodingResult)
            }
        )
    }
    
    static func uploadBothImagesWithParams(_ requestName: Networking.Router, imageArray: Dictionary<String, Any>, dictParams: [String: AnyObject], callerObj: AnyObject, showHud: Bool, completionHandler: ((SessionManager.MultipartFormDataEncodingResult) -> Void)?) {
        
        if imageArray.count < 1 {
            return
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            var index = 1
            
            for  (key, value) in imageArray
            {
                multipartFormData.append(UIImageJPEGRepresentation(value as! UIImage, 0.9)!, withName: key, fileName: "swift_file.jpeg", mimeType: "image/jpeg")
            }
            
            for (key, value) in dictParams {
                let data = "\(value)".data(using: .utf8)
                multipartFormData.append(data! as Data, withName: key)
            }
            
//            for image in imageArray {
//                let imageData: NSData? = UIImageJPEGRepresentation(image, 1.0) as NSData?
//                if imageData != nil {
//                    
//                    multipartFormData.append(imageData! as Data, withName: strImageKey, fileName: "image.jpeg", mimeType: "image/jpeg")
//                    
//                    for (key, value) in dictParams {
//                        let data = "\(value)".data(using: .utf8)
//                        multipartFormData.append(data! as Data, withName: key)
//                    }
//                }
//                index += 1
//            }
        }, with: requestName,encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    log.debug("Image(s) Uploaded successfully:\(response)")
                    //Networking.handleApiResponse(response)
                }
            case .failure(let encodingError):
                log.debug("encodingError:\(encodingError)")
                // Networking.handleApiResponse(response)
                
                Util.showAlertWithMessage(msgSorry, title:"Error")
            }
            completionHandler!(encodingResult)
        }
        )
    }

    
    
    static func uploadTwoTypeImagesWithParams(_ requestName: Networking.Router, imageArrayOne: [UIImage], imageArrayTwo: [UIImage], strImageKeyOne : String, strImageKeyTwo : String, dictParams: [String: AnyObject], callerObj: AnyObject, showHud: Bool, completionHandler: ((SessionManager.MultipartFormDataEncodingResult) -> Void)?) {
        
        var isArrayOneIsGreater = true
        
        if imageArrayOne.count < imageArrayTwo.count {
            isArrayOneIsGreater = false
        }
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            var index = 1
            var indexOne = 1
            
            var isParamsPosted = false
            
            if isArrayOneIsGreater == true {
                
                if imageArrayOne.count == 0 {
                    for (key, value) in dictParams {
                        let data = "\(value)".data(using: .utf8)
                        multipartFormData.append(data! as Data, withName: key)
                    }
                } else {
                    for imageOne in imageArrayOne {
                        
                        var imageDataOne: NSData? = UIImageJPEGRepresentation(imageOne, 1.0) as NSData?
                        
                        var imageSize = (imageDataOne?.length)! / 1024
                        print(imageSize)
                        
                        if imageSize > 9000 {
                            imageDataOne = UIImageJPEGRepresentation(imageOne, 0.02) as NSData?
                            imageSize = (imageDataOne?.length)! / 1024
                        }
                        else if imageSize > 6000 {
                            imageDataOne = UIImageJPEGRepresentation(imageOne, 0.03) as NSData?
                            imageSize = (imageDataOne?.length)! / 1024
                        }
                        else if imageSize > 5000 {
                            imageDataOne = UIImageJPEGRepresentation(imageOne, 0.05) as NSData?
                            imageSize = (imageDataOne?.length)! / 1024
                        }
                        else if imageSize > 4000 {
                            imageDataOne = UIImageJPEGRepresentation(imageOne, 0.07) as NSData?
                            imageSize = (imageDataOne?.length)! / 1024
                        }
                        else if imageSize > 3000 {
                            imageDataOne = UIImageJPEGRepresentation(imageOne, 0.1) as NSData?
                            imageSize = (imageDataOne?.length)! / 1024
                        }
                        else if imageSize > 2000 {
                            imageDataOne = UIImageJPEGRepresentation(imageOne, 0.15) as NSData?
                            imageSize = (imageDataOne?.length)! / 1024
                        }
                        else if imageSize > 1000 {
                            imageDataOne = UIImageJPEGRepresentation(imageOne, 0.3) as NSData?
                            imageSize = (imageDataOne?.length)! / 1024
                        }
                        else if imageSize > 500 {
                            imageDataOne = UIImageJPEGRepresentation(imageOne, 0.4) as NSData?
                            imageSize = (imageDataOne?.length)! / 1024
                        }
                        else if imageSize > 400 {
                            imageDataOne = UIImageJPEGRepresentation(imageOne, 0.5) as NSData?
                            imageSize = (imageDataOne?.length)! / 1024
                        }
                        
                        print(imageSize)
                        
                        var imageTwo = UIImage()
                        var imageDataTwo = NSData()
                        
                        var isArrayTwoAvailable = false
                        
                        if index <= imageArrayTwo.count {
                            imageTwo = imageArrayTwo[index - 1]
                            isArrayTwoAvailable = true
                            imageDataTwo = UIImageJPEGRepresentation(imageTwo, 1.0)! as NSData
                            
                            var imageSize = (imageDataTwo.length) / 1024
                            print(imageSize)
                            
                            if imageSize > 9000 {
                                imageDataTwo = (UIImageJPEGRepresentation(imageTwo, 0.02) as NSData?)!
                                imageSize = (imageDataTwo.length) / 1024
                            }
                            else if imageSize > 6000 {
                                imageDataTwo = (UIImageJPEGRepresentation(imageTwo, 0.03) as NSData?)!
                                imageSize = (imageDataTwo.length) / 1024
                            }
                            else if imageSize > 5000 {
                                imageDataTwo = (UIImageJPEGRepresentation(imageTwo, 0.05) as NSData?)!
                                imageSize = (imageDataTwo.length) / 1024
                            }
                            else if imageSize > 4000 {
                                imageDataTwo = (UIImageJPEGRepresentation(imageTwo, 0.07) as NSData?)!
                                imageSize = (imageDataTwo.length) / 1024
                            }
                            else if imageSize > 3000 {
                                imageDataTwo = (UIImageJPEGRepresentation(imageTwo, 0.1) as NSData?)!
                                imageSize = (imageDataTwo.length) / 1024
                            }
                            else if imageSize > 2000 {
                                imageDataTwo = (UIImageJPEGRepresentation(imageTwo, 0.15) as NSData?)!
                                imageSize = (imageDataTwo.length) / 1024
                            }
                            else if imageSize > 1000 {
                                imageDataTwo = (UIImageJPEGRepresentation(imageTwo, 0.3) as NSData?)!
                                imageSize = (imageDataTwo.length) / 1024
                            }
                            else if imageSize > 500 {
                                imageDataTwo = (UIImageJPEGRepresentation(imageTwo, 0.4) as NSData?)!
                                imageSize = (imageDataTwo.length) / 1024
                            }
                            else if imageSize > 400 {
                                imageDataTwo = (UIImageJPEGRepresentation(imageTwo, 0.5) as NSData?)!
                                imageSize = (imageDataTwo.length) / 1024
                            }
                            
                            print(imageSize)
                        }
                        
                        if imageDataOne != nil {
                            
                            //multipartFormData.appendBodyPart(data: imageDataOne!, name: strImageKeyOne, fileName: "image.jpeg", mimeType: "image/jpeg")
                            multipartFormData.append(imageDataOne! as Data, withName: strImageKeyOne, fileName: "image_\(index - 1).jpeg", mimeType: "image/jpeg")
                            
                            //appDelegate.arrOderHomeImages["image_\(index - 1).jpeg"] = "\(index - 1)"
                            
                            //print(appDelegate.arrOderHomeImages)
                            
                            if isArrayTwoAvailable == true {
                                //multipartFormData.appendBodyPart(data: imageDataTwo, name: strImageKeyTwo, fileName: "image.jpeg", mimeType: "image/jpeg")
                                multipartFormData.append(imageDataTwo as Data, withName: strImageKeyTwo, fileName: "image_\(index - 1).jpeg", mimeType: "image/jpeg")
                                
                                //appDelegate.arrOrderFloorplanImages["image_\(index - 1).jpeg"] = "\(index - 1)"
                                //appDelegate.arrOrderFloorplanImages.add(valueOne)
                                //print(appDelegate.arrOrderFloorplanImages)
                            }
                            
                            if isParamsPosted == false {
                                
                                for (key, value) in dictParams {
                                    let data = "\(value)".data(using: .utf8)
                                    multipartFormData.append(data! as Data, withName: key)
                                }
                                
                                isParamsPosted = true
                            }
                        }
                        index += 1
                    }
                }
            }
            else {
                
                if imageArrayTwo.count == 0 {
                    for (key, value) in dictParams {
                        
                        let data = "\(value)".data(using: .utf8)
                        multipartFormData.append(data! as Data, withName: key)
                    }
                } else {
                    for imageTwo in imageArrayTwo {
                        
                        var imageDataTwo: NSData? = UIImageJPEGRepresentation(imageTwo, 1.0) as NSData?
                        
                        var imageSize = (imageDataTwo?.length)! / 1024
                        print(imageSize)
                        
                        if imageSize > 9000 {
                            imageDataTwo = UIImageJPEGRepresentation(imageTwo, 0.02) as NSData?
                            imageSize = (imageDataTwo?.length)! / 1024
                        }
                        else if imageSize > 6000 {
                            imageDataTwo = UIImageJPEGRepresentation(imageTwo, 0.03) as NSData?
                            imageSize = (imageDataTwo?.length)! / 1024
                        }
                        else if imageSize > 5000 {
                            imageDataTwo = UIImageJPEGRepresentation(imageTwo, 0.05) as NSData?
                            imageSize = (imageDataTwo?.length)! / 1024
                        }
                        else if imageSize > 4000 {
                            imageDataTwo = UIImageJPEGRepresentation(imageTwo, 0.07) as NSData?
                            imageSize = (imageDataTwo?.length)! / 1024
                        }
                        else if imageSize > 3000 {
                            imageDataTwo = UIImageJPEGRepresentation(imageTwo, 0.1) as NSData?
                            imageSize = (imageDataTwo?.length)! / 1024
                        }
                        else if imageSize > 2000 {
                            imageDataTwo = UIImageJPEGRepresentation(imageTwo, 0.15) as NSData?
                            imageSize = (imageDataTwo?.length)! / 1024
                        }
                        else if imageSize > 1000 {
                            imageDataTwo = UIImageJPEGRepresentation(imageTwo, 0.3) as NSData?
                            imageSize = (imageDataTwo?.length)! / 1024
                        }
                        else if imageSize > 500 {
                            imageDataTwo = UIImageJPEGRepresentation(imageTwo, 0.4) as NSData?
                            imageSize = (imageDataTwo?.length)! / 1024
                        }
                        else if imageSize > 400 {
                            imageDataTwo = UIImageJPEGRepresentation(imageTwo, 0.5) as NSData?
                            imageSize = (imageDataTwo?.length)! / 1024
                        }
                        
                        print(imageSize)
                        
                        var imageOne = UIImage()
                        var imageDataOne = NSData()
                        
                        var isArrayOneAvailable = false
                        
                        if indexOne <= imageArrayOne.count {
                            imageOne = imageArrayOne[indexOne - 1]
                            isArrayOneAvailable = true
                            imageDataOne = UIImageJPEGRepresentation(imageOne, 1.0)! as NSData
                            
                            var imageSize = (imageDataOne.length) / 1024
                            print(imageSize)
                            
                            if imageSize > 9000 {
                                imageDataOne = (UIImageJPEGRepresentation(imageOne, 0.02) as NSData?)!
                                imageSize = (imageDataOne.length) / 1024
                            } else if imageSize > 6000 {
                                imageDataOne = (UIImageJPEGRepresentation(imageOne, 0.03) as NSData?)!
                                imageSize = (imageDataOne.length) / 1024
                            }
                            else if imageSize > 5000 {
                                imageDataOne = (UIImageJPEGRepresentation(imageOne, 0.05) as NSData?)!
                                imageSize = (imageDataOne.length) / 1024
                            }
                            else if imageSize > 4000 {
                                imageDataOne = (UIImageJPEGRepresentation(imageOne, 0.07) as NSData?)!
                                imageSize = (imageDataOne.length) / 1024
                            }
                            else if imageSize > 3000 {
                                imageDataOne = (UIImageJPEGRepresentation(imageOne, 0.1) as NSData?)!
                                imageSize = (imageDataOne.length) / 1024
                            }
                            else if imageSize > 2000 {
                                imageDataOne = (UIImageJPEGRepresentation(imageOne, 0.15) as NSData?)!
                                imageSize = (imageDataOne.length) / 1024
                            }
                            else if imageSize > 1000 {
                                imageDataOne = (UIImageJPEGRepresentation(imageTwo, 0.3) as NSData?)!
                                imageSize = (imageDataOne.length) / 1024
                            }
                            else if imageSize > 500 {
                                imageDataOne = (UIImageJPEGRepresentation(imageTwo, 0.4) as NSData?)!
                                imageSize = (imageDataOne.length) / 1024
                            }
                            else if imageSize > 400 {
                                imageDataOne = (UIImageJPEGRepresentation(imageTwo, 0.5) as NSData?)!
                                imageSize = (imageDataOne.length) / 1024
                            }
                            
                            print(imageSize)
                        }
                        
                        if imageDataTwo != nil {
                            
                            //multipartFormData.appendBodyPart(data: imageDataTwo!, name: strImageKeyTwo, fileName: "image.jpeg", mimeType: "image/jpeg")
                            multipartFormData.append(imageDataTwo! as Data, withName: strImageKeyTwo, fileName: "image_\(indexOne - 1).jpeg", mimeType: "image/jpeg")
                            //appDelegate.arrOrderFloorplanImages["image_\(indexOne - 1).jpeg"] = "\(indexOne - 1)"
                            //appDelegate.arrOrderFloorplanImages.add(valueOne)
                            //print(appDelegate.arrOrderFloorplanImages)
                            
                            if isArrayOneAvailable == true {
                                //multipartFormData.appendBodyPart(data: imageDataOne, name: strImageKeyOne, fileName: "image.jpeg", mimeType: "image/jpeg")
                                multipartFormData.append(imageDataOne as Data, withName: strImageKeyOne, fileName: "image_\(indexOne - 1).jpeg", mimeType: "image/jpeg")
                                
                                //appDelegate.arrOderHomeImages["image_\(indexOne - 1).jpeg"] = "\(indexOne - 1)"
                                //appDelegate.arrOderHomeImages.add(value)
                                //print(appDelegate.arrOderHomeImages)
                            }
                            
                            if isParamsPosted == false {
                                
                                for (key, value) in dictParams {
                                    
                                    let data = "\(value)".data(using: .utf8)
                                    multipartFormData.append(data! as Data, withName: key)
                                }
                                
                                isParamsPosted = true
                            }
                        }
                        indexOne += 1
                    }
                }
                
                
            }
            }, with: requestName, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    
                    upload.responseJSON { response in
                        log.debug("Image(s) Uploaded successfully:\(response)")
                        //Networking.handleApiResponse(response)
                    }
                case .failure(let encodingError):
                    log.debug("encodingError:\(encodingError)")
                    // Networking.handleApiResponse(response)
                    
                    Util.showAlertWithMessage(msgSorry, title:"Error")
                }
                completionHandler!(encodingResult)
            }
        )
    }
    
    
    static func uploadVideoWithParams(_ requestName: Networking.Router, imageArray: [URL], strImageKey : String, dictParams: [String: AnyObject], callerObj: AnyObject, showHud: Bool, completionHandler: ((SessionManager.MultipartFormDataEncodingResult) -> Void)?) {
        
        if imageArray.count < 1 {
            return
        }
        
        // TODO: Need to check
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            var index = 1
            for image in imageArray {
                
                let videoData = NSData(contentsOf: image)
                //let imageData: NSData? = UIImagePickerControllerReferenceURL(image, 1.0)
                if videoData != nil {
                    
                    multipartFormData.append(videoData! as Data, withName: strImageKey, fileName: "video.mov", mimeType: "video/mov")
                            
                    for (key, value) in dictParams {
                        let data = "\(value)".data(using: .utf8)
                        multipartFormData.append(data! as Data, withName: key)
                    }
                }
                index += 1
            }
            }, with: requestName, encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                
                                upload.responseJSON { response in
                                    log.debug("Image(s) Uploaded successfully:\(response)")
                                    //Networking.handleApiResponse(response)
                                }
                            case .failure(let encodingError):
                                log.debug("encodingError:\(encodingError)")
                                // Networking.handleApiResponse(response)
                            }
                            completionHandler!(encodingResult)
            }
        )
    }
    
    
    /**
     * Method use for Image downloading from URL using KingFisher library.
     * - parameter fromUrl: Downloading image URL string
     * - parameter completionHandler: A closure that provide callback to caller after getting response
     */
    static func downloadImage(fromUrl url: String, completionHandler:@escaping (_ image: UIImage?) -> Void) {
        
        if url.isEmpty {
            completionHandler(nil)
            return
        }
        
        let imageViewTest = UIImageView()
        
        imageViewTest.kf.setImage(with: URL(string: url), placeholder: nil, options: nil, progressBlock: nil) { (image, error, cacheType, imageURL) -> () in
            
            completionHandler(image)
        }
    }
    
    /**
     * Genric method use for Image downloading from URL.
     * - parameter fromUrl: Downloading image URL string
     * - parameter paceholder: paceholder image name. If we not get image from server then return placehodel image.
     * - parameter completionHandler: A closure that provide callback to caller after getting response
     */
    
    static func downloadImage(fromUrl url: String, withPlaceHolder paceholder: String, completionHandler:@escaping (_ image: UIImage?) -> Void) {
        
        if url.isEmpty && paceholder.isEmpty {
            completionHandler(nil)
            return
        }
        
        if url.isEmpty && !paceholder.isEmpty {
            completionHandler(UIImage(named:paceholder))
            return
        }
        
        let imageViewTest   = UIImageView()
        var defaultImage    = UIImage()
        
        if !paceholder.isEmpty {
            defaultImage = UIImage(named:paceholder)!
        }
        
        imageViewTest.kf.setImage(with: URL(string: url), placeholder: defaultImage, options: nil, progressBlock: nil) { (image, error, cacheType, imageURL) -> () in
            
            if image == nil {
                completionHandler(defaultImage)
            }
            else {
                completionHandler(image)
            }
        }
    }
}


/**
 * Response Object Serialization Extension
 */
public protocol ResponseObjectSerializable {
    init?(response: HTTPURLResponse, representation: AnyObject)
}


