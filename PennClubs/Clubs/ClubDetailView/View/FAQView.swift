//
//  FaqView.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 23/7/2021.
//

import SwiftUI

struct FaqView: View {
    let questionAnswers: [QuestionAnswer]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                ForEach(questionAnswers.filter({$0.approved && $0.answer != nil}), content: QuestionAnswerRow.init)
            }.padding()
        }
    }
}

struct FAQView_Previews: PreviewProvider {
    static var previews: some View {
        let test: [QuestionAnswer] = Bundle.main.decode("q+a.json")
        return FaqView(questionAnswers: test).preferredColorScheme(.dark).padding(.horizontal, 20)
    }
}

struct QuestionAnswerRow: View {
    let questionAnswer: QuestionAnswer
    @State var isExpanded = false

    init(for questionAnswer: QuestionAnswer) {
        self.questionAnswer = questionAnswer
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(questionAnswer.question)
                    
                    HStack {
                        Spacer()
                        Text("-\(questionAnswer.author)")
                            .font(.system(.caption))
                            .fontWeight(.light)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .rotation3DEffect(.degrees(isExpanded ? 180 : 0), axis: (1, 0, 0))
            }
            .fixedSize(horizontal: false, vertical: true)
            .onTapGesture {
                withAnimation {
                    isExpanded.toggle()
                }
            }
            
            if isExpanded {
                Text(questionAnswer.answer!)
                    .fontWeight(.light)
            }
        }
        .clipped()
    }
}
