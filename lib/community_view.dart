// community_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'community_model.dart';  
import 'profile_view.dart';
import 'profile_model.dart';

class CommunityView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityModel>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
          ),
          body: ListView.builder(
            itemCount: model.posts.length,
            itemBuilder: (context, index) {
              return PostView(
                post: model.posts[index],
                onLike: () => model.likePost(index),
                onAddComment: (String comment) => model.addComment(index, comment),
                tappedUser: model.users[0], // provide user data
              ); 
            },
          ),
        );
      },
    );
  }
}

class PostView extends StatefulWidget {
  final PostModel post;
  final VoidCallback onLike;
  final Function(String) onAddComment;
  final UserModel tappedUser;

  const PostView({
    required this.post,
    required this.onLike,
    required this.onAddComment,
    required this.tappedUser,
    Key? key,
  }) : super(key: key);

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.post.user.profileImageUrl),
                radius: 25,
              ),
              title: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileView(
                      user: widget.tappedUser,
                    ),
                  ),
                ),
                child: Text(
                  widget.post.user.username,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              subtitle: Text(
                widget.post.dateTime,
                style: TextStyle(fontSize: 12),
              ),
              trailing: IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () => print('More options'),
              ),
            ),
            if (widget.post.postImage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(widget.post.postImage!),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                widget.post.postText,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.favorite_border),
                  onPressed: widget.onLike,
                ),
                Text(
                  '${widget.post.likeCount} Likes',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Add a comment',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                TextButton(
                  child: Text('Post', style: TextStyle(color: Colors.blue)),
                  onPressed: () {
                    widget.onAddComment(_controller.text);
                    _controller.clear();
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.post.comments.take(2).map(
                (comment) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    children: [
                      Text(
                        comment.user.username,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 6.0),
                      Expanded(child: Text(comment.text))
                    ]
                  ),
                )
              ).toList(),
            )
          ],
        ),
      ),
    );
  }
}