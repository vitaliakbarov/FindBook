//
//  Utils.swift
//  FindBook
//
//  Created by Vitali Akbarov on 18/01/2017.
//  Copyright © 2017 Vitali Akbarov. All rights reserved.
//

import UIKit


extension UIImage{
    

   class func resizeImage(image:UIImage) -> UIImage!
    {
        var actualHeight:Float = Float(image.size.height)
        var actualWidth:Float = Float(image.size.width)
        
        let maxHeight:Float = 84.0 //your choose height
        let maxWidth:Float = 84.0  //your choose width
        
        var imgRatio:Float = actualWidth/actualHeight
        let maxRatio:Float = maxWidth/maxHeight
        
        if (actualHeight > maxHeight) || (actualWidth > maxWidth)
        {
            if(imgRatio < maxRatio)
            {
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            }
            else if(imgRatio > maxRatio)
            {
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            }
            else
            {
                actualHeight = maxHeight;
                actualWidth = maxWidth;
            }
        }
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 84, height: 84))
        
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData:NSData = UIImageJPEGRepresentation(img, 1.0)! as NSData
        UIGraphicsEndImageContext()
        
        return (UIImage(data: imageData as Data)!)
    }

    
    
}
