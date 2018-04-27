//
//  Logger.swift
//  Bosala


import Foundation
import XCGLogger

/**
 Print Log only in debug mode with Class Name, Function name, Line number and your log message
 */
#if DEBUG
    func DLog(message: String, filename: String = #file, function: String = #function, line: Int = #line) {
        NSLog("[\((filename as NSString).lastPathComponent):\(line)] \(function) - \(message)")
    }
#else
    func DLog(_ message: String, filename: String = #file, function: String = #function, line: Int = #line) {
    }
#endif

/**
 Build setting not matter always Print this Log with Class Name, Function name, Line number and your log message
 */
func ALog(_ message: String, filename: String = #file, function: String = #function, line: Int = #line) {
    NSLog("[\((filename as NSString).lastPathComponent)):\(line)] \(function) - \(message)")
}

/**
 Setup XCGLogger class for logging in app. Always use |log| in whole app in place on |DLog| and |ALog|
 */

let log: XCGLogger = {
    // Setup XCGLogger
    let log = XCGLogger.default
    //    log.xcodeColorsEnabled = true // Or set the XcodeColors environment variable in your scheme to YES
    //    log.xcodeColors = [
    //        .Verbose: .darkGrey,
    //        .Debug: .blue,
    //        .Info: .darkGreen,
    //        .Warning: .orange,
    //        .Error: XCGLogger.XcodeColor(fg: UIColor.redColor(), bg: UIColor.whiteColor()), // Optionally use a UIColor
    //        .Severe: XCGLogger.XcodeColor(fg: (255, 255, 255), bg: (255, 0, 0)) // Optionally use RGB values directly
    //    ]
    
    #if USE_NSLOG // Set via Build Settings, under Other Swift Flags
        log.removeLogDestination(XCGLogger.constants.baseConsoleLogDestinationIdentifier)
        log.addLogDestination(XCGNSLogDestination(owner: log, identifier: XCGLogger.constants.nslogDestinationIdentifier))
        log.logAppDetails()
    #else
        
        //TODO: Build changes: Comment these lines and uncomment below lines
        //** For Developement
        //log.outputLogLevel = .Verbose
        log.outputLevel = .debug
        log.setup(level: .debug, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil, fileLevel: .debug)
        
        //** For Production
        //log.outputLevel = .error
        //log.setup(level: .error, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil, fileLevel: .error)
        
        
    #endif
    
    return log
}()
