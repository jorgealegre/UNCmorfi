//
// Copyright © 2019 George Alegre. All rights reserved.
//

import UIKit
import TinyConstraints

class CounterViewController: UIViewController {

    // MARK: - Views

    private let counterView = CounterView(frame: .zero)

    private let progressLabel: UILabel = {
        let label = UILabel()
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

        setupUI()

        if UserDefaults.standard.bool(forKey: "FASTLANE_SNAPSHOT") {
            counterView.currentValue = 1342
            progressLabel.text = "1342"
            progressLabel.alpha = 1
        } else {
            updateServings()
            prepareTimer()
        }
    }

    private func setupUI() {
        // Hierarchy
        view.addSubviews(counterView, progressLabel)

        // Layout
        counterView.widthToSuperview(multiplier: 0.8)
        counterView.heightToWidth(of: counterView)
        counterView.centerInSuperview()
        progressLabel.centerInSuperview()

        // Configuration
        setProgressLabelFont()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        navigationItem.title = "counter.nav.label".localized()
        navigationController!.navigationBar.prefersLargeTitles = true

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

    // MARK: - Environment changes

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        // For some reason, the label's font size doesn't update automatically.
        // We have to get the new size once the trait collection changed.
        setProgressLabelFont()
    }

    private func setProgressLabelFont() {
        let fontSize = UIFont.preferredFont(forTextStyle: .title1).pointSize
        if #available(iOS 12.0, *) {
            progressLabel.font = UIFont.monospacedSystemFont(ofSize: fontSize, weight: .bold)
        } else {
            progressLabel.font = UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .bold)
        }
    }
}
