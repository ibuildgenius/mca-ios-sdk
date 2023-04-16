//
//  LoadingState.swift
//  mca-ios-sdk
//
//  Created by mycover Mobile on 24/01/2023.
//

import Foundation


struct ErrorViewModel: Equatable {
    let message: String
}

enum LoadingState<LoadedViewModel: Equatable>: Equatable {
    case idle
    case loading
    case failed(ErrorViewModel)
    case success(LoadedViewModel)
}
