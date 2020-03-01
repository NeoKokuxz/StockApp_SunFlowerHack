//
//  TutorialViewController.swift
//  StockApp
//
//  Created by Naoki on 2/29/20.
//  Copyright © 2020 Naoki. All rights reserved.
//

import UIKit

class TutorialViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    lazy var orderedViewController: [UIViewController] = {
        return [self.newVc(viewcontroller: "sbOne"),
                self.newVc(viewcontroller: "sbTwo"),
                self.newVc(viewcontroller: "sbThree"),
                self.newVc(viewcontroller: "sbFour"),
                self.newVc(viewcontroller: "sbFive"),
                self.newVc(viewcontroller: "sbSix"),
                self.newVc(viewcontroller: "sbSeven"),
                self.newVc(viewcontroller: "sbEight"),
                self.newVc(viewcontroller: "sbNine")]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.dataSource = self
        if let firstVC = orderedViewController.first {
            setViewControllers([firstVC],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
    }
    
    func newVc(viewcontroller: String) -> UIViewController{
        return UIStoryboard(name:"Main", bundle: nil).instantiateViewController(identifier: viewcontroller)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewController.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            //Dismiss page function insert here - maybe
            return orderedViewController.last
        }
        
        guard orderedViewController.count > previousIndex else {
            return nil
        }
        
        return orderedViewController[previousIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewController.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard orderedViewController.count != nextIndex else {
            //Dismiss page function insert here - maybe
            return orderedViewController.first
        }
        
        guard orderedViewController.count > nextIndex else {
            return nil
        }
        
        return orderedViewController[nextIndex]
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
