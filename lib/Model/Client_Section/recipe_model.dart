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
    feelings = json['feelings'];
    nutrients = json['nutrients'];
    id = json['_id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    category = json['category'];
    phases = json['phases'] != null ? List<String>.from(json['phases']) : [];
    prepTime = json['prepTime'];
    cookTime = json['cookTime'];
    servings = json['servings'];
    if (json['ingredients'] != null) {
      ingredients = <Ingredients>[];
      json['ingredients'].forEach((v) {
        ingredients!.add(Ingredients.fromJson(v));
      });
    }
    instructions = json['instructions'] != null
        ? List<String>.from(json['instructions'])
        : [];
    nutrition = json['nutrition'] != null
        ? Nutrition.fromJson(json['nutrition'])
        : null;
    if (json['phaseBenefits'] != null) {
      phaseBenefits = Map<String, String>.from(json['phaseBenefits']);
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    isFavorite = json['isFavorite'];
    isSaved = json['isSaved'];
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
    calories = json['calories'];
    protein = json['protein'];
    carbs = json['carbs'];
    fat = json['fat'];
  }
}
