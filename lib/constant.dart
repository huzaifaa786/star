// Dart imports:
import 'dart:math';

// Project imports:

/// Note that the userID needs to be globally unique,
final String localUserID = Random().nextInt(100000).toString();

enum LayoutMode {
  defaultLayout,
  full,
  hostTopCenter,
  hostCenter,
  fourPeoples,
}

final String lyricsContent = '''[00:10.27]Dass Putt Tera Head Down Kaston
[00:13.03]Changa Bhala Hassda Si Maun Kaston
[00:15.54]Aa Jehde Darwaje Vich Board Chakki Khade Aa
[00:18.30]Main Changi Tarah Jaanda Aa Kaun Kaston
[00:21.03]Kuch Aithe Chandi Chamkauna Chaunde Ne
[00:23.53]Kuch Tainu Fadd Thalle Launa Chaunde Ne
[00:26.28]Kuch Ek Aaye Aithe Bukhe Fame De
[00:28.79]Naam Laike Tera Agge Aune Chaunde Ne
[00:31.54]Museebat Taan Marda Te Paindi Rehndi Ae
[00:34.03]Dabi Na Tu Duniya Sawaad Laindi Ae
[00:36.78]Naale Jehde Raste Te Tu Turreyan
[00:39.78]Aithe Badnaami High Rate Milugi
[00:42.27]Nit Controversy Create Milugi
[00:45.03]Dharma De Naam Te Debate Milugi
[00:47.55]Sach Bolega Taan Milu 295
[00:50.28]Je Karega Tarakki Putt Hate Milugi
[00:52.78]Nit Controversy Create Milugi
[00:55.53]Dharma De Naam Te Debate Milugi
[00:58.28]Sach Bolega Taan Milu 295
[01:00.77]Je Karega Tarakki Putt Hate Milugi
[01:03.78]Ajj Kayi Bachaun Sabyachar Jutt Ke
[01:06.06]Jana Khana Dinda Ae Vichar Uth Ke
[01:08.79]Injh Lagge Rabb Jivein Hath Khade Kar Gaya
[01:11.54]Padha Jadon Subah Akhbar Uth Ke
[01:14.27]Chup Reh Oh Puttran Ni Bhed Kholide
[01:16.78]Leader Ne Aithe Haqdar Goli De
[01:19.53]Ho Jinna De Jawaka De Na John Te Steve Aa
[01:22.03]Rakhe Bane Phirde Oh Maa Boli De
[01:24.78]Oh Jhooth Mainu Aithon De Fact Ae Vi Ne
[01:27.30]Chor Bande Auron De Samajsevi Ne
[01:30.03]Sach Wala Baana Paa Jo Log Lutt’de
[01:33.03]Sajja Enna Nu Vi Chheti Mate Milugi
[01:35.54]Nit Controversy Create Milugi
[01:38.28]Dharma De Naam Te Debate Milugi
[01:40.78]Sach Bolega Taan Milu 295
[01:43.53]Je Karega Tarakki Putt Hate Milugi
[01:46.28]Nit Controversy Create Milugi
[01:48.78]Dharma De Naam Te Debate Milugi
[01:51.53]Sach Bolega Taan Milu 295
[01:54.29]Je Karega Tarakki Putt Hate Milugi
[01:56.79]Oh Lok Wadde Maarde Aa Bhare Rukhan Te
[01:59.28]Minta Vich Pahuch Jaande
[02:01.79]Maa’wan Kukha Te
[02:02.53]Kaun Kutta Kaun Dalla Kanjar Ae Kaun
[02:04.78]Aithe Certificate Den Facebook’an Te
[02:07.46]Leader Brown De Gaya Aata Enna Nu
[02:10.93]Vote’an Laike Maarde Chapata Enna Nu
[02:13.31]Pata Nahi Zameer Ohdon Kithe Hundi Ae
[02:15.55]Saale Bolde Ni Sharam Da Ghata Enna Nu
[02:18.04]Digde Nu Den Log Taali Rakhte
[02:21.06]Oh Kadhde Ki Gaala Aithe Dhadi Rakh Ke
[02:23.54]Oh Teri Atte Ohdi Maa Ch Fark Ae Ki
[02:26.07]Akkal Ehna Nu Thodi Late Milugi
[02:28.79]Nit Controversy Create Milugi
[02:31.54]Dharma De Naam Te Debate Milugi
[02:34.29]Sach Bolega Taan Milu 295
[02:37.05]Je Karega Tarakki Putt Hate Milugi
[02:39.79]Tu Hunn Tak Agge Tere Dum Karke
[02:42.29]Aithe Photo Ni Khichaunda
[02:43.54]Koyi Chamm Karke
[02:45.05]Kaun Kinna Rabb Ch Yakeen Rakhda
[02:47.55]Lok Karde Ae Judge Ohde Kamm Karke
[02:50.05]Tu Jhukeya Zaroor Hoya Kodda Taan Nahi
[02:52.80]Pagg Tere Sirr Te Tu Road’an Taan Nahi
[02:55.29]Ik Gall Pooch Enna Thekedar’an Nu
[02:58.05]Sadda Vi Ae Panth Kalla Thodda Taan Ni
[03:00.79]Oh Gandiyan Siyasatan Nu Dilon Kadh Do
[03:03.54]Ho Kise Nu Taan Guru Ghar Jogga Chhad Do
[03:06.29]Ho Kise Bache Sir Nahio Case Labhne
[03:08.79]Nai Taan Thonnu Chheti Aisi Date Milugi
[03:11.57]Nit Controversy Create Milugi
[03:14.05]Dharma De Naam Te Debate Milugi
[03:16.80]Sach Bolega Taan Milu 295
[03:19.31]Je Karega Tarakki Putt Hate Milugi
[03:22.54]Media Kayi Bann Baithe Ajj De Gawaar
[03:25.04]Ikko Jhooth Bolde Aa Oh Vi Baar Baar
[03:27.56]Baith Ke Jananiya Naal Karde Aa Chugliyan
[03:30.30]Te Sudha Naam Rakhde Aa Judge Da Vichar
[03:32.79]Shaam Te Sawere Paalde Vivad Ne
[03:35.55]Aivein Tere Naal Karde Fasaad Ne
[03:38.30]24 Ghante Naale Neend De Prahune Nu
[03:41.05]Naale Ohde Kalle Kalle Geet Yaad Ne
[03:43.55]Bhavein Aukhi Hoyi Ae Crowd Tere Te
[03:46.29]Bolde Ne Aivein Saale Loud Tere Te
[03:49.04]Par Ik Gall Rakhi Yaad Puttra
[03:51.54]Aaha Bapu Tera Bada Aa Proud Tere Te
[03:54.30]Tu Dabb Gaya Duniya Ne Veham Paaleya
[03:56.80]Uth Putt Jhoteya Oye Moose Waleya
[03:59.54]Je Aivein Reha Geetan Vich Sach Bolda
[04:02.29]Aaun Wali Peedhi Educate Milugi
[04:04.83]Nit Controversy Create Milugi
[04:07.55]Dharma De Naam Te Debate Milugi
[04:10.30]Sach Bolega Taan Milu 295
[04:12.80]Je Karega Tarakki Putt Hate Milugi''';

