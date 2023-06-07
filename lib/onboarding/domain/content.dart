class Content {
  String image;
  String title;
  String description;
  Content({
    required this.image,
    required this.title,
    required this.description});
}

List<Content> contents = [
  Content(
      title: 'ADS FREE',
      image: 'images/free.png',
      description: "Pissed off getting interrupted  by ads while playing music? Dag has no ads or any promotion, NO DISTURBANCE  "
  ),
  Content(
      title: 'FREE CONTENT',
      image: 'images/m1.png',
      description: "Get to listen to all your contents for free. No subscription is involved at all "
  ),
  Content(
      title: 'SPEECH TO TEXT',
      image: 'images/tts.png',
      description: "How would you feel if you wouldn't have to type your commands like play? Dag has got that covered that too"
  ),
];
