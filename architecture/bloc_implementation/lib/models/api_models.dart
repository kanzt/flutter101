class ApiResult {
  late int page;
  late int totalPages;
  late int totalResults;
  late String type;
  late int count;
  late List<Players> items = [];

  ApiResult(
      {required this.page,
        required this.totalPages,
        required this.totalResults,
        required this.type,
        required this.count,
        required this.items});

  ApiResult.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    totalPages = json['totalPages'];
    totalResults = json['totalResults'];
    type = json['type'];
    count = json['count'];
    if (json['items'] != null) {
      items = <Players>[];
      json['items'].forEach((v) {
        items.add(Players.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['totalPages'] = totalPages;
    data['totalResults'] = totalResults;
    data['type'] = type;
    data['count'] = count;
    data['items'] = items.map((v) => v.toJson()).toList();
    return data;
  }
}

class Players {
  late String? commonName;
  late String? firstName;
  late String? lastName;
  late League? league;
  late Nation? nation;
  late Club? club;
  late Headshot? headshot;
  late String? position;
  late int? composure;
  late String? playStyle;
  late dynamic playStyleId;
  late int? height;
  late int? weight;
  late String? birthdate;
  late int? age;
  late int? acceleration;
  late int? aggression;
  late int? agility;
  late int? balance;
  late int? ballcontrol;
  late String? foot;
  late int? skillMoves;
  late int? crossing;
  late int? curve;
  late int? dribbling;
  late int? finishing;
  late int? freekickaccuracy;
  late int? gkdiving;
  late int? gkhandling;
  late int? gkkicking;
  late int? gkpositioning;
  late int? gkreflexes;
  late int? headingaccuracy;
  late int? interceptions;
  late int? jumping;
  late int? longpassing;
  late int? longshots;
  late int? marking;
  late int? penalties;
  late int? positioning;
  late int? potential;
  late int? reactions;
  late int? shortpassing;
  late int? shotpower;
  late int? slidingtackle;
  late int? sprintspeed;
  late int? standingtackle;
  late int? stamina;
  late int? strength;
  late int? vision;
  late int? volleys;
  late int? weakFoot;
  late List<String>? traits;
  late List<String>? specialities;
  late String? atkWorkRate;
  late String? defWorkRate;
  late dynamic playerType;
  late List<Attributes>? attributes;
  late String? name;
  late int? rarityId;
  late bool? isIcon;
  late String? quality;
  late bool? isGK;
  late String? positionFull;
  late bool? isSpecialType;
  late dynamic contracts;
  late dynamic fitness;
  late dynamic rawAttributeChemistryBonus;
  late dynamic isLoan;
  late dynamic squadPosition;
  late IconAttributes? iconAttributes;
  late String? itemType;
  late dynamic discardValue;
  late String? id;
  late String? modelName;
  late int? baseId;
  late int? rating;

  Players(
      {this.commonName,
        this.firstName,
        this.lastName,
        this.league,
        this.nation,
        this.club,
        this.headshot,
        this.position,
        this.composure,
        this.playStyle,
        this.playStyleId,
        this.height,
        this.weight,
        this.birthdate,
        this.age,
        this.acceleration,
        this.aggression,
        this.agility,
        this.balance,
        this.ballcontrol,
        this.foot,
        this.skillMoves,
        this.crossing,
        this.curve,
        this.dribbling,
        this.finishing,
        this.freekickaccuracy,
        this.gkdiving,
        this.gkhandling,
        this.gkkicking,
        this.gkpositioning,
        this.gkreflexes,
        this.headingaccuracy,
        this.interceptions,
        this.jumping,
        this.longpassing,
        this.longshots,
        this.marking,
        this.penalties,
        this.positioning,
        this.potential,
        this.reactions,
        this.shortpassing,
        this.shotpower,
        this.slidingtackle,
        this.sprintspeed,
        this.standingtackle,
        this.stamina,
        this.strength,
        this.vision,
        this.volleys,
        this.weakFoot,
        this.traits,
        this.specialities,
        this.atkWorkRate,
        this.defWorkRate,
        this.playerType,
        this.attributes,
        this.name,
        this.rarityId,
        this.isIcon,
        this.quality,
        this.isGK,
        this.positionFull,
        this.isSpecialType,
        this.contracts,
        this.fitness,
        this.rawAttributeChemistryBonus,
        this.isLoan,
        this.squadPosition,
        this.iconAttributes,
        this.itemType,
        this.discardValue,
        this.id,
        this.modelName,
        this.baseId,
        this.rating});

  Players.fromJson(Map<String, dynamic> json) {
    commonName = json['commonName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    league =
    json['league'] != null ? League.fromJson(json['league']) : null;
    nation =
    json['nation'] != null ? Nation.fromJson(json['nation']) : null;
    club = json['club'] != null ? Club.fromJson(json['club']) : null;
    headshot = json['headshot'] != null
        ? Headshot.fromJson(json['headshot'])
        : null;
    position = json['position'];
    composure = json['composure'];
    playStyle = json['playStyle'];
    playStyleId = json['playStyleId'];
    height = json['height'];
    weight = json['weight'];
    birthdate = json['birthdate'];
    age = json['age'];
    acceleration = json['acceleration'];
    aggression = json['aggression'];
    agility = json['agility'];
    balance = json['balance'];
    ballcontrol = json['ballcontrol'];
    foot = json['foot'];
    skillMoves = json['skillMoves'];
    crossing = json['crossing'];
    curve = json['curve'];
    dribbling = json['dribbling'];
    finishing = json['finishing'];
    freekickaccuracy = json['freekickaccuracy'];
    gkdiving = json['gkdiving'];
    gkhandling = json['gkhandling'];
    gkkicking = json['gkkicking'];
    gkpositioning = json['gkpositioning'];
    gkreflexes = json['gkreflexes'];
    headingaccuracy = json['headingaccuracy'];
    interceptions = json['interceptions'];
    jumping = json['jumping'];
    longpassing = json['longpassing'];
    longshots = json['longshots'];
    marking = json['marking'];
    penalties = json['penalties'];
    positioning = json['positioning'];
    potential = json['potential'];
    reactions = json['reactions'];
    shortpassing = json['shortpassing'];
    shotpower = json['shotpower'];
    slidingtackle = json['slidingtackle'];
    sprintspeed = json['sprintspeed'];
    standingtackle = json['standingtackle'];
    stamina = json['stamina'];
    strength = json['strength'];
    vision = json['vision'];
    volleys = json['volleys'];
    weakFoot = json['weakFoot'];
    //traits = json['traits'].cast<String>();
    //specialities = json['specialities'].cast<String>();
    atkWorkRate = json['atkWorkRate'];
    defWorkRate = json['defWorkRate'];
    playerType = json['playerType'];
    if (json['attributes'] != null) {
      attributes = <Attributes>[];
      json['attributes'].forEach((v) {
        attributes?.add(Attributes.fromJson(v));
      });
    }
    name = json['name'];
    rarityId = json['rarityId'];
    isIcon = json['isIcon'];
    quality = json['quality'];
    isGK = json['isGK'];
    positionFull = json['positionFull'];
    isSpecialType = json['isSpecialType'];
    contracts = json['contracts'];
    fitness = json['fitness'];
    rawAttributeChemistryBonus = json['rawAttributeChemistryBonus'];
    isLoan = json['isLoan'];
    squadPosition = json['squadPosition'];
    iconAttributes = json['iconAttributes'] != null
        ? IconAttributes.fromJson(json['iconAttributes'])
        : null;
    itemType = json['itemType'];
    discardValue = json['discardValue'];
    id = json['id'];
    modelName = json['modelName'];
    baseId = json['baseId'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['commonName'] = commonName;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    if (league != null) {
      data['league'] = league?.toJson();
    }
    if (nation != null) {
      data['nation'] = nation?.toJson();
    }
    if (club != null) {
      data['club'] = club?.toJson();
    }
    if (headshot != null) {
      data['headshot'] = headshot?.toJson();
    }
    data['position'] = position;
    data['composure'] = composure;
    data['playStyle'] = playStyle;
    data['playStyleId'] = playStyleId;
    data['height'] = height;
    data['weight'] = weight;
    data['birthdate'] = birthdate;
    data['age'] = age;
    data['acceleration'] = acceleration;
    data['aggression'] = aggression;
    data['agility'] = agility;
    data['balance'] = balance;
    data['ballcontrol'] = ballcontrol;
    data['foot'] = foot;
    data['skillMoves'] = skillMoves;
    data['crossing'] = crossing;
    data['curve'] = curve;
    data['dribbling'] = dribbling;
    data['finishing'] = finishing;
    data['freekickaccuracy'] = freekickaccuracy;
    data['gkdiving'] = gkdiving;
    data['gkhandling'] = gkhandling;
    data['gkkicking'] = gkkicking;
    data['gkpositioning'] = gkpositioning;
    data['gkreflexes'] = gkreflexes;
    data['headingaccuracy'] = headingaccuracy;
    data['interceptions'] = interceptions;
    data['jumping'] = jumping;
    data['longpassing'] = longpassing;
    data['longshots'] = longshots;
    data['marking'] = marking;
    data['penalties'] = penalties;
    data['positioning'] = positioning;
    data['potential'] = potential;
    data['reactions'] = reactions;
    data['shortpassing'] = shortpassing;
    data['shotpower'] = shotpower;
    data['slidingtackle'] = slidingtackle;
    data['sprintspeed'] = sprintspeed;
    data['standingtackle'] = standingtackle;
    data['stamina'] = stamina;
    data['strength'] = strength;
    data['vision'] = vision;
    data['volleys'] = volleys;
    data['weakFoot'] = weakFoot;
    data['traits'] = traits;
    data['specialities'] = specialities;
    data['atkWorkRate'] = atkWorkRate;
    data['defWorkRate'] = defWorkRate;
    data['playerType'] = playerType;
    if (attributes != null) {
      data['attributes'] = attributes?.map((v) => v.toJson()).toList();
    }
    data['name'] = name;
    data['rarityId'] = rarityId;
    data['isIcon'] = isIcon;
    data['quality'] = quality;
    data['isGK'] = isGK;
    data['positionFull'] = positionFull;
    data['isSpecialType'] = isSpecialType;
    data['contracts'] = contracts;
    data['fitness'] = fitness;
    data['rawAttributeChemistryBonus'] = rawAttributeChemistryBonus;
    data['isLoan'] = isLoan;
    data['squadPosition'] = squadPosition;
    if (iconAttributes != null) {
      data['iconAttributes'] = iconAttributes?.toJson();
    }
    data['itemType'] = itemType;
    data['discardValue'] = discardValue;
    data['id'] = id;
    data['modelName'] = modelName;
    data['baseId'] = baseId;
    data['rating'] = rating;
    return data;
  }
}

class League {
  late LeagueImageUrls? imageUrls;
  late String? abbrName;
  late int? id;
  late String? imgUrl;
  late String? name;

  League({this.imageUrls, this.abbrName, required this.id, this.imgUrl, required this.name});

  League.fromJson(Map<String, dynamic> json) {
    imageUrls = json['imageUrls'] != null
        ? LeagueImageUrls.fromJson(json['imageUrls'])
        : null;
    abbrName = json['abbrName'];
    id = json['id'];
    imgUrl = json['imgUrl'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (imageUrls != null) {
      data['imageUrls'] = imageUrls?.toJson();
    }
    data['abbrName'] = abbrName;
    data['id'] = id;
    data['imgUrl'] = imgUrl;
    data['name'] = name;
    return data;
  }
}

class LeagueImageUrls {
  late String? dark;
  late String? light;

  LeagueImageUrls({required this.dark, required this.light});

  LeagueImageUrls.fromJson(Map<String, dynamic> json) {
    dark = json['dark'];
    light = json['light'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dark'] = dark;
    data['light'] = light;
    return data;
  }
}

class Nation {
  late NationImageUrls? imageUrls;
  late String? abbrName;
  late int? id;
  late String? imgUrl;
  late String? name;

  Nation({this.imageUrls, this.abbrName, required this.id, this.imgUrl, required this.name});

  Nation.fromJson(Map<String, dynamic> json) {
    imageUrls = json['imageUrls'] != null
        ? NationImageUrls.fromJson(json['imageUrls'])
        : null;
    abbrName = json['abbrName'];
    id = json['id'];
    imgUrl = json['imgUrl'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (imageUrls != null) {
      data['imageUrls'] = imageUrls?.toJson();
    }
    data['abbrName'] = abbrName;
    data['id'] = id;
    data['imgUrl'] = imgUrl;
    data['name'] = name;
    return data;
  }
}

class NationImageUrls {
  late String? small;
  late String? medium;
  late String? large;

  NationImageUrls({required this.small, required this.medium, required this.large});

  NationImageUrls.fromJson(Map<String, dynamic> json) {
    small = json['small'];
    medium = json['medium'];
    large = json['large'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['small'] = small;
    data['medium'] = medium;
    data['large'] = large;
    return data;
  }
}

class Club {
  late ImageUrls? imageUrls;
  late String? abbrName;
  late int? id;
  late String? imgUrl;
  late String? name;

  Club({this.imageUrls, this.abbrName, this.id, this.imgUrl, this.name});

  Club.fromJson(Map<String, dynamic> json) {
    imageUrls = json['imageUrls'] != null
        ? ImageUrls.fromJson(json['imageUrls'])
        : null;
    abbrName = json['abbrName'];
    id = json['id'];
    imgUrl = json['imgUrl'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (imageUrls != null) {
      data['imageUrls'] = imageUrls?.toJson();
    }
    data['abbrName'] = abbrName;
    data['id'] = id;
    data['imgUrl'] = imgUrl;
    data['name'] = name;
    return data;
  }
}

class ImageUrls {
  Dark? dark;
  Light? light;

  ImageUrls({this.dark, this.light});

  ImageUrls.fromJson(Map<String, dynamic> json) {
    dark = json['dark'] != null ? Dark.fromJson(json['dark']) : null;
    light = json['light'] != null ? Light.fromJson(json['light']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (dark != null) {
      data['dark'] = dark?.toJson();
    }
    if (light != null) {
      data['light'] = light?.toJson();
    }
    return data;
  }
}

class Dark {
  String? small;
  String? medium;
  String? large;

  Dark({this.small, this.medium, this.large});

  Dark.fromJson(Map<String, dynamic> json) {
    small = json['small'];
    medium = json['medium'];
    large = json['large'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['small'] = small;
    data['medium'] = medium;
    data['large'] = large;
    return data;
  }
}

class Light {
  String? small;
  String? medium;
  String? large;

  Light({this.small, this.medium, this.large});

  Light.fromJson(Map<String, dynamic> json) {
    small = json['small'];
    medium = json['medium'];
    large = json['large'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['small'] = small;
    data['medium'] = medium;
    data['large'] = large;
    return data;
  }
}

class Headshot {
  String? imgUrl;
  bool? isDynamicPortrait;

  Headshot({this.imgUrl, this.isDynamicPortrait});

  Headshot.fromJson(Map<String, dynamic> json) {
    imgUrl = json['imgUrl'];
    isDynamicPortrait = json['isDynamicPortrait'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['imgUrl'] = imgUrl;
    data['isDynamicPortrait'] = isDynamicPortrait;
    return data;
  }
}

class Attributes {
  String? name;
  int? value;
  List<int>? chemistryBonus;

  Attributes({this.name, this.value, this.chemistryBonus});

  Attributes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
    chemistryBonus = json['chemistryBonus'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['value'] = value;
    data['chemistryBonus'] = chemistryBonus;
    return data;
  }
}

class IconAttributes {
  List<ClubTeamStats>? clubTeamStats;
  List<NationalTeamStats>? nationalTeamStats;
  String? iconText;

  IconAttributes({this.clubTeamStats, this.nationalTeamStats, this.iconText});

  IconAttributes.fromJson(Map<String, dynamic> json) {
    if (json['clubTeamStats'] != null) {
      clubTeamStats = <ClubTeamStats>[];
      json['clubTeamStats'].forEach((v) {
        clubTeamStats?.add(ClubTeamStats.fromJson(v));
      });
    }
    if (json['nationalTeamStats'] != null) {
      nationalTeamStats = <NationalTeamStats>[];
      json['nationalTeamStats'].forEach((v) {
        nationalTeamStats?.add(NationalTeamStats.fromJson(v));
      });
    }
    iconText = json['iconText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (clubTeamStats != null) {
      data['clubTeamStats'] =
          clubTeamStats?.map((v) => v.toJson()).toList();
    }
    if (nationalTeamStats != null) {
      data['nationalTeamStats'] =
          nationalTeamStats?.map((v) => v.toJson()).toList();
    }
    data['iconText'] = iconText;
    return data;
  }
}

class ClubTeamStats {
  int? years;
  int? clubId;
  String? clubName;
  int? appearances;
  int? goals;

  ClubTeamStats(
      {this.years, this.clubId, this.clubName, this.appearances, this.goals});

  ClubTeamStats.fromJson(Map<String, dynamic> json) {
    years = json['years'];
    clubId = json['clubId'];
    clubName = json['clubName'];
    appearances = json['appearances'];
    goals = json['goals'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['years'] = years;
    data['clubId'] = clubId;
    data['clubName'] = clubName;
    data['appearances'] = appearances;
    data['goals'] = goals;
    return data;
  }
}

class NationalTeamStats {
  int? years;
  int? clubId;
  String? clubName;
  int? appearances;
  int? goals;

  NationalTeamStats(
      {this.years, this.clubId, this.clubName, this.appearances, this.goals});

  NationalTeamStats.fromJson(Map<String, dynamic> json) {
    years = json['years'];
    clubId = json['clubId'];
    clubName = json['clubName'];
    appearances = json['appearances'];
    goals = json['goals'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['years'] = years;
    data['clubId'] = clubId;
    data['clubName'] = clubName;
    data['appearances'] = appearances;
    data['goals'] = goals;
    return data;
  }
}