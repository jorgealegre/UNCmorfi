//
//  InfoViewController.swift
//  UNCmorfi
//
//  Created by George Alegre on 9/10/17.
//
//  LICENSE is at the root of this project's repository.
//

import UIKit

class InfoViewController: UITableViewController {
    private var data: [(isHidden: Bool, datum: Information)] = [
        (isHidden: true, datum: .development),
        (isHidden: true, datum: .design),
        (isHidden: true, datum: .balanceMenuServingsSource),
        (isHidden: true, datum: .cameraLocationPermissions),
        (isHidden: true, datum: .colaborate),
        (isHidden: true, datum: .getInTouch),
        (isHidden: true, datum: .android)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = NSLocalizedString("info.nav.label", comment: "Information")
        if #available(iOS 11.0, *) {
            navigationController!.navigationBar.prefersLargeTitles = true
        }

        // Cell setup.
        tableView.register(InfoCell.self, forCellReuseIdentifier: InfoCell.reuseIdentifier)

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].isHidden ? 0 : 1
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = InfoCellHeader()
        let info = data[section].datum
        
        view.configureFor(info: info)
        view.tag = section
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(headerTapped)))

        return view
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoCell.reuseIdentifier, for: indexPath) as? InfoCell else {
            fatalError("The dequeued cell is not an instance of InfoCell.")
        }

        let info = data[indexPath.section].datum
        cell.configureFor(info: info)

        return cell
    }

    @objc private func headerTapped(recognizer: UITapGestureRecognizer) {
        // Toggle the visibility of the cell inside the section.
        let section = recognizer.view!.tag

        data[section].isHidden = !data[section].isHidden

        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
}
