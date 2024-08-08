class GuiaEntity {
  final String titleStep;
  final String urlImg;
  final String description;

  GuiaEntity(this.titleStep, this.urlImg, this.description);

  Map<String, dynamic> toMap() {
    return {
      'title_step': titleStep,
      'url_img': urlImg,
      'description': description,
    };
  }

  GuiaEntity.fromMap(Map<String, dynamic> res)
      : titleStep = res["title_step"],
        urlImg = res["url_img"],
        description = res["description"];

  @override
  String toString() {
    return 'guia{title_step: $titleStep, url_img: $urlImg, description: $description}';
  }
}
