import 'package:cloud_firestore/cloud_firestore.dart';

class StudyGroup {
final String id;
final String name;
final String department;
final String subject;
final String description;
final int memberCount;
final int activeMembers;
final List<String> participants;
final bool isJoined;
final Timestamp createdAt;

StudyGroup({
required this.id,
required this.name,
required this.department,
required this.subject,
required this.description,
required this.memberCount,
required this.activeMembers,
required this.participants,
required this.isJoined,
required this.createdAt,
});

factory StudyGroup.fromFirestore(DocumentSnapshot doc, bool isJoined) {
final data = doc.data() as Map<String, dynamic>;
return StudyGroup(
id: doc.id,
name: data['name'] ?? '',
department: data['department'] ?? '',
subject: data['subject'] ?? '',
description: data['description'] ?? '',
memberCount: data['memberCount'] ?? 0,
activeMembers: data['activeMembers'] ?? 0,
participants: List<String>.from(data['participants'] ?? []),
isJoined: isJoined,
createdAt: data['createdAt'] ?? Timestamp.now(),
);
}

Map<String, dynamic> toFirestore() {
return {
'name': name,
'department': department,
'subject': subject,
'description': description,
'memberCount': memberCount,
'activeMembers': activeMembers,
'participants': participants,
'createdAt': createdAt,
};
}
}

class Message {
final String id;
final String groupId;
final String senderId;
final String senderName;
final String content;
final Timestamp timestamp;
final bool isRead;

Message({
required this.id,
required this.groupId,
required this.senderId,
required this.senderName,
required this.content,
required this.timestamp,
required this.isRead,
});

factory Message.fromFirestore(DocumentSnapshot doc) {
final data = doc.data() as Map<String, dynamic>;
return Message(
id: doc.id,
groupId: data['groupId'] ?? '',
senderId: data['senderId'] ?? '',
senderName: data['senderName'] ?? '',
content: data['content'] ?? '',
timestamp: data['timestamp'] ?? Timestamp.now(),
isRead: data['isRead'] ?? false,
);
}

Map<String, dynamic> toFirestore() {
return {
'groupId': groupId,
'senderId': senderId,
'senderName': senderName,
'content': content,
'timestamp': timestamp,
'isRead': isRead,
};
}
}
