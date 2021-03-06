//
//  FollowUserViewModel.swift
//  YourFavoriteInstruments
//
//  Created by Dean Silfen on 2/2/19.
//  Copyright © 2019 Dean Silfen. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

final class FollowUserViewModel {

	var followUserObserver: AnyObserver<Void> {
		return followSubject.asObserver()
	}

	var name: String {
		return presentingUser.name
	}

	var canFollow: Observable<Bool> {
		let loggedInUser = self.loggedInUser
		return followersSubject
			.map { $0.contains(loggedInUser) }
			.map { !$0 }
			.distinctUntilChanged()
	}

	var followCount: Observable<Int> {
		return followersSubject.map { $0.count }
	}

	var latestFollow: Observable<User> {
		return followersSubject.flatMap { (users) -> Observable<User> in
			if let user = users.last {
				return .just(user)
			} else {
				return .never()
			}
		}
	}

	func fetch() {
		fetchDataSubject.onNext(())
	}

	private let disposeBag = DisposeBag()
	private let followSubject = PublishSubject<Void>()
	// A followers subject for our response to bind incoming
	// payloads to.
	private let followersSubject = ReplaySubject<[User]>.create(bufferSize: 1)
	private let fetchDataSubject = PublishSubject<Void>()
	private let presentingUser: User
	private let loggedInUser: User
	init(loggedInUser: User, presentingUser: User, networkHandler: FollowNetworkHandler) {
		self.presentingUser = presentingUser
		self.loggedInUser = loggedInUser
		let scheduler = SerialDispatchQueueScheduler(
			qos: .userInitiated
		)
		setupBindings(
			loggedInUser: loggedInUser,
			presentingUser: presentingUser,
			scheduler: scheduler,
			networkHandler: networkHandler
		)
	}

	private func setupBindings(loggedInUser: User, presentingUser: User, scheduler: SchedulerType, networkHandler: FollowNetworkHandler) {
		followSubject
			.observeOn(scheduler)
			.flatMapLatest { _ in
				networkHandler.user(loggedInUser, wouldLikeToFollow: presentingUser)
			}
			.map { _ in }
			.bind(to: fetchDataSubject)
			.disposed(by: disposeBag)

		fetchDataSubject
			.flatMapLatest { _ -> Observable<[User]> in
				networkHandler.followers()
			}
			.bind(to: followersSubject)
			.disposed(by: disposeBag)
	}
}
