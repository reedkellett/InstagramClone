//
//  CommentsView.swift
//  InstagramClone
//
//  Created by Reed Kellett on 8/5/21.
//

import SwiftUI

struct CommentsView: View {
    @State var commentText = ""
    @ObservedObject var viewModel: CommentViewModel
    
    init(post: Post) {
        self.viewModel = CommentViewModel(post: post)
    }
    
    var body: some View {
        VStack {
            // comment cells
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(viewModel.comments) { comment in
                        CommentCell(comment: comment)
                    }
                }
            }.padding(.top)
            
            // input view
            CustomInputView(inputText: $commentText, action: uploadComment)
            
        }
    }
    func uploadComment() {
        viewModel.uploadComment(commentText: commentText)
        commentText = ""
    }
    
}
