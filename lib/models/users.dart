class User {
  final int id;
  final Map<String, dynamic> mainInfo;
  final Map<String, dynamic> additionalInfo;
  final MediaLinks mediaLinks;

  User({
    required this.id,
    required this.mainInfo,
    required this.additionalInfo,
    required this.mediaLinks,
  });

  // Фабричный метод для создания экземпляра User из списка
  factory User.fromList(List<dynamic> data) {
    return User(
      id: data[0],
      mainInfo: data[1],
      additionalInfo: data[2],
      mediaLinks: MediaLinks.fromJson(data[3]),
    );
  }

  // Метод для преобразования экземпляра User в Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'main_info': mainInfo,
      'additional_info': additionalInfo,
      'media_links': mediaLinks.toJson(),
    };
  }
}

class MediaLinks {
  final String? artstation;
  final String? tg;
  final String? vk;
  final String? inst;

  MediaLinks({
    this.artstation,
    this.tg,
    this.vk,
    this.inst,
  });

  // Фабричный метод для создания экземпляра MediaLinks из Map
  factory MediaLinks.fromJson(Map<String, dynamic> json) {
    return MediaLinks(
      artstation: json['artstation'],
      tg: json['tg'],
      vk: json['vk'],
      inst: json['inst'],
    );
  }

  // Метод для преобразования экземпляра MediaLinks в Map
  Map<String, dynamic> toJson() {
    return {
      'artstation': artstation,
      'tg': tg,
      'vk': vk,
      'inst': inst,
    };
  }
}
