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
import RxTest

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


		// Create a scheduler that starts at 0
		let scheduler = TestScheduler(initialClock: 0)
		let viewModel = FollowUserViewModel(loggedInUser: testFollower, presentingUser: testUser, networkHandler: mockNetworking, scheduler: scheduler)
		let testCountObserver = scheduler.createObserver(Int.self)
		let testLatestFollowObserver = scheduler.createObserver(User.self)
		let testCanFollowObserver = scheduler.createObserver(Bool.self)

		// Bind just like we did with our subject
		viewModel
			.followCount
			.bind(to: testCountObserver)
			.disposed(by: disposeBag)
		viewModel
			.latestFollow
			.bind(to: testLatestFollowObserver)
			.disposed(by: disposeBag)

		viewModel
			.canFollow
			.bind(to: testCanFollowObserver)
			.disposed(by: disposeBag)

		viewModel.fetch()

		scheduler.start()
		// ensure we only got 1 event
		XCTAssertEqual(testCountObserver.events.count, 1)
		// ensure our only event was the Int 1, the number of followers we have
		XCTAssertEqual(testCountObserver.events[0].value.element!, 1)
		// ensure we only got 1 event
		XCTAssertEqual(testLatestFollowObserver.events.count, 1)
		// ensure the follower we got was the same follower we put in our mock
		XCTAssertEqual(testLatestFollowObserver.events[0].value.element!, testFollower)
		// ensure we only got 1 event
		XCTAssertEqual(testCanFollowObserver.events.count, 1)
		// ensure the view is informed if we can or can't follow this user
		XCTAssertFalse(testCanFollowObserver.events[0].value.element!)
	}
}
