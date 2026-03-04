class RecipeResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  Meta? meta;
  List<RecipeModel>? data;

  RecipeResponseModel({
    this.statusCode,
    this.success,
    this.message,
    this.meta,
    this.data,
  });

  RecipeResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    if (json['data'] != null) {
      data = <RecipeModel>[];
      json['data'].forEach((v) {
        data!.add(RecipeModel.fromJson(v));
      });
    }
  }
}

class SingleRecipeResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  RecipeModel? data;

  SingleRecipeResponseModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  SingleRecipeResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? RecipeModel.fromJson(json['data']) : null;
  }
}

class Meta {
  int? total;
  int? limit;
  int? page;
  int? totalPage;

  Meta({this.total, this.limit, this.page, this.totalPage});

  Meta.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    limit = json['limit'];
    page = json['page'];
    totalPage = json['totalPage'];
  }
}

class RecipeModel {
  List<dynamic>? feelings;
  List<dynamic>? nutrients;
  String? id;
  String? title;
  String? description;
  String? image;
  String? category;
  List<String>? phases;
  int? prepTime;
  int? cookTime;
  int? servings;
  List<Ingredients>? ingredients;
  List<String>? instructions;
  Nutrition? nutrition;
  Map<String, String>? phaseBenefits;
  String? createdAt;
  String? updatedAt;
  bool? isFavorite;
  bool? isSaved;

  RecipeModel({
    this.feelings,
    this.nutrients,
    this.id,
    this.title,
    this.description,
    this.image,
    this.category,
    this.phases,
    this.prepTime,
    this.cookTime,
    this.servings,
    this.ingredients,
    this.instructions,
    this.nutrition,
    this.phaseBenefits,
    this.createdAt,
    this.updatedAt,
    this.isFavorite,
    this.isSaved,
  });

  RecipeModel.fromJson(Map<String, dynamic> json) {
    try {
      feelings = json['feelings'];
      nutrients = json['nutrients'];
      id = json['_id']?.toString();
      title = json['title']?.toString();
      description = json['description']?.toString();
      image = json['image']?.toString();
      category = json['category']?.toString();
      phases =
          (json['phases'] as List?)?.map((e) => e.toString()).toList() ?? [];
      prepTime = num.tryParse(json['prepTime']?.toString() ?? '')?.toInt();
      cookTime = num.tryParse(json['cookTime']?.toString() ?? '')?.toInt();
      servings = num.tryParse(json['servings']?.toString() ?? '')?.toInt();

      if (json['ingredients'] != null && json['ingredients'] is List) {
        ingredients = <Ingredients>[];
        for (var v in json['ingredients']) {
          ingredients!.add(Ingredients.fromJson(v));
        }
      }

      instructions =
          (json['instructions'] as List?)?.map((e) => e.toString()).toList() ??
          [];

      if (json['nutrition'] != null && json['nutrition'] is Map) {
        nutrition = Nutrition.fromJson(
          Map<String, dynamic>.from(json['nutrition']),
        );
      }

      if (json['phaseBenefits'] != null && json['phaseBenefits'] is Map) {
        phaseBenefits = Map<String, String>.from(
          (json['phaseBenefits'] as Map).map(
            (k, v) => MapEntry(k.toString(), v.toString()),
          ),
        );
      }

      createdAt = json['createdAt']?.toString();
      updatedAt = json['updatedAt']?.toString();
    } catch (e) {
      // ignore mapping errors for simple types
    }

    // Safely parse booleans from either bool, string or int (0/1)
    if (json['isFavorite'] is bool) {
      isFavorite = json['isFavorite'];
    } else if (json['isFavorite'] is String) {
      isFavorite = json['isFavorite']?.toString().toLowerCase() == 'true';
    } else if (json['isFavorite'] is int) {
      isFavorite = json['isFavorite'] == 1;
    } else {
      isFavorite = false;
    }

    if (json['isSaved'] is bool) {
      isSaved = json['isSaved'];
    } else if (json['isSaved'] is String) {
      isSaved = json['isSaved']?.toString().toLowerCase() == 'true';
    } else if (json['isSaved'] is int) {
      isSaved = json['isSaved'] == 1;
    } else {
      isSaved = false;
    }
  }
}

class Ingredients {
  String? name;
  String? amount;
  String? unit;

  Ingredients({this.name, this.amount, this.unit});

  Ingredients.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    amount = json['amount']?.toString();
    unit = json['unit'];
  }
}

class Nutrition {
  int? calories;
  int? protein;
  int? carbs;
  int? fat;

  Nutrition({this.calories, this.protein, this.carbs, this.fat});

  Nutrition.fromJson(Map<String, dynamic> json) {
    calories = num.tryParse(json['calories']?.toString() ?? '')?.toInt();
    protein = num.tryParse(json['protein']?.toString() ?? '')?.toInt();
    carbs = num.tryParse(json['carbs']?.toString() ?? '')?.toInt();
    fat = num.tryParse(json['fat']?.toString() ?? '')?.toInt();
  }
}
