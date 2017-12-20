/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

protocol AnnotationViewDelegate {
  func didTouch(annotationView: AnnotationView)
}


class AnnotationView: ARAnnotationView {
  @objc var titleLabel: UILabel?
  @objc var distanceLabel: UILabel?
  @objc var timeLabel: UILabel?
  @objc var vieww: UIView?
  var delegate: AnnotationViewDelegate?
  @objc var imageType: UIImageView?

  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    loadUI()
    
  }
   
  @objc func loadUI() {
    titleLabel?.removeFromSuperview()
    distanceLabel?.removeFromSuperview()
    let label = UILabel(frame: CGRect(x: 70, y: 0, width: self.frame.size.width, height: 30))
    label.font = UIFont.systemFont(ofSize: 16)
    label.numberOfLines = 100
//    label.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
    label.backgroundColor = UIColor.white
    label.textColor = UIColor.black
    label.textAlignment = .center
    self.addSubview(label)
    self.titleLabel = label
    
    distanceLabel = UILabel(frame: CGRect(x: 70, y: 30, width: self.frame.size.width, height: 20))
//    distanceLabel?.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
    distanceLabel?.backgroundColor = UIColor.white
    distanceLabel?.textColor = UIColor.gray
    distanceLabel?.textAlignment = .center
    distanceLabel?.font = UIFont.systemFont(ofSize: 12)
    self.addSubview(distanceLabel!)
    vieww = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    self.addSubview(vieww!)
    vieww?.backgroundColor = UIColor(red: 0.0/255, green: 127.0/255, blue: 246.0/255,alpha:1.0)
    imageType = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    self.imageType?.image = UIImage(named:"arimage")
    self.imageType?.contentMode = .scaleAspectFit
    self.vieww?.addSubview(imageType!)
    timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: (vieww?.frame.width)!, height: 60))
//    self.vieww?.addSubview(timeLabel!)
    self.timeLabel?.backgroundColor = UIColor.white
    if let annotation = annotation as? Place {
      titleLabel?.text = annotation.placeName
      distanceLabel?.text = String(format: "%.2f km", annotation.distanceFromUser / 1000)
        print("reference",annotation.reference)
        timeLabel?.text = annotation.reference

    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    titleLabel?.frame = CGRect(x: 70, y: 0, width: self.frame.size.width+20, height: 40)
    //70
    distanceLabel?.frame = CGRect(x: 40, y: 40, width: self.frame.size.width+50, height: 20)
    vieww?.frame = CGRect(x: 2, y: 0, width: 70, height: 60)
    imageType?.frame = CGRect(x: 2, y: 0, width: 70, height: 50)

//    timeLabel?.frame = CGRect(x: 170, y: 40, width: 70, height: 20)
    timeLabel = UILabel(frame: CGRect(x: 2, y: 0, width: (vieww?.frame.width)!, height: 60))

    self.titleLabel?.layer.borderWidth = 1
    self.titleLabel?.layer.cornerRadius = 3
    self.distanceLabel?.layer.borderWidth = 1
    self.distanceLabel?.layer.cornerRadius = 3
    self.vieww?.layer.borderWidth = 1
    self.vieww?.layer.cornerRadius = 3
    self.vieww?.layer.borderColor = UIColor.clear.cgColor
    self.distanceLabel?.layer.borderColor = UIColor.clear.cgColor
    self.titleLabel?.layer.borderColor = UIColor.clear.cgColor


  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    delegate?.didTouch(annotationView: self)
  }
}
