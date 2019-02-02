//
//  FollowNetworkHandler.swift
//  YourFavoriteInstruments
//
//  Created by Dean Silfen on 2/2/19.
//  Copyright © 2019 Dean Silfen. All rights reserved.
//

import RxSwift
import UIKit

protocol FollowNetworkHandler {
	func user(_ user: User, wouldLikeToFollow userToBeFollowed: User) -> Observable<Response>
	func followers() -> Observable<[User]>
}
