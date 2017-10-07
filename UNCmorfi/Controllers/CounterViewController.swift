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

            let servingsCount = servings.keys.sorted().reduce(0) { (count, date) -> Int in
                return count + servings[date]!
            }
            counterView.currentValue += 67

            print("Servings count updated to \(servingsCount).")
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
        setupLabel()
        prepareTimer()
    }

    private func setupCounter() {
        // Add counter view and layout
        view.addSubview(counterView)
        counterView.delegate = self

        NSLayoutConstraint.activate([
            counterView.widthAnchor.constraint(equalToConstant: 260),
            counterView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            counterView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            counterView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor),
            ])

        counterView.startAnimating()
    }

    private func setupLabel() {
        view.addSubview(progressLabel)

        NSLayoutConstraint.activate([
            progressLabel.centerXAnchor.constraint(equalTo: counterView.centerXAnchor),
            progressLabel.centerYAnchor.constraint(equalTo: counterView.centerYAnchor),
            ])
    }

    private func prepareTimer() {
        if #available(iOS 10.0, *) {
            // TODO set to 60 seconds.
            timer = Timer.scheduledTimer(withTimeInterval: 6, repeats: true) { (timer: Timer) in
                UNCComedor.getServings { (error: Error?, servings: [Date : Int]?) in
                    guard error == nil else {
                        // TODO this is temporary // Has to be in main queue
                        return
                    }

                    DispatchQueue.main.async {
                        self.servings = servings
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }

    func shouldUpdateLabel() {
        if (progressLabel.alpha == 0) {
            UIView.animate(withDuration: 0.5) {
                self.progressLabel.alpha = 1
            }
        }

        progressLabel.text = "\(counterView.currentValue)"
    }
}
