//
//  MainPageViewController.swift
//  MyBrew
//
//  Created by Jayme Becker on 2/16/16.
//  Copyright © 2016 Jayme Becker. All rights reserved.
//

import UIKit


class MainPageViewController: UIPageViewController {
    
    //create the array of view controllers in the order I want them in
    fileprivate(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newViewController("Discover"),
            self.newViewController("MyBeer"),
            self.newViewController("Recommendations")]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self

        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                direction: .forward,
                animated: true,
                completion: nil)
        }
    }
    
    //instantiate the view controllers
    fileprivate func newViewController(_ name: String) -> UIViewController {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(name)NavController")
    }
}

//MARK: UIPageViewControllerDataSource
extension MainPageViewController: UIPageViewControllerDataSource {
        
        func pageViewController(_ pageViewController: UIPageViewController,
            viewControllerBefore viewController: UIViewController) -> UIViewController? {
                
                guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
                    return nil
                }
                
                let previousIndex = viewControllerIndex - 1
                
                guard previousIndex >= 0 else {
                    return nil
                }
                
                guard orderedViewControllers.count > previousIndex else {
                    return nil
                }
                
                return orderedViewControllers[previousIndex]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController,
            viewControllerAfter viewController: UIViewController) -> UIViewController? {
                
                guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
                    return nil
                }
                
                let nextIndex = viewControllerIndex + 1
                let orderedViewControllersCount = orderedViewControllers.count
                
                guard orderedViewControllersCount != nextIndex else {
                    return nil
                }
                
                guard orderedViewControllersCount > nextIndex else {
                    return nil
                }
                
                return orderedViewControllers[nextIndex]
        }
        
}



