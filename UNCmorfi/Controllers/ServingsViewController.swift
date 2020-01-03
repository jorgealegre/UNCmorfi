//
// Copyright © 2019 George Alegre. All rights reserved.
//

import UIKit
import TinyConstraints
import ProgressIndicatorView
import UNCmorfiKit

class ServingsViewController: UIViewController {

    // MARK: - Views

    private let progressIndicatorView = ProgressIndicatorView(frame: .zero)

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
            progressIndicatorView.currentValue = currentCount
            
            if (progressLabel.alpha == 0) {
                UIView.animate(withDuration: 0.5) {
                    self.progressLabel.alpha = 1
                }
            }

            progressLabel.text = String(currentCount)
        }
    }

    private var timer: Timer!

    private let feedbackGenerator = UINotificationFeedbackGenerator()

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        guard !Settings.capturingScreenshots else {
            progressIndicatorView.currentValue = 1342
            progressLabel.text = "1342"
            progressLabel.alpha = 1
            return
        }

        progressIndicatorView.startAnimating()
        updateServings()
        prepareTimer()
    }

    private func setupUI() {
        // Hierarchy
        view.addSubviews(progressIndicatorView, progressLabel)

        // Layout
        progressIndicatorView.widthToSuperview(multiplier: 0.8)
        progressIndicatorView.heightToWidth(of: progressIndicatorView)
        progressIndicatorView.centerInSuperview()
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
    }

    private func updateServings() {
        feedbackGenerator.prepare()

        URLSession.shared.load(.servings) { result in
            switch result {
            case let .success(servings):
                DispatchQueue.main.async {
                    self.servings = servings.servings
                    self.feedbackGenerator.notificationOccurred(.success)
                }
            case .failure:
                self.feedbackGenerator.notificationOccurred(.error)
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
