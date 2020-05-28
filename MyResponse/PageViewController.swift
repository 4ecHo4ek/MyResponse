//
//  PageViewController.swift
//  MyResponse
//
//  Created by Сергей Цыганков on 27.05.2020.
//  Copyright © 2020 Сергей Цыганков. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {

    let presentscreenContent = [
            "Добро пожаловать в приложение, дающее возможность оставлять отзывы о вещах, с которыми Вы имели дело. ",
            ""
        ]
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            dataSource = self
            if let contenViewController = showViewControllerAtIndext(0) {
                setViewControllers([contenViewController], direction: .forward, animated: true, completion: nil)
            }
        }
        
        func showViewControllerAtIndext(_ index: Int) -> SlidsViewController? {
            
            guard index >= 0 else { return nil }
            guard index < presentscreenContent.count - 1  else {
                let userDefaults = UserDefaults.standard
                userDefaults.set(true, forKey: "presentationWasViewed")
                dismiss(animated: true, completion: nil)
                return nil
            }
            
            guard let contentViewController = storyboard?.instantiateViewController(
                withIdentifier: "SlidsViewController") as? SlidsViewController
                else { return nil }
            
            contentViewController.presentText = presentscreenContent[index]
            contentViewController.curentPage = index
            contentViewController.numderOfPages = presentscreenContent.count
            
            return contentViewController
        }
    }


    //подписываемся под протокол для того, чтоб можно было листать страницы

    extension PageViewController: UIPageViewControllerDataSource {
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore
            viewController: UIViewController) -> UIViewController? {
            //узнаем текущую страницу
            //создаем экземпляр класса, и достаем оттуда одно интересующее нас свойство
            var pageNumber = (viewController as! SlidsViewController).curentPage
            pageNumber -= 1
            
            return showViewControllerAtIndext(pageNumber)
            
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter
            viewController: UIViewController) -> UIViewController? {
            //тоже самое только для страницы после выбранной
            var pageNumber = (viewController as! SlidsViewController).curentPage
            pageNumber += 1
            
            return showViewControllerAtIndext(pageNumber)
        }
        //дальше необходимо назначить делегата, кторый и будет эти методы доставать
        
    }
//MARK: - сделать так, чтоб на крайнем слайде скрывалось
