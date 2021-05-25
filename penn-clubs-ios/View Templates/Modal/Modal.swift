//
//  Modal.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 20/5/2021.
//

import SwiftUI

enum ModalState: CGFloat {
    case closed, partial, open
    
    func offsetFromTop() -> CGFloat {
        switch self {
        case .closed:
            return UIScreen.main.bounds.height
        case .partial:
            return UIScreen.main.bounds.height * 3/4
        case .open:
            return UIScreen.main.bounds.height * 1/4
        }
    }
}

struct Modal {
    var position: ModalState  = .closed
    var dragOffset: CGSize = .zero
    var content: AnyView?
}

struct ModalAnchorView: View {
    @EnvironmentObject var modalManager: ModalManager
    
    var body: some View {
        ModalView(modal: $modalManager.modal)
    }
}

class ModalManager: ObservableObject {
    
    @Published var modal: Modal = Modal(position: .closed, content: nil)
    
    func newModal<Content: View>(position: ModalState, @ViewBuilder content: () -> Content ) {
        modal = Modal(position: position, content: AnyView(content()))
    }
    
    func openModal() {
        modal.position = .partial
    }
    
    func closeModal() {
        modal.position = .closed
    }
    
}


struct ModalView: View {
    
    // Modal State
    @Binding var modal: Modal
    @GestureState var dragState: DragState = .inactive
    
    var animation: Animation {
        Animation
            .interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0)
            .delay(0)
    }
    
    var body: some View {
        
        let drag = DragGesture(minimumDistance: 30)
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation:  drag.translation)
            }
            .onChanged {
                self.modal.dragOffset = $0.translation
            }
            .onEnded(onDragEnded)
        
        return GeometryReader(){ geometry in
            ZStack(alignment: .top) {
                Color.black
                    .opacity(self.modal.position != .closed ? 0.5 : 0)
                    .onTapGesture {
                        self.modal.position = .closed
                }
                ZStack(alignment: .top) {
                    Color(UIColor.systemBackground)
                    self.modal.content
                        .frame(height: UIScreen.main.bounds.height - (self.modal.position.offsetFromTop() + geometry.safeAreaInsets.top + self.dragState.translation.height))
                }
                .mask(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .offset(y: max(0, self.modal.position.offsetFromTop() + self.dragState.translation.height + geometry.safeAreaInsets.top))
                .gesture(drag)
                .animation(self.dragState.isDragging ? nil : self.animation)
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    private func onDragEnded(drag: DragGesture.Value) {
        
        // Setting stops
        let higherStop: ModalState
        let lowerStop: ModalState
        
        // Nearest position for drawer to snap to.
        let nearestPosition: ModalState
        
        // Determining the direction of the drag gesture and its distance from the top
        let dragDirection = drag.predictedEndLocation.y - drag.location.y
        let offsetFromTopOfView = modal.position.offsetFromTop() + drag.translation.height
        
        // Determining whether drawer is above or below `.partiallyRevealed` threshold for snapping behavior.
        if offsetFromTopOfView <= ModalState.partial.offsetFromTop() {
            higherStop = .open
            lowerStop = .partial
        } else {
            higherStop = .partial
            lowerStop = .closed
        }
        
        // Determining whether drawer is closest to top or bottom
        if (offsetFromTopOfView - higherStop.offsetFromTop()) < (lowerStop.offsetFromTop() - offsetFromTopOfView) {
            nearestPosition = higherStop
        } else {
            nearestPosition = lowerStop
        }
        
        // Determining the drawer's position.
        if dragDirection > 0 {
            modal.position = lowerStop
        } else if dragDirection < 0 {
            modal.position = higherStop
        } else {
            modal.position = nearestPosition
        }   
    }
}

enum DragState {

    case inactive
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}
