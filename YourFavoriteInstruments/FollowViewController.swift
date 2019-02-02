//
//  ViewController.swift
//  YourFavoriteInstruments
//
//  Created by Dean Silfen on 2/2/19.
//  Copyright © 2019 Dean Silfen. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

class FollowViewController: UIViewController {

	private let stackView = UIStackView()
	private let usernameLabel = UILabel()
	private let followersLabel = UILabel()
	private let followedByLabel = UILabel()
	private let followButton = UIButton(type: .roundedRect)
	private let disposeBag = DisposeBag()

	private let viewModel: FollowUserViewModel
	init(viewModel: FollowUserViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		view.backgroundColor = .white
		view.addSubview(stackView)
		stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

		[
			usernameLabel,
			followersLabel,
			followedByLabel,
			followButton
		].forEach { (view) in
				view.translatesAutoresizingMaskIntoConstraints = false
				stackView.addArrangedSubview(view)
		}

		followButton.setTitle("FOLLOW", for: .normal)
		usernameLabel.text = viewModel.name
		navigationItem.title = viewModel.name
		configureBindings()
	}

	func configureBindings() {
		viewModel
			.followCount
			.map { "Followers: \($0)" }
			.bind(to: followersLabel.rx.text)
			.disposed(by: disposeBag)

		viewModel
			.latestFollow
			.map { "Recently Followed By: \($0.name)" }
			.bind(to: followedByLabel.rx.text)
			.disposed(by: disposeBag)

		viewModel
			.canFollow
			.bind(to: followButton.rx.isEnabled)
			.disposed(by: disposeBag)

		followButton
			.rx
			.tap
			.bind(to: viewModel.followUserObserver)
			.disposed(by: disposeBag)
	}
}

