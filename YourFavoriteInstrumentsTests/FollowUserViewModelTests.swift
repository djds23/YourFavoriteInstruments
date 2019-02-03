//
//  FollowUserViewModelTests.swift
//  YourFavoriteInstrumentsTests
//
//  Created by Dean Silfen on 2/2/19.
//  Copyright © 2019 Dean Silfen. All rights reserved.
//

import UIKit
import XCTest
import RxSwift

@testable import YourFavoriteInstruments
class FollowerViewModelTest: XCTestCase {
	// retain subscriptions while testing
	let disposeBag = DisposeBag()

	func testFollowersUpdate() {
		let testFollower = User(name: "dean")
		let testUser = User(name: "mike_eagle")
		let mockNetworking = FollowNetworkHandlerMock(
			mockFollowers: [testFollower],
			followResponse: .success
		)
		// set up our ViewModel with the fake network
		let viewModel = FollowUserViewModel(loggedInUser: testFollower, presentingUser: testUser, networkHandler: mockNetworking)

		// Create two publish subjects, these will listen for
		// values that come in after a successful follow
		let testCountSubject = PublishSubject<Int>()
		let testLatestFollowSubject = PublishSubject<User>()
		let testCanFollowSubject = PublishSubject<Bool>()

		// Bind the observables from the ViewModel to our subjects
		viewModel
			.followCount
			.bind(to: testCountSubject)
			.disposed(by: disposeBag)

		viewModel
			.latestFollow
			.bind(to: testLatestFollowSubject)
			.disposed(by: disposeBag)

		viewModel
			.canFollow
			.bind(to: testCanFollowSubject)
			.disposed(by: disposeBag)

		// Create expectations for us to confirm behavior is correct
		let expectCountToBeCorrect = expectation(description: "The correct count was received")
		testCountSubject
			.do(onNext: { count in
				if count == 1 {
					expectCountToBeCorrect.fulfill()
				}
			})
			.subscribe()
			.disposed(by: disposeBag)

		let expectLatestFollow = expectation(description: "The correct latest user was received")
		testLatestFollowSubject
			.do(onNext: { latestFollow in
				if latestFollow == testFollower {
					expectLatestFollow.fulfill()
				}
			})
			.subscribe()
			.disposed(by: disposeBag)

		let expectCanNoLongerFollow = expectation(description: "We inform the view if we can or cannot follow")
		testCanFollowSubject
			.do(onNext: { canFollow in
				if !canFollow {
					expectCanNoLongerFollow.fulfill()
				}
			})
			.subscribe()
			.disposed(by: disposeBag)

		viewModel.fetch()

		// wait for our events to come in and cause our expectations to
		// be fulfilled.
		wait(for: [
			expectCountToBeCorrect,
			expectLatestFollow,
			expectCanNoLongerFollow
		], timeout: 5)
	}
}
