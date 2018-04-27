//
//  ApiConstants.swift
//  Bosala
//



//** Base url of web service
//TODO: Build Changes
//For Live
//creativethoughtsinfo.com/CT10/qareeb/Apis/images/users
//For Development
let kAPI_BaseURL                = ""

//************************** Constant for API Keys **************************//

//** Common Api Constant
let kAPI_Data                           = "data"
let kAPI_Items                          = "items"
let kAPI_ServerDateFormat               = "yyyy-MM-dd'T'HH:mm:ss.SSS"
let kAPI_AppDateFormat                  = "yyyy-MM-dd HH:mm:ss.SSS"
let kAPI_Success                        = "success"
let kAPI_Error                          = "error"
let kAPI_MessageAlert                   = "Message"
let kAPI_Message                        = "message"
let kAPI_Alert                          = "Qareeb"
let kAPI_Id                             = "id"

let kAPI_ServerNotificationDateFormat   = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS"
let kAPI_24HourTimeFormat               = "HH:mm:ss"
let kAPI_12HourTimeFormat               = "hh:mm a"


//****************************************************
// MARK: - Api Constant
//****************************************************



//** Pull to refresh
let kAPI_Meta                           = "_meta"
let kAPI_CurrentPage                    = "currentPage"
let kAPI_PageCount                      = "pageCount"
let kAPI_NextPageCount                  = "nextPageCount"
let kAPI_AccessToken                    = "token"
let kAPI_SocialId                       = "social_id"


let GoogleAPI_Key           = "AIzaSyAUESuWeONu0IlukkPyYHFg7oZykwW2SqY"
let baseUrl                 = "https://maps.googleapis.com/maps/api/geocode/json"
let baseURLString           = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
let baseUrlLocation         = "http://maps.google.com/maps/api/geocode/json?sensor=false&address="


//**    Result Success |"1"| / Failure |"0"|
let kAPI_Result_Success                            = "1"
let kAPI_Result_Failure                            = "0"

//** Certificate Type
let kCertificateDevelopment         = "development"
let kCertificateDistribution        = "distribution"
let kCertificateAppStore            = "live"


//** Other Api Constants
let kDevicePlatform                 = "ios"


//*> Server response code

//    200 – OK – Eyerything is working
//    201 – OK – New resource has been created
//    204 – OK – The resource was successfully deleted
//
//    304 – Not Modified – The client can use cached data
//
//    400 – Bad Request – The request was invalid or cannot be served. The exact error should be explained in the error payload. E.g. „The JSON is not valid“
//    401 – Unauthorized – The request requires an user authentication
//    403 – Forbidden – The server understood the request, but is refusing it or the access is not allowed.
//    404 – Not found – There is no resource behind the URI.
//    422 – Unprocessable Entity – Should be used if the server cannot process the enitity, e.g. if an image cannot be formatted or mandatory fields are missing in the payload.
//
//    500 – Internal Server Error – API developers should avoid this error. If an error occurs in the global catch blog, the stracktrace should be logged and not returned as response.

//** Testing Login credential

/*
1)
//Username  : "kateconnor",
//Password  : "kate123",

2)
// Username: scott-test
//Password: AppTeam2015
*/
