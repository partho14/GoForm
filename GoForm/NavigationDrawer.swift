//
//  NavigationDrawer.swift
//  NavigationDrawer-Swift
//
//  Created by Nishan on 2/25/16.
//  Copyright © 2016 Nishan. All rights reserved.
//
//  Edited by Artem Mkrtchyan 8/7/2018
//

import Foundation
import UIKit

@objc protocol NavigationDrawerDelegate
{
    @objc optional func navigationDrawerDidShow(didShow:Bool)
    @objc optional func navigationDrawerDidHide(didHide:Bool)
}

class NavigationDrawer: NSObject
{
    
    static let instance = NavigationDrawer()
    
    //MARK: Public variable
    var delegate:NavigationDrawerDelegate?
    
    //MARK: Private Variables
    var options:NavigationDrawerOptions!
    private var isDrawerShown = false
    private var navigationDrawerContainer = UIView()
     var navigationDrawer = UIView()
    
    /*
    Sets options for Navigation Drawer and starts preparing navigation drawer for display
    
    - params: options: NavigationDrawerOptions
    */
    func setup(withOptions options:NavigationDrawerOptions)
    {
        self.options = options
        //initNavigationDrawer() -> Doing this over there
    }
    
    /*
    Initializes View Controller and Navigation Drawer with the options provided.
    */
    private func initNavigationDrawer()
    {
        self.navigationDrawer.removeFromSuperview()
        //setting up container for navigation drawer
        navigationDrawerContainer.frame = CGRect(x: 0, y: 0, width: options.getAnchorViewWidth(), height: options.getAnchorViewHeight())
        navigationDrawerContainer.backgroundColor = UIColor.black.withAlphaComponent(0)
        
        //Tap gesture to hide drawer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapNavigation(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.delegate = self
        navigationDrawerContainer.addGestureRecognizer(tapGesture)
        
        //swipe gesture to hide and show drawer
        let drawerCloseGesture = UISwipeGestureRecognizer(target: self, action:#selector(handleSwipeNavigation(_:)))
        
        if options.navigationDrawerType == NavigationDrawerType.leftDrawer
        {
            let leftToRightSwiper = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeNavigation(_:)))
            leftToRightSwiper.direction = .right
            drawerCloseGesture.direction = .left
            options.anchorView!.addGestureRecognizer(leftToRightSwiper)
        }
        else
        {
            let rightToLeftSwiper = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeNavigation(_:)))
            rightToLeftSwiper.direction = .left
            drawerCloseGesture.direction = .right
            options.anchorView!.addGestureRecognizer(rightToLeftSwiper)
        }
        
        //setting up navigation drawer
        navigationDrawer.frame = CGRect(x: options.getNavigationDrawerXPosition(), y: options.navigationDrawerYPosition, width: options.navigationDrawerWidth, height: options.navigationDrawerHeight)
        navigationDrawer.backgroundColor = options!.navigationDrawerBackgroundColor
        navigationDrawer.addGestureRecognizer(drawerCloseGesture)
        navigationDrawerContainer.addSubview(navigationDrawer)
        
    }
    
    
    /*
    Hides or Shows Navigation drawer with animation
    
    - params: completionHandler closure for handling completion of toggling of navigation drawer
    */
    func toggleNavigationDrawer(completionHandler: (()->Void)?)
    {
        if !isDrawerShown
        {
            isDrawerShown = true
            self.options.anchorView!.addSubview(self.navigationDrawerContainer)
            self.options.anchorView!.bringSubviewToFront(self.navigationDrawerContainer)
            
            if options.navigationDrawerType == NavigationDrawerType.leftDrawer
            {
                navigationDrawer.frame.origin.x = -options.navigationDrawerWidth
                
                UIView.animate(withDuration: 0.5, animations: {[unowned self]() -> Void in
                    
                    self.navigationDrawer.frame.origin.x += self.options.navigationDrawerWidth
                    self.navigationDrawerContainer.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                    }, completion: {[unowned self](finished) -> Void in
                        if finished
                        {
                            self.delegate?.navigationDrawerDidShow?(didShow: true)
                            completionHandler?()
                        }
                })
            }
            else
            {
                navigationDrawer.frame.origin.x += options.navigationDrawerWidth
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    
                    self.navigationDrawer.frame.origin.x -= self.options.navigationDrawerWidth
                    //self.navigationDrawerContainer.alpha = 0.4
                    self.navigationDrawerContainer.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                    }, completion: { (finished) -> Void in
                        self.delegate?.navigationDrawerDidShow?(didShow: true)
                        completionHandler?()
                })
            }
        }
        else
        {
            isDrawerShown = false
            if options.navigationDrawerType == NavigationDrawerType.leftDrawer
            {
                UIView.animate(withDuration: 0.5, animations: {[unowned self]() -> Void in
                    
                    self.navigationDrawer.frame.origin.x -= self.options.navigationDrawerWidth
                    self.navigationDrawerContainer.backgroundColor = UIColor.black.withAlphaComponent(0)
                    }, completion: {[unowned self](finished) -> Void in
                        if finished
                        {
                            self.navigationDrawerContainer.removeFromSuperview()
                            self.delegate?.navigationDrawerDidHide?(didHide: true)
                            completionHandler?()
                        }
                })
            }
            else
            {
                UIView.animate(withDuration: 0.5, animations: {[unowned self]() -> Void in
                    
                    self.navigationDrawer.frame.origin.x += self.options.navigationDrawerWidth
                    self.navigationDrawerContainer.backgroundColor = UIColor.black.withAlphaComponent(0)
                    }, completion: {[unowned self](finished) -> Void in
                        if finished
                        {
                            self.navigationDrawerContainer.removeFromSuperview()
                            self.navigationDrawer.frame.origin.x = self.options.navigationDrawerXPosition
                            self.delegate?.navigationDrawerDidHide?(didHide: true)
                            completionHandler?()
                        }
                    })
            }
        }
    }
    
    /*
    Handles Tap to hide navigation drawer
    
    -params: UITapGestureRecognizer
    */
    @objc
    func handleTapNavigation(_ sender:UITapGestureRecognizer)
    {
        toggleNavigationDrawer(completionHandler: nil)
    }
    
    /*
    Handles Left and Right navigation swipe to show navigation drawer
    
    -params: UISwipeGestureRecognizer
    */
    @objc
    func handleSwipeNavigation(_ sender:UISwipeGestureRecognizer)
    {
        let location = sender.location(in: options.anchorView).x
        
        if !isDrawerShown
        {
           //For Opening
            if options.navigationDrawerOpenDirection == NavigationDrawerOpenDirection.anyWhere
            {
                toggleNavigationDrawer(completionHandler: nil)
            }
            else
            {
                if sender.direction == UISwipeGestureRecognizer.Direction.right
                {
                    if location <= options.navigationDrawerEdgeSwipeDistance
                    {
                        toggleNavigationDrawer(completionHandler: nil)
                    }
                }
                else if sender.direction == UISwipeGestureRecognizer.Direction.left
                {
                    if location >= options.getAnchorViewWidth() - options.navigationDrawerEdgeSwipeDistance
                    {
                        toggleNavigationDrawer(completionHandler: nil)
                    }
                }
            }
        
        }
        else
        {
            //For Closing
            if options.navigationDrawerType == NavigationDrawerType.leftDrawer{
                if sender.direction == UISwipeGestureRecognizer.Direction.left
                {
                    toggleNavigationDrawer(completionHandler: nil)
                }
            }
            else
            {
                if sender.direction == UISwipeGestureRecognizer.Direction.right
                {
                    toggleNavigationDrawer(completionHandler: nil)
                }
            }
            
        }
    }
    
    
    /*
    Sets the view controller for navigation drawer
    
    - params: UIViewController which controls Navigation Drawer
    */
    func setNavigationDrawerController(viewController:UIViewController)
    {
        self.options.drawerController = viewController
        viewController.view.frame = navigationDrawer.bounds
        self.navigationDrawer.addSubview(viewController.view)
    }
    
    
    /*
    Reinitializes the navigation drawer view for the current ViewController. Any View Controller calling this methods will have navigation drawer available for it with the same configuration which was supplied during its first initialization.
    
    -params: UIViewController in which navigation drawer is to be shown
    */
    func initialize(forViewController viewController:UIViewController)
    {
        options.anchorView = (options.navigationDrawerAnchorController == .window) ? UIApplication.shared.keyWindow : viewController.view
        options.initDefaults()
        if (options.navigationDrawerAnchorController != .window) { viewController.addChild(options.drawerController!) }
        initNavigationDrawer()
    }
    
}



extension NavigationDrawer: UIGestureRecognizerDelegate{
    
    /*
    Disables touch gesture for navigation drawer
    */
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        
        let location = touch.location(in: options.anchorView)
        
        if navigationDrawer.frame.contains(location)
        {
            return false
        }
        return true
    }
}

extension UIImageView {
    
    func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
