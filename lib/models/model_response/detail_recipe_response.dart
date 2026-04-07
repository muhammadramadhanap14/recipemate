class DetailRecipeResponse {
  int? id;
  String? image;
  String? imageType;
  String? title;
  int? readyInMinutes;
  int? servings;
  String? sourceUrl;
  bool? vegetarian;
  bool? vegan;
  bool? glutenFree;
  bool? dairyFree;
  bool? veryHealthy;
  bool? cheap;
  bool? veryPopular;
  bool? sustainable;
  bool? lowFodmap;
  int? weightWatcherSmartPoints;
  String? gaps;
  int? preparationMinutes;
  int? cookingMinutes;
  int? aggregateLikes;
  int? healthScore;
  String? creditsText;
  String? license;
  String? sourceName;
  double? pricePerServing;
  List<ExtendedIngredients>? extendedIngredients;
  Nutrition? nutrition;
  Taste? taste;
  String? summary;
  List<String>? cuisines;
  List<String>? dishTypes;
  List<String>? diets;
  List<String>? occasions;
  WinePairing? winePairing;
  String? instructions;
  List<AnalyzedInstructions>? analyzedInstructions;
  String? language;
  double? spoonacularScore;
  String? spoonacularSourceUrl;

  DetailRecipeResponse(
      {this.id,
        this.image,
        this.imageType,
        this.title,
        this.readyInMinutes,
        this.servings,
        this.sourceUrl,
        this.vegetarian,
        this.vegan,
        this.glutenFree,
        this.dairyFree,
        this.veryHealthy,
        this.cheap,
        this.veryPopular,
        this.sustainable,
        this.lowFodmap,
        this.weightWatcherSmartPoints,
        this.gaps,
        this.preparationMinutes,
        this.cookingMinutes,
        this.aggregateLikes,
        this.healthScore,
        this.creditsText,
        this.license,
        this.sourceName,
        this.pricePerServing,
        this.extendedIngredients,
        this.nutrition,
        this.taste,
        this.summary,
        this.cuisines,
        this.dishTypes,
        this.diets,
        this.occasions,
        this.winePairing,
        this.instructions,
        this.analyzedInstructions,
        this.language,
        this.spoonacularScore,
        this.spoonacularSourceUrl});

  DetailRecipeResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    imageType = json['imageType'];
    title = json['title'];
    readyInMinutes = json['readyInMinutes'];
    servings = json['servings'];
    sourceUrl = json['sourceUrl'];
    vegetarian = json['vegetarian'];
    vegan = json['vegan'];
    glutenFree = json['glutenFree'];
    dairyFree = json['dairyFree'];
    veryHealthy = json['veryHealthy'];
    cheap = json['cheap'];
    veryPopular = json['veryPopular'];
    sustainable = json['sustainable'];
    lowFodmap = json['lowFodmap'];
    weightWatcherSmartPoints = json['weightWatcherSmartPoints'];
    gaps = json['gaps'];
    preparationMinutes = json['preparationMinutes'];
    cookingMinutes = json['cookingMinutes'];
    aggregateLikes = json['aggregateLikes'];
    healthScore = json['healthScore'];
    creditsText = json['creditsText'];
    license = json['license'];
    sourceName = json['sourceName'];
    pricePerServing = (json['pricePerServing'] as num?)?.toDouble();
    if (json['extendedIngredients'] != null) {
      extendedIngredients = <ExtendedIngredients>[];
      json['extendedIngredients'].forEach((v) {
        extendedIngredients!.add(ExtendedIngredients.fromJson(v));
      });
    }
    nutrition = json['nutrition'] != null
        ? Nutrition.fromJson(json['nutrition'])
        : null;
    taste = json['taste'] != null ? Taste.fromJson(json['taste']) : null;
    summary = json['summary'];
    cuisines = json['cuisines']?.cast<String>().toList();
    dishTypes = json['dishTypes']?.cast<String>().toList();
    diets = json['diets']?.cast<String>().toList();
    occasions = json['occasions']?.cast<String>().toList();
    winePairing = json['winePairing'] != null
        ? WinePairing.fromJson(json['winePairing'])
        : null;
    instructions = json['instructions'];
    if (json['analyzedInstructions'] != null) {
      analyzedInstructions = <AnalyzedInstructions>[];
      json['analyzedInstructions'].forEach((v) {
        analyzedInstructions!.add(AnalyzedInstructions.fromJson(v));
      });
    }
    language = json['language'];
    spoonacularScore = (json['spoonacularScore'] as num?)?.toDouble();
    spoonacularSourceUrl = json['spoonacularSourceUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['imageType'] = imageType;
    data['title'] = title;
    data['readyInMinutes'] = readyInMinutes;
    data['servings'] = servings;
    data['sourceUrl'] = sourceUrl;
    data['vegetarian'] = vegetarian;
    data['vegan'] = vegan;
    data['glutenFree'] = glutenFree;
    data['dairyFree'] = dairyFree;
    data['veryHealthy'] = veryHealthy;
    data['cheap'] = cheap;
    data['veryPopular'] = veryPopular;
    data['sustainable'] = sustainable;
    data['lowFodmap'] = lowFodmap;
    data['weightWatcherSmartPoints'] = weightWatcherSmartPoints;
    data['gaps'] = gaps;
    data['preparationMinutes'] = preparationMinutes;
    data['cookingMinutes'] = cookingMinutes;
    data['aggregateLikes'] = aggregateLikes;
    data['healthScore'] = healthScore;
    data['creditsText'] = creditsText;
    data['license'] = license;
    data['sourceName'] = sourceName;
    data['pricePerServing'] = pricePerServing;
    if (extendedIngredients != null) {
      data['extendedIngredients'] =
          extendedIngredients!.map((v) => v.toJson()).toList();
    }
    if (nutrition != null) {
      data['nutrition'] = nutrition!.toJson();
    }
    if (taste != null) {
      data['taste'] = taste!.toJson();
    }
    data['summary'] = summary;
    data['cuisines'] = cuisines;
    data['dishTypes'] = dishTypes;
    data['diets'] = diets;
    data['occasions'] = occasions;
    if (winePairing != null) {
      data['winePairing'] = winePairing!.toJson();
    }
    data['instructions'] = instructions;
    if (analyzedInstructions != null) {
      data['analyzedInstructions'] =
          analyzedInstructions!.map((v) => v.toJson()).toList();
    }
    data['language'] = language;
    data['spoonacularScore'] = spoonacularScore;
    data['spoonacularSourceUrl'] = spoonacularSourceUrl;
    return data;
  }
}

