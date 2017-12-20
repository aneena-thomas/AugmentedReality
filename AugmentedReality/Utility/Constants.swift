//
//  Constants.swift
//  Sabarimala
//
//  Created by MAC on 23/10/17.
//  Copyright © 2017 Experion Technologies Pvt Ltd. All rights reserved.
//

import UIKit

let BEARER:NSString = "Bearer "
let BASE_URL = "https:///api"

enum AugmentedReality_E_NetWorK: String{
    case LOGIN   = "login"
}
enum AugmentedReality:String {
    case Title          = "Turn On Location Services to Allow Sabarimala to Determine your Location"
    case Message        = "Allow Safe Sabarimala to determine the time taken to reach Sabarimala."
    case OK        = "OK"
    case Cancel        = "Cancel"
    case Settings = "Settings"
    case Success = "Success"
    case Error = "Error"
    case Warning = "Warning"
    case WarningMessage = "You don't have camera"
    case skip = "SKIP"
    case done = "DONE"
    case Photos = "Photos"
    case cameraMessage = "Please check Camera Permissions in Settings"
    case NO        = "NO"
    case YES        = "YES"
    case OpenPhotoLibrary = "Open Photo Library"
    case Chooseyourlanguage = "Choose your language"


}



