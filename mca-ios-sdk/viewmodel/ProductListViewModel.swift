//
//  ProductListViewModel.swift
//  mca-ios-sdk

//

import Foundation
import Combine
import SwiftUI


class ProductListViewModel : ObservableObject {
    
    
    
    struct LoadedViewModel: Equatable {

           static func == (lhs: ProductListViewModel.LoadedViewModel, rhs: ProductListViewModel.LoadedViewModel) -> Bool {
               lhs.id == rhs.id
           }

           let id: String
           let data: ProductListResponse
       }
    

    
    @Published private(set) var state: LoadingState<LoadedViewModel> = .idle

        private var postsPublisher: AnyCancellable?

        @State var showErrorAlert = false

        private let networkService: NetworkServiceable

        private var productData: ProductListResponse? = ProductListResponse(responseCode: 0, responseText: "sample response text", data: DataClass(businessDetails: nil, productDetails:   []))
    
    
    init(networkService: NetworkServiceable) {
        self.networkService = networkService
    }
    
    
    func loadData() {

        }
}
