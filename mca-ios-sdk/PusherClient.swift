//
//  PusherClient.swift
//  mca-ios-sdk
//
//  Created by mycover Mobile on 17/02/2023.
//

import Foundation
import PusherSwift

func listenForPaymentUpdate(ref: String) {
    
    print("reference \(ref)")
    
    let options = PusherClientOptions(
      host: .cluster("us2")
      )
    
    
      let pusher = Pusher(key: PUSHER_APP_KEY, options: options)
    
    
    
    
    let channel = pusher.subscribe(channelName: "cache-\(ref.trimmingCharacters(in: .whitespacesAndNewlines))")

    print(channel.name)
    
     channel.bind(eventName: "transaction_successful", eventCallback: {
        pusherEvent in
        
        print("\(pusherEvent.description)")
        print("\(pusherEvent.channelName ?? "event received")")
    })
    
    pusher.connect()
}
