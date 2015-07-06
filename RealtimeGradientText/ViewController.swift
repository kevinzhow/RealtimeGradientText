//
//  ViewController.swift
//  RealtimeGradientText
//
//  Created by kevinzhow on 15/7/6.
//  Copyright (c) 2015年 kevinzhow. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var transparentTextview: UITextView!
    
    @IBOutlet weak var originalTextView: UITextView!
    
    var displayLink: CADisplayLink?
    
    var initLayout = false
    
    var order = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        transparentTextview.delegate = self
        
        var tap = UITapGestureRecognizer(target: self, action: "endEdit")
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    var gradient = CAGradientLayer()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !initLayout {
            gradient.frame = originalTextView.bounds
            
            originalTextView.frame = originalTextView.bounds // Reset originalTextView Position when as gradient's mask
            
            gradient.colors = [UIColor(red:0, green:0.46, blue:1, alpha:1.0).CGColor, UIColor(red:0.91, green:0.28, blue:0.5, alpha:1.0).CGColor]
            gradient.locations = [0.0,1.0];
            gradient.mask = originalTextView.layer
            
            transparentTextview.layer.addSublayer(gradient)
        }

    }
    
    func callbackShimmer() {

        if order {
            
            gradient.startPoint = CGPoint(x: gradient.startPoint.x + 0.01, y: gradient.startPoint.y + 0.01)
            gradient.endPoint = CGPoint(x: gradient.endPoint.x - 0.01, y: gradient.endPoint.y - 0.01)
            
            if gradient.startPoint.x >= 1 {
                order = false
            }
        } else {
            gradient.startPoint = CGPoint(x: gradient.startPoint.x - 0.01, y: gradient.startPoint.y - 0.01)
            gradient.endPoint = CGPoint(x: gradient.endPoint.x + 0.01, y: gradient.endPoint.y + 0.01)
            
            if gradient.startPoint.x <= 0 {
                order = true
            }
        }

    }
    
    func endEdit() {
        transparentTextview.resignFirstResponder()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        originalTextView.text = textView.text
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        println("Invalidate")
        if let displayLink = displayLink {
            displayLink.invalidate()
        }

    }
    
    func textViewDidEndEditing(textView: UITextView) {
        println("End Edit")
        displayLink = CADisplayLink(target: self, selector: Selector("callbackShimmer"))
        displayLink!.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
}

