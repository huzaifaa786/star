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

final normalLyric = """[ti:If I Didn't Love You]
[ar:Jason Aldean/Carrie Underwood]
[al:If I Didn't Love You]
[by:]
[offset:0]
[00:00.45]If I Didn't Love You - Jason Aldean/Carrie Underwood
[00:02.49]
[00:11.15]I wouldn't mind being alone
[00:12.85]
[00:13.68]I wouldn't keep checking my phone
[00:16.29]Wouldn't take the long way home
[00:18.00]Just to drive myself crazy
[00:20.56]
[00:21.53]I wouldn't be losing sleep
[00:23.27]
[00:24.24]Remembering everything
[00:26.57]Everything you said to me
[00:28.62]Like I'm doing lately
[00:31.10]You you wouldn't be all
[00:34.55]
[00:35.34]All that I want
[00:37.08]
[00:37.82]Baby I can let go
[00:39.45]
[00:40.36]If I didn't love you I'd be good by now
[00:45.28]I'd be better than barely getting by somehow
[00:49.81]
[00:50.77]Yeah it would be easy not to miss you
[00:54.57]Wonder about who's with you
[00:57.20]Turn the want you off
[00:58.61]Whenever I want to
[01:01.21]If I didn't love you
[01:05.26]
[01:06.32]If I didn't love you
[01:09.33]
[01:13.71]I wouldn't still cry sometimes
[01:15.86]
[01:16.51]Wouldn't have to fake a smile
[01:18.26]
[01:18.83]Play it off and tell a lie
[01:20.97]When somebody asked how I've been
[01:24.17]I'd try to find someone new
[01:25.70]Someone new
[01:26.82]It should be something I can do
[01:28.53]I can do
[01:29.37]Baby if it weren't for you
[01:31.22]I wouldn't be in the state that I'm in
[01:33.78]Yeah you
[01:34.37]
[01:35.17]You wouldn't be all
[01:37.10]
[01:37.99]All that I want
[01:39.62]
[01:40.41]Baby I could let go
[01:42.98]If I didn't love you I'd be good by now
[01:47.85]I'd be better than barely getting by somehow
[01:52.47]
[01:53.42]Yeah it would be easy not to miss you
[01:57.14]Wonder about who's with you
[01:59.75]Turn the want you off
[02:01.06]Whenever I want to
[02:03.30]
[02:03.82]If I didn't love you
[02:07.87]
[02:08.91]If I didn't love you
[02:11.08]Oh if I didn't love you
[02:14.59]It wouldn't be so hard to see you
[02:18.05]Know how much I need you
[02:20.68]Wouldn't hate that I still feel like I do
[02:24.26]
[02:24.77]If I didn't love you
[02:26.70]Oh if I didn't love you
[02:30.14]If I didn't love you
[02:32.77]Hmm mm-hmm
[02:34.57]
[02:35.09]If I didn't love you I'd be good by now
[02:39.96]I'd be better than barely getting by somehow
[02:44.88]
[02:45.56]Yeah it would be easy not to miss you
[02:49.33]Wonder about who's with you
[02:51.96]Turn the want you off
[02:53.24]Whenever I want to
[02:56.04]If I didn't love you
[02:59.32]Yeah ayy ayy
[03:01.21]If I didn't love you
[03:03.28]Oh if I didn't love you
[03:06.56]If I didn't love you
[03:09.07]If I didn't love you
[03:11.67]If I didn't love you""";

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
