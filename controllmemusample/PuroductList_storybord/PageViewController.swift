//
//  PageViewController.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/02/23.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController,UIPageViewControllerDataSource   {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([getFirst()], direction: .forward, animated: true, completion: nil)
        self.dataSource = self
        let myRightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.post))
        self.navigationItem.setRightBarButtonItems([myRightButton], animated: true)
        self.navigationItem.title = "教科書"
    }
    @objc func post(sender: UIButton){
        
        let storyboard: UIStoryboard = UIStoryboard(name: "ProductContribution", bundle: nil)
        let nextView = storyboard.instantiateViewController(withIdentifier: "CategorySelect")
//        let navi = UINavigationController(rootViewController: nextView)
        self.navigationController?.show(nextView, sender: nil)
        
    }
    func getFirst() -> FirstViewController {
        return storyboard!.instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
        //StoryBoard上のFirstViewControllerをインスタンス化している
        //withIdentifierはStoryBoard上で設定したStoryBoard Id
    }
    
    func getSecond() -> SecondViewController {
        return storyboard!.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
    }
    
    func getThird() -> ThirdViewController {
        return storyboard!.instantiateViewController(withIdentifier: "ThirdViewController") as! ThirdViewController
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: ThirdViewController.self)// 現在のviewControllerがThirdViewControllerかどうか調べる
        {
            // 3 -> 2
//            self.navigationItem.title = "ノート"
            print("1")
            return getSecond()
            
        } else if viewController.isKind(of: SecondViewController.self) {// 現在のviewControllerがSecondViewControllerかどうか調べる
            // 2 -> 1
            self.navigationItem.title = "ノート"
            print("2")
            return getFirst()
            
        } else {
            // 1 -> end of the road
             self.navigationItem.title = "教科書"
            print("3")
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: FirstViewController.self)//　現在のviewControllerがFirstViewControllerかどうか調べる
        {
            // 1 -> 2
//            self.navigationItem.title = "ノート"
            print("4")
            return getSecond()
            
        } else if viewController.isKind(of: SecondViewController.self) {//　現在のviewControllerがSecondViewCotrollerかどうか調べる
            // 2 -> 3
            self.navigationItem.title = "ノート"
            print("5")
            
            return getThird()
            
        } else {
            // 3 -> end of the road
            self.navigationItem.title = "過去問"
            print("6")
            return nil
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
