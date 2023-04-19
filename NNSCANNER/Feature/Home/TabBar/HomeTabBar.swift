//
//  HomeTabBar.swift
//  NNSCANNER
//
//  Created by Nhat on 17/04/2023.
//
import UIKit

class HomeTabBarViewController: UITabBarController{

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    private let centerButton = UIButton()
    override func viewDidLoad() {

        tabBar.backgroundColor =  UIColor(hex6: "#ededed")
        tabBar.tintColor = UIColor(hex6: "#1859C4")
        tabBar.unselectedItemTintColor = UIColor.gray
        let homeVC = HomeViewController()
        let settingsVC = SettingsViewController()

        let homeNavController = UINavigationController(rootViewController: homeVC)
        let settingsNavController = UINavigationController(rootViewController: settingsVC)

        homeNavController.tabBarItem = UITabBarItem(title: "Files", image: UIImage(systemName: "folder.fill"), tag: 0)
        settingsNavController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "person.circle"), tag: 2)

        viewControllers = [homeNavController, settingsNavController]

        // Thiết lập font chữ và màu sắc cho title
        let titleFont = UIFont.systemFont(ofSize: 12, weight: .regular)
        let normalAttributes: [NSAttributedString.Key: Any] = [.font: titleFont, .foregroundColor: UIColor.gray]
        let selectedAttributes: [NSAttributedString.Key: Any] = [.font: titleFont, .foregroundColor: UIColor.gray]

        UITabBarItem.appearance().setTitleTextAttributes(normalAttributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(selectedAttributes, for: .selected)
        // Tạo button
        centerButton.translatesAutoresizingMaskIntoConstraints = false
        centerButton.setImage(UIImage(named: "camera"), for: .normal)

        centerButton.layer.cornerRadius = 25
        centerButton.addTarget(self, action: #selector(showCameraOptions), for: .touchUpInside)

        // Thêm button vào view
        tabBar.addSubview(centerButton)

        // Thiết lập constraints cho button
        centerButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        centerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        centerButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor).isActive = true
        centerButton.centerYAnchor.constraint(equalTo: tabBar.topAnchor, constant: 15).isActive = true

        // Đảm bảo button được hiển thị trên các tab
        view.bringSubviewToFront(tabBar)
    }
    // Xử lý sự kiện khi button được bấm
    @objc func showCameraOptions() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let takeOnePageAction = UIAlertAction(title: "Scan One Page", style: .default) { _ in
            let vc = ScanViewController()
            vc.option = 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let takeMultiPageAction = UIAlertAction(title: "Scan Multiple Page", style: .default) { _ in
            let vc = ScanViewController()
            vc.option = 1
            self.navigationController?.pushViewController(vc, animated: true)
        }

        let choosePhotoAction = UIAlertAction(title: "Scan from Library", style: .default) { _ in
            let vc = ScanViewController()
            vc.option = 2
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            if let tabBarController = self.tabBarController {
                tabBarController.selectedIndex = 0 // chuyển đến tab thứ hai

            }
        })

        alertController.addAction(takeOnePageAction)
        alertController.addAction(takeMultiPageAction)
        alertController.addAction(choosePhotoAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
}
