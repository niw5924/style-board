import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:style_board/auth/auth_provider.dart';

class FriendService {
  static Future<String?> sendFriendRequest(
    BuildContext context,
    String name,
    String tag,
  ) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final currentUser = authProvider.user!;
      final currentUserName = currentUser.displayName!;
      final currentUserTag = authProvider.userTag!;

      // 자신의 이름과 태그가 동일한 경우 요청 차단
      if (name == currentUserName && tag == currentUserTag) {
        return '자신에게 친구 요청을 보낼 수 없습니다.';
      }

      final senderId = currentUser.uid;
      final senderData = {
        'name': currentUser.displayName,
        'photoURL': currentUser.photoURL,
        'tag': currentUserTag,
      };

      // 태그를 통해 수신자 검색
      final receiverQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('userInfo.name', isEqualTo: name)
          .where('userInfo.tag', isEqualTo: tag)
          .get();

      if (receiverQuery.docs.isEmpty) {
        return '해당 태그의 사용자를 찾을 수 없습니다.';
      }

      final receiverDoc = receiverQuery.docs.first;
      final receiverId = receiverDoc.id;

      // 이미 친구로 등록된 상태인지 확인
      final isAlreadyFriend = await FirebaseFirestore.instance
          .collection('users')
          .doc(senderId)
          .collection('friends')
          .doc(receiverId)
          .get();

      if (isAlreadyFriend.exists) {
        return '이미 친구로 등록된 사용자입니다.';
      }

      // 이미 친구 요청을 보냈는지 확인
      final isAlreadyRequested = await FirebaseFirestore.instance
          .collection('users')
          .doc(senderId)
          .collection('friendRequestsSent')
          .doc(receiverId)
          .get();

      if (isAlreadyRequested.exists) {
        return '이미 친구 요청을 보냈습니다.';
      }

      // 발신자의 요청 목록에 추가
      await FirebaseFirestore.instance
          .collection('users')
          .doc(senderId)
          .collection('friendRequestsSent')
          .doc(receiverId)
          .set({
        'name': receiverDoc['userInfo']['name'],
        'photoURL': receiverDoc['userInfo']['photoURL'],
        'tag': receiverDoc['userInfo']['tag'],
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 수신자의 요청 목록에 추가
      await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .collection('friendRequestsReceived')
          .doc(senderId)
          .set({
        'name': senderData['name'],
        'photoURL': senderData['photoURL'],
        'tag': senderData['tag'],
        'timestamp': FieldValue.serverTimestamp(),
      });

      return null; // 성공
    } catch (e) {
      debugPrint('친구 요청 전송 실패: $e');
      return '요청 전송 중 오류가 발생했습니다.';
    }
  }

  // 친구 요청 수락
  static Future<void> acceptFriendRequest(
    BuildContext context,
    String requesterId,
  ) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final currentUser = authProvider.user!;
      final currentUserId = currentUser.uid;

      // 요청자 정보 가져오기
      final requesterDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(requesterId)
          .get();

      final requesterData = requesterDoc.data()!;

      // 현재 유저 정보 가져오기
      final currentUserDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .get();

      final currentUserData = currentUserDoc.data()!;

      // 서로 친구 목록에 추가
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('friends')
          .doc(requesterId)
          .set({
        'name': requesterData['userInfo']['name'],
        'photoURL': requesterData['userInfo']['photoURL'],
        'tag': requesterData['userInfo']['tag'],
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(requesterId)
          .collection('friends')
          .doc(currentUserId)
          .set({
        'name': currentUserData['userInfo']['name'],
        'photoURL': currentUserData['userInfo']['photoURL'],
        'tag': currentUserData['userInfo']['tag'],
      });

      // 요청 삭제
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('friendRequestsReceived')
          .doc(requesterId)
          .delete();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(requesterId)
          .collection('friendRequestsSent')
          .doc(currentUserId)
          .delete();
    } catch (e) {
      debugPrint('친구 요청 수락 실패: $e');
    }
  }

  // 친구 요청 거절
  static Future<void> rejectFriendRequest(
    BuildContext context,
    String requesterId,
  ) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final currentUser = authProvider.user!;
      final currentUserId = currentUser.uid;

      // 요청 삭제
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('friendRequestsReceived')
          .doc(requesterId)
          .delete();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(requesterId)
          .collection('friendRequestsSent')
          .doc(currentUserId)
          .delete();
    } catch (e) {
      debugPrint('친구 요청 거절 실패: $e');
    }
  }

  // 친구 삭제
  static Future<void> deleteFriend(
    BuildContext context,
    String friendId,
  ) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final currentUser = authProvider.user!;
      final currentUserId = currentUser.uid;

      // 현재 유저의 friends 컬렉션에서 친구 삭제
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('friends')
          .doc(friendId)
          .delete();

      // 친구의 friends 컬렉션에서도 현재 유저 삭제
      await FirebaseFirestore.instance
          .collection('users')
          .doc(friendId)
          .collection('friends')
          .doc(currentUserId)
          .delete();
    } catch (e) {
      debugPrint('친구 삭제 실패: $e');
    }
  }
}
