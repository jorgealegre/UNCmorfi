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
    private let counterView = CounterView(frame: CGRect.zero)
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(34)
        label.alpha = 0
        return label
    }()

    // MARK: Properties
    private var servings: [Date: Int]? = nil {
        didSet {
            guard let servings = servings else { return }

            // Calculate the current count based on the model.
            let currentCount = servings.keys.sorted().reduce(0) { (count, date) -> Int in
                return count + servings[date]!
            }
            
            // Update UI.
            counterView.currentValue = currentCount
            
            if (progressLabel.alpha == 0) {
                UIView.animate(withDuration: 0.5) {
                    self.progressLabel.alpha = 1
                }
            }
            progressLabel.text = String(currentCount)
        }
    }

    private var timer: Timer!

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.title = "counter.nav.label".localized()
        if #available(iOS 11.0, *) {
            navigationController!.navigationBar.prefersLargeTitles = true
        }

        setupCounter()
        updateServings()
        prepareTimer()
        setupLabel()
    }

    private func setupCounter() {
        // Add counter view and layout
        view.addSubview(counterView)

        NSLayoutConstraint.activate([
            counterView.widthAnchor.constraint(equalToConstant: 260),
            counterView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            counterView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            counterView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor),
            ])

        counterView.startAnimating()
    }

    private func updateServings() {
        UNCComedor.api.getServings { result in
            switch result {
            case .failure(_):
                return
            case .success(let servings):
                DispatchQueue.main.async {
                    self.servings = servings
                }
            }
        }
    }

    private func prepareTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in self.updateServings() }
    }

    private func setupLabel() {
        view.addSubview(progressLabel)

        NSLayoutConstraint.activate([
            progressLabel.centerXAnchor.constraint(equalTo: counterView.centerXAnchor),
            progressLabel.centerYAnchor.constraint(equalTo: counterView.centerYAnchor),
            ])
    }
}
