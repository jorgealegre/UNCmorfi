//
// Copyright © 2020 George Alegre. All rights reserved.
//

protocol Navigator {
    associatedtype Destination

    func navigate(to destination: Destination)
}
