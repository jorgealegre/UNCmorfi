//
// Copyright © 2019 George Alegre. All rights reserved.
//

import UIKit

class InfoViewController: UITableViewController {

    // MARK: - Properties

    private var data: [(isHidden: Bool, datum: Information)] = Information.allCases.map { (true, $0) }

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = NSLocalizedString("info.nav.label", comment: "Information")
        navigationController!.navigationBar.prefersLargeTitles = true

        // Cell setup.
        tableView.register(InfoCell.self, forCellReuseIdentifier: InfoCell.reuseIdentifier)
        tableView.register(InfoCellHeader.self, forHeaderFooterViewReuseIdentifier: InfoCellHeader.reuseID)

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        tableView.sectionHeaderHeight = 50
        
        // Remove empty row separators below the table view.
        tableView.tableFooterView = UIView()
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].isHidden ? 0 : 1
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: InfoCellHeader.reuseID) as! InfoCellHeader

        let info = data[section].datum
        
        view.configureFor(info: info)
        view.tag = section
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(headerTapped)))

        return view
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InfoCell.reuseIdentifier, for: indexPath) as! InfoCell

        let info = data[indexPath.section].datum
        cell.configureFor(info: info)

        return cell
    }

    // MARK: - Actions

    @objc private func headerTapped(recognizer: UITapGestureRecognizer) {
        // Toggle the visibility of the cell inside the section.
        let section = recognizer.view!.tag

        data[section].isHidden.toggle()

        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
}
