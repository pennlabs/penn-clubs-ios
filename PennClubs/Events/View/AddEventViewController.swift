//
//  AddEventViewController.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 24/8/2021.
//

import UIKit
import EventKit
import EventKitUI
class AddEventViewController: EKEventEditViewController  {
    var clubEvent: Event
    
    init(for clubEvent: Event) {
        self.clubEvent = clubEvent
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        DispatchQueue.main.async {
            self.eventStore = EKEventStore()
            let event = EKEvent(eventStore: self.eventStore)
            event.title = self.clubEvent.name
            event.startDate = self.clubEvent.startTime
            
            if let eventURL = self.clubEvent.url {
                event.url = URL(string: eventURL)
            }
            
            event.endDate = self.clubEvent.endTime
            event.notes = self.clubEvent.description
            self.event = event
//        }
        
        
        
//        self.event = event
//        eventStore.requestAccess( to: EKEntityType.event, completion:{(granted, error) in
//            DispatchQueue.main.async {
//                if (granted) && (error == nil) {
//                    self.viewWillAppear(true)
//                    let event = EKEvent(eventStore: self.eventStore)
//                    event.title = self.clubEvent.name
//                    event.startDate = self.clubEvent.startTime
//
//                    if let eventURL = self.clubEvent.url {
//                        event.url = URL(string: eventURL)
//                    }
//
//                    event.endDate = self.clubEvent.endTime
//                    event.notes = self.clubEvent.description
//
//                    self.event = event
//                }
//            }
//        })
    }
}
