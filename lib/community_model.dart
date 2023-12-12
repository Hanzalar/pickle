import 'package:flutter/foundation.dart';

class UserModel {
  final String id;
  final String name;
  final String username;
  final String profileImageUrl;
  final int age;
  final String notes;
  final int wins;
  final int losses;
  final int playerFaults;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.profileImageUrl,
    required this.age,
    required this.notes,
    required this.wins,
    required this.losses,
    required this.playerFaults,
  });
}

class PostModel {
  final UserModel user;
  final String dateTime;
  final String? postImage;
  final String postText;
  int likeCount;
  final List<CommentModel> comments;

  PostModel({
    required this.user,
    required this.dateTime,
    this.postImage,
    required this.postText,
    required this.likeCount,
    required this.comments,
  });
}

class CommentModel {
  final UserModel user;
  final String text;

  CommentModel({
    required this.user,
    required this.text,
  });
}

class CommunityModel extends ChangeNotifier {
  static List<UserModel> generateUsers() {
    return List<UserModel>.generate(10, (index) => UserModel(
        id: '$index',
        name: 'John Doe $index',
        username: 'TheRealJohnDoe$index',
        profileImageUrl: 'https://static.nike.com/a/images/f_auto/dpr_2.0,cs_srgb/w_940,c_limit/9cbde18e-d426-4dbe-9bc9-2d9165605f50/what-is-pickleball-and-how-do-you-play-it.jpg',
        age: 20 + index,
        notes: "Been playing for ${3 + index} years. Just moved to Pittsburgh!",
        wins: 25 + index,
        losses: 10 + index,
        playerFaults: 7 + (index % 3),  // Dummy logic for varying player faults
    ));
  }

  static List<PostModel> generatePosts(List<UserModel> users) {
    return List<PostModel>.generate(10, (index) => PostModel(
      user: users[index],
      dateTime: '1 day ago',
      postImage: 'https://minnevangelist.com/wp-content/uploads/2022/07/pickle-ball-1-1200x900.jpeg' ,  
      postText: 'Post $index: Kenny Picket of Pitt Pickle ball reporting for duty!',
      likeCount: 33 + index,
      comments: [
        CommentModel(user: users[(index + 1) % 10], text: 'Great job John $index'),
        CommentModel(user: users[(index + 2) % 10], text: 'See you on the courts hombre $index'),
        // Add more comments
      ],
    ));
  }

  late List<UserModel> users;
  late List<PostModel> posts;

  CommunityModel() {
    users = generateUsers();
    posts = generatePosts(users);  // now `users` can be referenced since it's already initialized
  }

  void likePost(int postIndex) {
    posts[postIndex].likeCount++;
    notifyListeners();
  }

  void addComment(int postIndex, String comment) {
    posts[postIndex].comments.add(CommentModel(user: users[0], text: comment));
    // Dummy logic to add comment
    notifyListeners();
  }
}