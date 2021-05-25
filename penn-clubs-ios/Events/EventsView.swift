//
//  EventsView.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 19/5/2021.
//

import SwiftUI

struct EventsView: View {
    @EnvironmentObject var modalManager: ModalManager
    
    var body: some View {
       return VStack(){
          Button(action: self.modalManager.openModal) {
             Text("Open Modal")
          }
       }
       .onAppear {
           self.modalManager.newModal(position: .closed) {
               Text("Modal Content")
                    .background(Color.white)
           }
       }
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
    }
}
