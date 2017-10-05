//
//  CouterViewController.swift
//  UNCmorfi
//
//  Created by George Alegre on 9/10/17.
//
//  LICENSE is at the root of this project's repository.
//

import UIKit

class CounterViewController: UIViewController {
    // MARK: Views
    private let counterView: CounterView = {
        let view = CounterView(frame: CGRect.zero)
        return view
    }()

    // MARK: Properties
    private var servings: [Date: Int]? = nil {
        didSet {
            guard let servings = servings else { return }

            let servingsCount = servings.keys.sorted().reduce(0) { (count, date) -> Int in
                return count + servings[date]!
            }
            counterView.currentValue = 23
        }
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.title = "counter.nav.label".localized()
        if #available(iOS 11.0, *) {
            navigationController!.navigationBar.prefersLargeTitles = true
        }
        
        setupCounter()

        UNCComedor.getServings { (error: Error?, servings: [Date : Int]?) in
            guard error == nil else {
                // TODO this is temporary // Has to be in main queue
                return
            }

            DispatchQueue.main.async {
                self.servings = servings
                self.prepareTimer()
            }
        }
    }
    
    private func prepareTimer() {
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { (timer: Timer) in
                self.counterView.currentValue += 17
            }
        } else {
            // Fallback on earlier versions
        }
    }

    private func setupCounter() {
        // Add counter view and layout
        view.addSubview(counterView)
        counterView.widthAnchor.constraint(equalToConstant: 260).isActive = true
        counterView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        counterView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        counterView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        counterView.startAnimating()
    }
}
