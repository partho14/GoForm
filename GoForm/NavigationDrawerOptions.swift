//
//  NavigationDrawerOptions.swift
//  NavigationDrawer-Swift
//
//  Created by Nishan on 2/25/16.
//  Copyright © 2016 Nishan. All rights reserved.
//
//  Edited by Artem Mkrtchyan 8/7/2018
//

import Foundation
import UIKit

//Types of drawer. Left drawer open from Left side of screen whereas Right drawer opens from right side of the screen
enum NavigationDrawerType
{
    case leftDrawer
    case rightDrawer
}

//Modes for opening navigation drawer. Default is Anywhere, i.e anywhere can be swiped to open navigation drawer. For Left Drawer Type , RightEdge is overridden by LeftEdge. For Right Drawer Type , LeftEdge is overridden by RighEdge
enum NavigationDrawerOpenDirection
{
    case anyWhere
    case leftEdge
    case rightEdge
}

// .parent - below NavigationBat .window - over it.  Default is .parent
enum NavigationDrawerAnchorController {
    case window
    case parent
}

class NavigationDrawerOptions
{
    
    //Public variables
    
    //MARK: Anchor View properties
    
    var anchorView:UIView?
    private var anchorViewHeight:CGFloat!
    private var anchorViewWidth:CGFloat!
    
    //MARK: Navigation Drawer Properties
    
    var navigationDrawerWidth:CGFloat!
    var navigationDrawerHeight:CGFloat!
    var navigationDrawerXPosition:CGFloat!
    var navigationDrawerYPosition:CGFloat!
    var navigationDrawerBackgroundColor = UIColor.white
    var navigationDrawerType = NavigationDrawerType.leftDrawer
    var navigationDrawerOpenDirection = NavigationDrawerOpenDirection.anyWhere
    var navigationDrawerEdgeSwipeDistance:CGFloat = 20.0
    var navigationDrawerAnchorController : NavigationDrawerAnchorController = .parent
    var navigationDrawerPaddingMultiplier:CGFloat = 1/8
    
    var drawerController:UIViewController?
    
        
    init()
    {
        navigationDrawerXPosition = 0
        navigationDrawerYPosition = 0
    }
    
    /*
    Initializes defaults values for navigation Drawer
    */
    func initDefaults()
    {
        anchorViewHeight = UIScreen.main.bounds.size.height
        anchorViewWidth = UIScreen.main.bounds.size.width
        
        if navigationDrawerWidth == nil
        {
            navigationDrawerWidth = anchorViewWidth - anchorViewWidth * navigationDrawerPaddingMultiplier
        }
        
        if navigationDrawerHeight == nil
        {
             navigationDrawerHeight = anchorViewHeight
        }
    }
    
    
    /*
    Calculates X Position for navigation drawer(Left or Right) and returns it.
    
    - returns: X Position of navigation drawer
    */
    func getNavigationDrawerXPosition()->CGFloat
    {
        if navigationDrawerType == .leftDrawer
        {
            navigationDrawerXPosition = 0
        }
        else
        {
            navigationDrawerXPosition = anchorViewWidth - navigationDrawerWidth
        }
        return navigationDrawerXPosition
    }
    
    func getAnchorViewWidth() -> CGFloat
    {
        return self.anchorViewWidth
    }
    
    func getAnchorViewHeight() -> CGFloat
    {
        return self.anchorViewHeight
    }
    
}
