//
//  MultiSelectionView.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 18/7/2021.
//

import SwiftUI

struct MultiSelectionView<Selectable: Identifiable & Hashable>: View {
    let title: String
    let options: [Selectable]
    let optionToString: (Selectable) -> String

    @Binding var selected: Set<Selectable>

    var body: some View {
        List {
            ForEach(options) { selectable in
                Button(action: { toggleSelection(selectable: selectable) }) {
                    HStack {
                        Text(optionToString(selectable)).foregroundColor(.primary)
                        Spacer()
                        if selected.contains(selectable) {
                            Image(systemName: "checkmark").foregroundColor(.accentColor)
                        }
                    }
                }
            }
        }
        .navigationTitle(Text(title))
        .listStyle(GroupedListStyle())
    }

    private func toggleSelection(selectable: Selectable) {
        if (selected.contains(selectable)) {
            selected.remove(selectable)
        } else {
            selected.insert(selectable)
        }
    }
}
