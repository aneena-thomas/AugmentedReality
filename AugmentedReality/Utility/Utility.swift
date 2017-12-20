//
//  Utility.swift
//  Sabarimala
//
//  Created by MAC on 22/11/17.
//  Copyright © 2017 Experion Technologies Pvt Ltd. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
var customActivityIndicator = UIActivityIndicatorView()

class Utility {
    /// To check the reachability status. Will return 'true' if network is reachable.
    class  var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    class func showAlert(title: String, message: String, delegate: AnyObject) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:AugmentedReality.OK.rawValue, style: .default, handler:nil))
        let viewController = delegate as? UIViewController ?? UIViewController()
        viewController.present(alert, animated: true, completion: nil)
    }
   class func customActivityIndicatory(_ viewContainer: UIView, startAnimate:Bool? = true) -> UIActivityIndicatorView {
        let mainContainer: UIView = UIView(frame: viewContainer.frame)
        mainContainer.center = viewContainer.center
        mainContainer.backgroundColor = UIColor.clear
        mainContainer.alpha = 1
        mainContainer.tag = 789456123
        mainContainer.isUserInteractionEnabled = false
        
        let viewBackgroundLoading: UIView = UIView(frame: CGRect(x:0,y: 0,width: 70,height:70))
        viewBackgroundLoading.center = viewContainer.center
        viewBackgroundLoading.backgroundColor = UIColor.clear
        viewBackgroundLoading.alpha = 1
        viewBackgroundLoading.clipsToBounds = true
        viewBackgroundLoading.layer.cornerRadius = 15
        
        let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.frame = CGRect(x:0.0,y: 0.0,width:10.0, height:10.0)
        activityIndicatorView.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        activityIndicatorView.color = UIColor.black
        activityIndicatorView.center = CGPoint(x: viewBackgroundLoading.frame.size.width / 2, y: viewBackgroundLoading.frame.size.height / 2)
        if startAnimate!{
            viewBackgroundLoading.addSubview(activityIndicatorView)
            mainContainer.addSubview(viewBackgroundLoading)
            viewContainer.addSubview(mainContainer)
            activityIndicatorView.startAnimating()
        }else{
            for subview in viewContainer.subviews{
                if subview.tag == 789456123{
                    subview.removeFromSuperview()
                }
            }
        }
        return activityIndicatorView
    }
    
    
}


