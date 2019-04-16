//
//  MockBeacons.swift
//  visionauts
//
//  Created by Piotr Błachewicz on 19/02/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import Foundation
import Alamofire

enum BeaconsMock: Mockable {
    case getBeacons
    
    var mockSuccess: JsonData {
        switch self {
            
        case .getBeacons:
            return [
                "items" : [
                    [
                        "id": 2,
                        "uuid": "Wgzs",
                        "minor": "27252",
                        "major": "757",
                        "enabled": true,
                        "texts": [
                            [
                                "id": 2,
                                "language": "en",
                                "description": "Kitchen",
                                "created_at": "2019-02-21T10:22:02+00:00",
                                "updated_at": "2019-02-21T10:22:02+00:00"
                            ]
                        ],
                        "created_at": "2019-02-21T10:22:02+00:00",
                        "updated_at": "2019-02-21T10:22:02+00:00"
                    ],
                    [
                        "id": 3,
                        "uuid": "Zxsq",
                        "minor": "37252",
                        "major": "857",
                        "enabled": true,
                        "texts": [
                            [
                                "id": 3,
                                "language": "en",
                                "description": "Hall",
                                "created_at": "2019-02-21T10:22:02+00:00",
                                "updated_at": "2019-02-21T10:22:02+00:00"
                            ]
                        ],
                        "created_at": "2019-02-21T10:22:02+00:00",
                        "updated_at": "2019-02-21T10:22:02+00:00"
                    ]
                ]
            ]
        }
    }
    
    var mockFailure: Error {
        switch self {
            
        case .getBeacons:
            let userInfo = [
                NSLocalizedDescriptionKey : "Timed out for this operation."
            ]
            return NSError(domain: "", code: NSURLErrorTimedOut, userInfo: userInfo)
        }
    }
}
