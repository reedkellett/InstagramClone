//
//  FeedCellViewModel.swift
//  InstagramClone
//
//  Created by Reed Kellett on 8/2/21.
//

import SwiftUI

class FeedCellViewModel: ObservableObject {
    @Published var post: Post
    
    var likeString: String {
        let label = post.likes == 1 ? "like" : "likes"
        return "\(post.likes) \(label)"
    }
    
    init(post: Post) {
        self.post = post
        checkIfUserLikedPost()
        fetchPostUser()
    }
    
    func like() {
        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
        guard let postId = post.id else { return }
        
        COLLECTION_POSTS.document(postId).collection("post-likes").document(uid).setData([:]) { _post in
            COLLECTION_USERS.document(uid).collection("user-likes").document(postId).setData([:]) { _post in
                    
                COLLECTION_POSTS.document(postId).updateData(["likes": self.post.likes + 1])
                    
                NotificationsViewModel.uploadNotification(toUid: self.post.ownerUid, type: .like, post: self.post)
                
                self.post.didLike = true
                self.post.likes += 1
            }
        }
    }
    
    func unlike() {
        guard post.likes > 0 else { return }
        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
        guard let postId = post.id else { return }
        
        COLLECTION_POSTS.document(postId).collection("post-likes").document(uid).delete { _post in
            COLLECTION_USERS.document(uid).collection("user-likes").document(postId).delete { _post in
                    
                COLLECTION_POSTS.document(postId).updateData(["likes": self.post.likes - 1])
                                    
                self.post.didLike = false
                self.post.likes -= 1
            }
        }
    }
    
    func checkIfUserLikedPost() {
        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
        guard let postId = post.id else { return }
        
        COLLECTION_USERS.document(uid).collection("user-likes").document(postId).getDocument { snapshot, _ in
            guard let didLike = snapshot?.exists else { return }
            self.post.didLike = didLike
        }
    }
    
    func fetchPostUser() {
        COLLECTION_USERS.document(post.ownerUid).getDocument { snapshot, _ in
            self.post.user = try? snapshot?.data(as: User.self)
        }
    }
}
