class Room {
  int id;
  String roomId;
  String roomName;
  String subject;

  Room({
    required this.id,
    required this.roomId,
    required this.roomName,
    required this.subject,
  });
}

final rooms = <Room>[
  Room(
    id: 1,
    roomId: "circle_3cb4a823-0b2c-4406-a0b3-79d8898e8831",
    roomName: "Gravity Guru",
    subject: "Physics",
  ),
  Room(
    id: 2,
    roomId: "circle_f8aee7c8-0944-479f-bfbe-55e1fc53acb5",
    roomName: "Bio Brains",
    subject: "Biology",
  ),
  Room(
    id: 3,
    roomId: "circle_3cb4a823-0b2c-4406-a0b3-79d8898e8831",
    roomName: "Only Inorganic Chem",
    subject: "Chemistry",
  ),
  Room(
    id: 1,
    roomId: "circle_3cb4a823-0b2c-4406-a0b3-79d8898e8831",
    roomName: "Gravity Guru",
    subject: "Physics",
  ),
  Room(
    id: 2,
    roomId: "circle_f8aee7c8-0944-479f-bfbe-55e1fc53acb5",
    roomName: "Bio Brains",
    subject: "Biology",
  ),
  Room(
    id: 3,
    roomId: "circle_3cb4a823-0b2c-4406-a0b3-79d8898e8831",
    roomName: "Only Inorganic Chem",
    subject: "Chemistry",
  ),
];
