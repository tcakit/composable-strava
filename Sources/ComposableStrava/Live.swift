//
//  File.swift
//  
//
//  Created by Joe Blau on 4/7/21.
//

import Foundation
import StravaSwift
import ComposableArchitecture
import Combine

public extension StravaManager {
    static let live: StravaManager = { () -> StravaManager in
        var manager = StravaManager()

        manager.connectionStatus = { id in
            return dependencies[id]?.connectionStatus ?? .disconnected
        }
        
        manager.create = { id, configuration, _ in
            Effect.run { subscriber in
                dependencies[id] = Dependencies(stravaClient: StravaClient.sharedInstance.initWithConfig(configuration),
                                                subscriber: subscriber)
                return AnyCancellable {
                    dependencies[id] = nil
                }
            }
        }

        manager.destroy = { id in
            .fireAndForget {
                dependencies[id] = nil
            }
        }

        manager.authorize = { id in
            .fireAndForget {
                dependencies[id]?.stravaClient.authorize(result: { result in
                    switch result {
                    case let .success(accessToken):
                        dependencies[id]?.subscriber.send(.accessToken(accessToken))
                    case let .failure(error):
                        dependencies[id]?.subscriber.send(.error(Error(error)))
                    }
                })
            }
        }
        
        manager.handleAuthorization = { id, url in
            .fireAndForget {
                dependencies[id]?.stravaClient.handleAuthorizationRedirect(url)
            }
        }

        manager.refreshAccessToken = { id, refreshToken in
            .fireAndForget {
                dependencies[id]?.stravaClient.refreshAccessToken(refreshToken, result: { result in
                    switch result {
                    case let .success(accessToken):
                        dependencies[id]?.subscriber.send(.accessToken(accessToken))
                    case let .failure(error):
                        dependencies[id]?.subscriber.send(.error(Error(error)))
                    }
                })
            }
        }

        manager.request = { id, athlete in
            .fireAndForget {
                dependencies[id]?.stravaClient.request(Router.athlete) { athlete in
                    dependencies[id]?.subscriber.send(.athlete(athlete))
                } failure: { error in
                    dependencies[id]?.subscriber.send(.error(Error(error)))
                }
            }
        }
        
        manager.upload = { id, uploadData in
            .fireAndForget {
                dependencies[id]?.stravaClient.upload(.uploadFile(upload: uploadData), upload: uploadData) { (status: UploadData.Status?) in
                    dependencies[id]?.subscriber.send(.uploadComplete(.success(status)))
                    
                } failure: { error in
                    dependencies[id]?.subscriber.send(.uploadComplete(.failure(Error(error))))
                }
            }
        }
        
        

        return manager
    }()
}

private struct Dependencies {
    var connectionStatus: ConnectionStatus = .disconnected
    var stravaClient: StravaClient
    let subscriber: Effect<StravaManager.Action, Never>.Subscriber
}

private var dependencies: [AnyHashable: Dependencies] = [:]

private class StravaManagerDelegate: NSObject {
    let subscriber: Effect<StravaManager.Action, Never>.Subscriber

    init(_ subscriber: Effect<StravaManager.Action, Never>.Subscriber) {
        self.subscriber = subscriber
    }
}
