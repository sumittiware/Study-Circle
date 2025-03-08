import 'dart:convert';

class SubmitMessageRequest {
  final String groupId;
  final String text;
  final bool sendToAllie;

  SubmitMessageRequest({
    required this.groupId,
    required this.text,
    required this.sendToAllie,
  });

  // Factory method to create an instance from JSON
  factory SubmitMessageRequest.fromJson(Map<String, dynamic> json) {
    return SubmitMessageRequest(
      groupId: json['group_id'] as String,
      text: json['text'] as String,
      sendToAllie: json['send_to_allie'] as bool,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {'group_id': groupId, 'text': text, 'send_to_allie': sendToAllie};
  }

  // Optional: Convert JSON string to `Message` object
  static SubmitMessageRequest fromJsonString(String jsonString) {
    return SubmitMessageRequest.fromJson(jsonDecode(jsonString));
  }

  // Optional: Convert `Message` object to JSON string
  String toJsonString() {
    return jsonEncode(toJson());
  }
}

class ChatMessage {
  final String id;
  final String messageType;
  final MessageDetails message;
  final CtaDetails? ctaDetails;
  final List<UserRank>? leaderBoardDetail;

  ChatMessage({
    required this.id,
    required this.messageType,
    required this.message,
    required this.ctaDetails,
    required this.leaderBoardDetail,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      messageType: json['message_type'] as String,
      message: MessageDetails.fromJson(json['message']),
      ctaDetails:
          json['cta_details'] != null
              ? CtaDetails.fromJson(json['cta_details'])
              : null,
      leaderBoardDetail:
          json['leader_board_details'] != null
              ? List.from(
                json['leader_board_details']['user_ranks']
                  ..map((item) => UserRank.fromJson(item)),
              )
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'MessageType': messageType, 'message': message.toJson()};
  }
}

class MessageDetails {
  final String id;
  final String senderType;
  final String senderId;
  final String senderName;
  final String senderAvatar;
  final int createdAt;
  final String groupId;
  final String text;
  final String messageType;
  final String parentTextMessage;
  final bool isAllieMessage;
  final bool isOwnMessage;
  final SenderDetails senderDetails;

  MessageDetails({
    required this.id,
    required this.senderType,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    required this.createdAt,
    required this.groupId,
    required this.text,
    required this.messageType,
    required this.isAllieMessage,
    required this.isOwnMessage,
    required this.senderDetails,
    required this.parentTextMessage,
  });

  factory MessageDetails.fromJson(Map<String, dynamic> json) {
    return MessageDetails(
      id: json['id'] as String,
      senderType: json['sender_type'] as String,
      senderId: json['sender_id'] as String,
      senderName: json['sender_name'] as String,
      senderAvatar: json['sender_avatar'] as String,
      createdAt: json['created_at'] as int,
      groupId: json['group_id'] as String,
      text: json['text'] as String,
      messageType: json['message_type'] as String,
      isAllieMessage: json['is_allie_message'] as bool,
      isOwnMessage: json['is_own_message'] as bool,
      parentTextMessage: json['parent_message_text'] as String,
      senderDetails: SenderDetails.fromJson(json['sender_details']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_type': senderType,
      'sender_id': senderId,
      'sender_name': senderName,
      'sender_avatar': senderAvatar,
      'created_at': createdAt,
      'group_id': groupId,
      'text': text,
      'message_type': messageType,
      'is_allie_message': isAllieMessage,
      'is_own_message': isOwnMessage,
      'sender_details': senderDetails.toJson(),
    };
  }
}

class SenderDetails {
  final String id;
  final String name;
  final String avatar;

  SenderDetails({required this.id, required this.name, required this.avatar});

  factory SenderDetails.fromJson(Map<String, dynamic> json) {
    return SenderDetails(
      id: json['id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'avatar': avatar};
  }
}

class CtaDetails {
  final String subject;
  final String duration;
  final int questionCount;
  final String ctaText;
  final String ctaUrl;
  final String ctaType;
  final String refId;
  final bool isEnabled;

  CtaDetails({
    required this.subject,
    required this.duration,
    required this.questionCount,
    required this.ctaText,
    required this.ctaUrl,
    required this.ctaType,
    required this.refId,
    required this.isEnabled,
  });

  factory CtaDetails.fromJson(Map<String, dynamic> json) {
    return CtaDetails(
      subject: json['subject'],
      duration: json['duration'],
      questionCount: json['question_count'],
      ctaText: json['cta_text'],
      ctaUrl: json['cta_url'],
      ctaType: json['cta_type'],
      refId: json['ref_id'],
      isEnabled: json['is_enabled'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'duration': duration,
      'question_count': questionCount,
      'cta_text': ctaText,
      'cta_url': ctaUrl,
      'cta_type': ctaType,
      'ref_id': refId,
    };
  }
}

// Model for UserRank
class UserRank {
  final String userId;
  final int rank;
  final int correctAnswers;
  final int totalQuestions;

  UserRank({
    required this.userId,
    required this.rank,
    required this.correctAnswers,
    required this.totalQuestions,
  });

  // Factory constructor to create an instance from JSON
  factory UserRank.fromJson(Map<String, dynamic> json) {
    return UserRank(
      userId: json['user_id'],
      rank: json['rank'],
      correctAnswers: json['correct_answers'],
      totalQuestions: json['total_questions'],
    );
  }

  // Convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'rank': rank,
      'correct_answers': correctAnswers,
      'total_questions': totalQuestions,
    };
  }
}
