//
//  File.swift
//  
//
//  Created by Joe Blau on 4/7/21.
//

import Foundation
import StravaSwift
import ComposableArchitecture

public struct StravaManager {
    public enum Action: Equatable {
        case oAuthToken(OAuthToken)
        case athlete(Athlete?)
        case error(Error?)
        case uploadComplete(Result<UploadData.Status?, Error>)
    }
    
    public struct Error: Swift.Error, Equatable {
        public let error: NSError?

        public init(_ error: Swift.Error?) {
            self.error = error as NSError?
        }
    }
    
    public var connectionStatus: (AnyHashable) -> ConnectionStatus = { _ in _unimplemented("connectionStatus") }

    var create: (AnyHashable, StravaConfig, String?) -> Effect<Action, Never> = { _, _, _ in _unimplemented("create") }
    var destroy: (AnyHashable) -> Effect<Never, Never> = { _ in _unimplemented("destroy") }
    var authorize: (AnyHashable) -> Effect<Never, Never> = { _ in _unimplemented("authorize") }
    var handleAuthorization: (AnyHashable, URL) -> Effect<Never, Never> = { _, _ in _unimplemented("handleAuthorization") }
    var refreshAccessToken: (AnyHashable, String) -> Effect<Never, Never> = { _, _ in _unimplemented("refreshAccessToken") }
    var handleAuthorizationRedirect: (AnyHashable, URL) -> Effect<Never, Never> = { _, _ in _unimplemented("handleAuthorizationRedirect") }
    var requestAthlete: (AnyHashable) -> Effect<Never, Never> = { _ in _unimplemented("request") }
    var upload: (AnyHashable, UploadData) -> Effect<Never, Never> = { _, _ in _unimplemented("upload") }
    
    public func create(id: AnyHashable, configuration: StravaConfig, accessToken: String?) -> Effect<Action, Never> {
        create(id, configuration, accessToken)
    }

    public func destroy(id: AnyHashable) -> Effect<Never, Never> {
        destroy(id)
    }

    public func authorize(id: AnyHashable) -> Effect<Never, Never> {
        authorize(id)
    }
    
    public func handleAuthorization(id: AnyHashable, url: URL) -> Effect<Never, Never> {
        handleAuthorization(id, url)
    }

    public func refreshAccessToken(id: AnyHashable, refreshToken: String) -> Effect<Never, Never> {
        refreshAccessToken(id, refreshToken)
    }
    
    public func handleAuthorizationRedirect(id: AnyHashable, url: URL) -> Effect<Never, Never> {
        handleAuthorizationRedirect(id, url)
    }

    public func requestAthlete(id: AnyHashable) -> Effect<Never, Never> {
        requestAthlete(id)
    }
    
    public func upload(id: AnyHashable, uploadData: UploadData) -> Effect<Never, Never> {
        upload(id, uploadData)
    }
}
