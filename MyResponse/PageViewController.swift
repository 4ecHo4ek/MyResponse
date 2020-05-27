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
            "Так выглядит главная страница, здесь будут отображаться все оставленные отзывы.",
            "Окно создания/редактирования позволит легко настроить базовые параметры Вашего отзыва. ",
            "Ну и маленький штришок - настройка цвета для отзывов, чтоб было легче ориентироваться =)",
            ""
        ]
        
        let photoArray = ["", "slid2", "slid3", "slid4", ""]
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            //названчаем делегата (из расширения который)
            dataSource = self
            
            
            //проверям что можно загрузить контроллер с нулевым символом
            if let contenViewController = showViewControllerAtIndext(0) {
                //загружаем контроллер
                //загружиаем массив наших странциц с направлением свайпа вперед
                setViewControllers([contenViewController], direction: .forward, animated: true, completion: nil)
            }
            
        }
        
        //создаем контроллер из кода
        //по шаблону
        func showViewControllerAtIndext(_ index: Int) -> SlidsViewController? {
            
            guard index >= 0 else { return nil }
            //тут делается выход из презентации, чтоб при свайпе после карйнего слайда, начиналась работа
            guard index < presentscreenContent.count else { 
                //создаем ключ для того, чтоб презентация открывалась только один раз
                let userDefaults = UserDefaults.standard
                //с ключом
                userDefaults.set(true, forKey: "presentationWasViewed")
                //закрываем страницу
                dismiss(animated: true, completion: nil)
                return nil
                
            }
            //создаем экземпляр контентвьюконтроллера
            //тут по идентификатору находим нужный контроллер (они все без связи)
            guard let contentViewController = storyboard?.instantiateViewController(
                withIdentifier: "SlidsViewController") as? SlidsViewController else { return nil }
            contentViewController.presentText = presentscreenContent[index]
            contentViewController.image = UIImage(systemName: photoArray[index])
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
