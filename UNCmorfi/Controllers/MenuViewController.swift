//
//  MenuViewController.swift
//  UNCmorfi
//
//  Created by George Alegre on 5/24/17.
//
//  LICENSE is at the root of this project's repository.
//

import UIKit

class MenuViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private var menu: [Date: [String]]? = nil

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE d"
        return dateFormatter
    }()

    convenience init() {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "menu.nav.label".localized()
        if #available(iOS 11.0, *) {
            navigationController!.navigationBar.prefersLargeTitles = true
        }

        collectionView?.backgroundColor = .white
        collectionView?.register(FoodCell.self, forCellWithReuseIdentifier: FoodCell.reuseIdentifier)

        UNCComedor.getMenu { error, menu in
            guard error == nil else {
                return
            }
            
            self.menu = menu
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menu?.keys.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodCell.reuseIdentifier, for: indexPath) as? FoodCell else {
            fatalError("Dequeued cell is not a FoodCell.")
        }

        let date = menu!.keys.sorted()[indexPath.row]
        cell.dateLabel.text = dateFormatter.string(from: date)

        menu![date]!.enumerated().forEach{ index, meal in
            guard let label = cell.mealsStackView.arrangedSubviews[index] as? UILabel else {
                fatalError("Todo mal")
            }

            label.text = meal
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 130)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

//    private func setupViews() {
//        menu?.keys.sorted().reduce("") { (text: String, date: Date) -> String in
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "EEEE d"
//            
//            let dateDescription = dateFormatter.string(from: date)
//            let foodDescription = menu?[date]!.joined(separator: "\n") ?? ""
//            return text.appending("\(dateDescription):\n\(foodDescription)\n\n")
//        }.trimmingCharacters(in: .whitespaces)
//    }
}