class ExtendedIngredients {
  int? id;
  String? aisle;
  String? image;
  String? consistency;
  String? name;
  String? nameClean;
  String? original;
  String? originalName;
  double? amount;
  String? unit;
  List<String>? meta;
  Measures? measures;

  ExtendedIngredients(
      {this.id,
        this.aisle,
        this.image,
        this.consistency,
        this.name,
        this.nameClean,
        this.original,
        this.originalName,
        this.amount,
        this.unit,
        this.meta,
        this.measures});

  ExtendedIngredients.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    aisle = json['aisle'];
    image = json['image'];
    consistency = json['consistency'];
    name = json['name'];
    nameClean = json['nameClean'];
    original = json['original'];
    originalName = json['originalName'];
    amount = (json['amount'] as num?)?.toDouble();
    unit = json['unit'];
    meta = json['meta']?.cast<String>().toList();
    measures = json['measures'] != null
        ? Measures.fromJson(json['measures'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['aisle'] = aisle;
    data['image'] = image;
    data['consistency'] = consistency;
    data['name'] = name;
    data['nameClean'] = nameClean;
    data['original'] = original;
    data['originalName'] = originalName;
    data['amount'] = amount;
    data['unit'] = unit;
    data['meta'] = meta;
    if (measures != null) {
      data['measures'] = measures!.toJson();
    }
    return data;
  }
}

class Measures {
  Us? us;
  Us? metric;

  Measures({this.us, this.metric});

  Measures.fromJson(Map<String, dynamic> json) {
    us = json['us'] != null ? Us.fromJson(json['us']) : null;
    metric = json['metric'] != null ? Us.fromJson(json['metric']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (us != null) {
      data['us'] = us!.toJson();
    }
    if (metric != null) {
      data['metric'] = metric!.toJson();
    }
    return data;
  }
}

class Us {
  double? amount;
  String? unitShort;
  String? unitLong;

  Us({this.amount, this.unitShort, this.unitLong});

  Us.fromJson(Map<String, dynamic> json) {
    amount = (json['amount'] as num?)?.toDouble();
    unitShort = json['unitShort'];
    unitLong = json['unitLong'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['unitShort'] = unitShort;
    data['unitLong'] = unitLong;
    return data;
  }
}

class Nutrition {
  List<Nutrients>? nutrients;
  List<Properties>? properties;
  List<Flavonoids>? flavonoids;
  List<Ingredients>? ingredients;
  CaloricBreakdown? caloricBreakdown;
  WeightPerServing? weightPerServing;

  Nutrition(
      {this.nutrients,
        this.properties,
        this.flavonoids,
        this.ingredients,
        this.caloricBreakdown,
        this.weightPerServing});