final normalLyric = """[ti: Love Me Like You Do]
[length:04:12.71]
[re:www.megalobiz.com/lrc/maker]
[ve:v1.2.3]
[00:0.00] Love Me Like You Do
[00:05.00]Ellie Goulding
[00:10.00]
[00:15.00]
[00:19.39]You're the light, you're the night
[00:22.54]You're the colour of my blood
[00:24.42]You're the cure, you're the pain
[00:27.17]You're the only thing I wanna touch
[00:31.92]Never knew that it could mean so much,
[00:36.31]so much
[00:39.20]
[00:39.84]You're the fear, I don't care
[00:42.47]'Cause I've never been so high
[00:44.87]Follow me to the dark
[00:47.12]Let me take you past our satellites
[00:52.51]You can see the world you brought to life,
[00:56.76]to life
[00:58.65]
[01:00.05]So love me like you do, lo-lo-love me like you do
[01:04.68]Love me like you do, lo-lo-love me like you do
[01:10.18]Touch me like you do, to-to-touch me like you do
[01:16.43]What are you waiting for?
[01:19.83]Fading in, fading out
[01:22.83]On the edge of paradise
[01:25.33]Every inch of your skin is a holy grail I've got to find
[01:32.59]Only you can set my heart on fire, on fire
[01:39.08]
[01:39.48]Yeah, I'll let you set the pace
[01:45.13]'Cause I'm not thinking straight
[01:50.52]My head's spinning around I can't see clear no more
[01:57.52]What are you waiting for?
[02:00.77]Love me like you do, lo-lo-love me like you do (like you do)
[02:06.42]Love me like you do, lo-lo-love me like you do
[02:10.32]Touch me like you do, to-to-touch me like you do
[02:17.24]What are you waiting for?
[02:21.13]Love me like you do, lo-lo-love me like you do (like you do)
[02:26.64]Love me like you do, lo-lo-love me like you do (yeah)
[02:31.13]Touch me like you do, to-to-touch me like you do
[02:37.38]What are you waiting for?
[02:41.38]
[02:51.14]I'll let you set the pace
[02:56.55]'Cause I'm not thinking straight
[03:00.70]My head's spinning around I can't see clear no more
[03:10.21]What are you waiting for?
[03:13.84]Love me like you do, lo-lo-love me like you do (like you do)
[03:19.59]Love me like you do, lo-lo-love me like you do (yeah)
[03:24.09]Touch me like you do, to-to-touch me like you do
[03:31.23]What are you waiting for?
[03:34.73]Love me like you do, lo-lo-love me like you do (like you do)
[03:39.62]Love me like you do, lo-lo-love me like you do (oh)
[03:44.77]Touch me like you do, to-to-touch me like you do
[03:51.77]What are you waiting for?
""";

extension LayoutModeExtension on LayoutMode {
  String get text {
    final mapValues = {
      LayoutMode.defaultLayout: 'default',
      LayoutMode.full: 'full',
      LayoutMode.hostTopCenter: 'host top center',
      LayoutMode.hostCenter: 'host center',
      LayoutMode.fourPeoples: 'four peoples',
    };

    return mapValues[this]!;
  }
}
