//
//  DefaultFollowNetworkHandler.swift
//  YourFavoriteInstruments
//
//  Created by Dean Silfen on 2/2/19.
//  Copyright © 2019 Dean Silfen. All rights reserved.
//

import RxSwift
import UIKit

class DefaultFollowNetworkHandler: FollowNetworkHandler {

	private var followingUsers = [
		User(name: "timHarringtonOFFICIAL"),
		User(name: "stingFromThePOLICE"),
		User(name: "downeasterALEXA")
	]

	func followers() -> Observable<[User]> {
		return Observable.of(
			followingUsers
		)
	}

	func user(_ user: User, wouldLikeToFollow userToBeFollowed: User) -> Observable<Response> {
		followingUsers.append(user)
		return .just(.success)
	}
}