  Nutrition.fromJson(Map<String, dynamic> json) {
    if (json['nutrients'] != null) {
      nutrients = <Nutrients>[];
      json['nutrients'].forEach((v) {
        nutrients!.add(Nutrients.fromJson(v));
      });
    }
    if (json['properties'] != null) {
      properties = <Properties>[];
      json['properties'].forEach((v) {
        properties!.add(Properties.fromJson(v));
      });
    }
    if (json['flavonoids'] != null) {
      flavonoids = <Flavonoids>[];
      json['flavonoids'].forEach((v) {
        flavonoids!.add(Flavonoids.fromJson(v));
      });
    }
    if (json['ingredients'] != null) {
      ingredients = <Ingredients>[];
      json['ingredients'].forEach((v) {
        ingredients!.add(Ingredients.fromJson(v));
      });
    }
    caloricBreakdown = json['caloricBreakdown'] != null
        ? CaloricBreakdown.fromJson(json['caloricBreakdown'])
        : null;
    weightPerServing = json['weightPerServing'] != null
        ? WeightPerServing.fromJson(json['weightPerServing'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (nutrients != null) {
      data['nutrients'] = nutrients!.map((v) => v.toJson()).toList();
    }
    if (properties != null) {
      data['properties'] = properties!.map((v) => v.toJson()).toList();
    }
    if (flavonoids != null) {
      data['flavonoids'] = flavonoids!.map((v) => v.toJson()).toList();
    }
    if (ingredients != null) {
      data['ingredients'] = ingredients!.map((v) => v.toJson()).toList();
    }
    if (caloricBreakdown != null) {
      data['caloricBreakdown'] = caloricBreakdown!.toJson();
    }
    if (weightPerServing != null) {
      data['weightPerServing'] = weightPerServing!.toJson();
    }
    return data;
  }
}

class Nutrients {
  String? name;
  double? amount;
  String? unit;
  double? percentOfDailyNeeds;

  Nutrients({this.name, this.amount, this.unit, this.percentOfDailyNeeds});

  Nutrients.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    amount = (json['amount'] as num?)?.toDouble();
    unit = json['unit'];
    percentOfDailyNeeds = (json['percentOfDailyNeeds'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['amount'] = amount;
    data['unit'] = unit;
    data['percentOfDailyNeeds'] = percentOfDailyNeeds;
    return data;
  }
}

class Properties {
  String? name;
  double? amount;
  String? unit;

  Properties({this.name, this.amount, this.unit});

  Properties.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    amount = (json['amount'] as num?)?.toDouble();
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['amount'] = amount;
    data['unit'] = unit;
    return data;
  }
}

class Flavonoids {
  String? name;
  double? amount;
  String? unit;

  Flavonoids({this.name, this.amount, this.unit});

  Flavonoids.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    amount = (json['amount'] as num?)?.toDouble();
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['amount'] = amount;
    data['unit'] = unit;
    return data;
  }
}

class Ingredients {
  int? id;
  String? name;
  double? amount;
  String? unit;
  List<Nutrients>? nutrients;

  Ingredients({this.id, this.name, this.amount, this.unit, this.nutrients});

