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

    // MARK: - Views

    private let counterView = CounterView(frame: .zero)
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(34)
        label.alpha = 0
        return label
    }()

    // MARK: - Properties

    private var servings: [Date: Int]? = nil {
        didSet {
            guard let servings = servings else { return }

            // Calculate the current count based on the model.
            let currentCount = servings.values.reduce(0, +)
            
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

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        navigationItem.title = "counter.nav.label".localized()
        navigationController!.navigationBar.prefersLargeTitles = true

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
            counterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            counterView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ])

        counterView.startAnimating()
    }

    private func updateServings() {
        UNCComedor.shared.getServings { result in
            switch result {
            case .failure(_):
                return
            case .success(let servings):
                DispatchQueue.main.async {
                    self.servings = servings.servings
                }
            }
        }
    }

    private func prepareTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            self?.updateServings()
        }
    }

    private func setupLabel() {
        view.addSubview(progressLabel)

        NSLayoutConstraint.activate([
            progressLabel.centerXAnchor.constraint(equalTo: counterView.centerXAnchor),
            progressLabel.centerYAnchor.constraint(equalTo: counterView.centerYAnchor),
            ])
    }
}
