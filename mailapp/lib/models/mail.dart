import 'package:meta/meta.dart';

class Mail {
  Mail({
    @required this.id,
    @required this.to,
    @required this.from,
    @required this.date,
    @required this.subject,
    @required this.description,
    @required this.isFavourite,
  });

  final int id;
  final String to;
  final String from;
  final String date;
  final String subject;
  final String description;
  final bool isFavourite;

  Map<String, dynamic> toMap() => {
        'id': id,
        'to': to,
        'from': from,
        'date': date,
        'subject': subject,
        'description': description,
        'isFavourite': isFavourite
      };
  factory Mail.fromMap(Map<String, dynamic> map) => Mail(
      id: map['id'],
      to: map['to'],
      from:map['from'],
      date: map['date'],
      subject: map['subject'],
      description: map['description'],
      isFavourite:
          map['isFavourite'] == 1 || map['isFavourite'] == true ? true : false);
}