  Ingredients.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    amount = (json['amount'] as num?)?.toDouble();
    unit = json['unit'];
    if (json['nutrients'] != null) {
      nutrients = <Nutrients>[];
      json['nutrients'].forEach((v) {
        nutrients!.add(Nutrients.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['amount'] = amount;
    data['unit'] = unit;
    if (nutrients != null) {
      data['nutrients'] = nutrients!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CaloricBreakdown {
  double? percentProtein;
  double? percentFat;
  double? percentCarbs;

  CaloricBreakdown({this.percentProtein, this.percentFat, this.percentCarbs});

  CaloricBreakdown.fromJson(Map<String, dynamic> json) {
    percentProtein = (json['percentProtein'] as num?)?.toDouble();
    percentFat = (json['percentFat'] as num?)?.toDouble();
    percentCarbs = (json['percentCarbs'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['percentProtein'] = percentProtein;
    data['percentFat'] = percentFat;
    data['percentCarbs'] = percentCarbs;
    return data;
  }
}

class WeightPerServing {
  int? amount;
  String? unit;

  WeightPerServing({this.amount, this.unit});

  WeightPerServing.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['unit'] = unit;
    return data;
  }
}

class Taste {
  double? sweetness;
  double? saltiness;
  double? sourness;
  double? bitterness;
  double? savoriness;
  double? fattiness;
  double? spiciness;

  Taste({
    this.sweetness,
    this.saltiness,
    this.sourness,
    this.bitterness,
    this.savoriness,
    this.fattiness,
    this.spiciness
  });

  Taste.fromJson(Map<String, dynamic> json) {
    sweetness = (json['sweetness'] as num?)?.toDouble();
    saltiness = (json['saltiness'] as num?)?.toDouble();
    sourness = (json['sourness'] as num?)?.toDouble();
    bitterness = (json['bitterness'] as num?)?.toDouble();
    savoriness = (json['savoriness'] as num?)?.toDouble();
    fattiness = (json['fattiness'] as num?)?.toDouble();
    spiciness = (json['spiciness'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sweetness'] = sweetness;
    data['saltiness'] = saltiness;
    data['sourness'] = sourness;
    data['bitterness'] = bitterness;
    data['savoriness'] = savoriness;
    data['fattiness'] = fattiness;
    data['spiciness'] = spiciness;
    return data;
  }
}

class WinePairing {
  List<String>? pairedWines;
  String? pairingText;
  List<ProductMatches>? productMatches;

  WinePairing({this.pairedWines, this.pairingText, this.productMatches});

  WinePairing.fromJson(Map<String, dynamic> json) {
    pairedWines = json['pairedWines']?.cast<String>().toList();
    pairingText = json['pairingText'];
    if (json['productMatches'] != null) {
      productMatches = <ProductMatches>[];
      json['productMatches'].forEach((v) {
        productMatches!.add(ProductMatches.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pairedWines'] = pairedWines;
    data['pairingText'] = pairingText;
    if (productMatches != null) {
      data['productMatches'] =
          productMatches!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductMatches {
  int? id;
  String? title;
  String? description;
  String? price;
  String? imageUrl;
  double? averageRating;
  int? ratingCount;
  double? score;
  String? link;

  ProductMatches(
      {this.id,
        this.title,
        this.description,
        this.price,
        this.imageUrl,
        this.averageRating,
        this.ratingCount,
        this.score,
        this.link});

  ProductMatches.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    imageUrl = json['imageUrl'];
    averageRating = (json['averageRating'] as num?)?.toDouble();
    ratingCount = json['ratingCount'];
    score = (json['score'] as num?)?.toDouble();
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    data['imageUrl'] = imageUrl;
    data['averageRating'] = averageRating;
    data['ratingCount'] = ratingCount;
    data['score'] = score;
    data['link'] = link;
    return data;
  }
}

class AnalyzedInstructions {
  String? name;
  List<Steps>? steps;

  AnalyzedInstructions({this.name, this.steps});

  AnalyzedInstructions.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['steps'] != null) {
      steps = <Steps>[];
      json['steps'].forEach((v) {
        steps!.add(Steps.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (steps != null) {
      data['steps'] = steps!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Steps {
  int? number;
  String? step;
  List<StepIngredients>? ingredients;
  List<Equipment>? equipment;
  Temperature? length;

  Steps(
      {this.number, this.step, this.ingredients, this.equipment, this.length});

  Steps.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    step = json['step'];
    if (json['ingredients'] != null) {
      ingredients = <StepIngredients>[];
      json['ingredients'].forEach((v) {
        ingredients!.add(StepIngredients.fromJson(v));
      });
    }
    if (json['equipment'] != null) {
      equipment = <Equipment>[];
      json['equipment'].forEach((v) {
        equipment!.add(Equipment.fromJson(v));
      });
    }
    length = json['length'] != null
        ? Temperature.fromJson(json['length'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['number'] = number;
    data['step'] = step;
    if (ingredients != null) {
      data['ingredients'] = ingredients!.map((v) => v.toJson()).toList();
    }
    if (equipment != null) {
      data['equipment'] = equipment!.map((v) => v.toJson()).toList();
    }
    if (length != null) {
      data['length'] = length!.toJson();
    }
    return data;
  }
}

class StepIngredients {
  int? id;
  String? name;
  String? localizedName;
  String? image;

  StepIngredients({this.id, this.name, this.localizedName, this.image});

  StepIngredients.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    localizedName = json['localizedName'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['localizedName'] = localizedName;
    data['image'] = image;
    return data;
  }
}

class Equipment {
  int? id;
  String? name;
  String? localizedName;
  String? image;
  Temperature? temperature;

  Equipment(
      {this.id, this.name, this.localizedName, this.image, this.temperature});

  Equipment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    localizedName = json['localizedName'];
    image = json['image'];
    temperature = json['temperature'] != null
        ? Temperature.fromJson(json['temperature'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['localizedName'] = localizedName;
    data['image'] = image;
    if (temperature != null) {
      data['temperature'] = temperature!.toJson();
    }
    return data;
  }
}

class Temperature {
  int? number;
  String? unit;

  Temperature({this.number, this.unit});

  Temperature.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['number'] = number;
    data['unit'] = unit;
    return data;
  }
}
