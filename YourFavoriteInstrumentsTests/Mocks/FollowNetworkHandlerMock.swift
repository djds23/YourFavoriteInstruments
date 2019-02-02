//
//  FollowNetworkHandlerMock.swift
//  YourFavoriteInstrumentsTests
//
//  Created by Dean Silfen on 2/2/19.
//  Copyright © 2019 Dean Silfen. All rights reserved.
//

import UIKit
import RxSwift

@testable import YourFavoriteInstruments
struct FollowNetworkHandlerMock: FollowNetworkHandler {
	let mockFollowers: [User]
	let followResponse: Response

	func user(_ user: User, wouldLikeToFollow userToBeFollowed: User) -> Observable<Response> {
		return .just(followResponse)
	}

	func followers() -> Observable<[User]> {
		return .just(mockFollowers)
	}
}
