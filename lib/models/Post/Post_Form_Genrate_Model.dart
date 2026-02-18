class PostFormGenrateResponseModel {
  int? responseCode;
  bool? success;
  String? message;
  Result? result;

  PostFormGenrateResponseModel({
    this.responseCode,
    this.success,
    this.message,
    this.result,
  });

  PostFormGenrateResponseModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    success = json['success'];
    message = json['message'];
    result = json['result'] != null
        ? new Result.fromJson(json['result'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  PostForm? postForm;

  Result({this.postForm});

  Result.fromJson(Map<String, dynamic> json) {
    postForm = json['post_form'] != null
        ? new PostForm.fromJson(json['post_form'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.postForm != null) {
      data['post_form'] = this.postForm!.toJson();
    }
    return data;
  }
}

class PostForm {
  String? pageName;
  String? pageTitle;
  String? pageDescription;
  bool? loginRequired;
  bool? editMode;
  String? postKey;
  bool? progressBar;
  bool? autoForward;
  int? totalSteps;
  List<String>? stepTitles;
  ApiEndpoints? apiEndpoints;
  List<Buttons>? buttons;
  Inputs? inputs;

  PostForm({
    this.pageName,
    this.pageTitle,
    this.pageDescription,
    this.loginRequired,
    this.editMode,
    this.postKey,
    this.progressBar,
    this.autoForward,
    this.totalSteps,
    this.stepTitles,
    this.apiEndpoints,
    this.buttons,
    this.inputs,
  });

  PostForm.fromJson(Map<String, dynamic> json) {
    pageName = json['page_name'];
    pageTitle = json['page_title'];
    pageDescription = json['page_description'];
    loginRequired = json['login_required'];
    editMode = json['edit_mode'];
    postKey = json['post_key'] == null ? '' : json['post_key'].toString();
    // json['post_key'] is int
    //     ? json['post_key']
    //     : (json['post_key'] is String ? int.tryParse(json['post_key']) : null);
    progressBar = json['progress_bar'];
    autoForward = json['auto_forward'];
    totalSteps = json['total_steps'];
    if (json['step_titles'] != null) {
      stepTitles = (json['step_titles'] as List)
          .map((e) => e.toString())
          .toList();
    }
    apiEndpoints = json['api_endpoints'] != null
        ? new ApiEndpoints.fromJson(json['api_endpoints'])
        : null;
    if (json['buttons'] != null) {
      buttons = <Buttons>[];
      json['buttons'].forEach((v) {
        buttons!.add(new Buttons.fromJson(v));
      });
    }
    inputs = json['inputs'] != null
        ? new Inputs.fromJson(json['inputs'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page_name'] = this.pageName;
    data['page_title'] = this.pageTitle;
    data['page_description'] = this.pageDescription;
    data['login_required'] = this.loginRequired;
    data['edit_mode'] = this.editMode;
    // if (this.postKey != null) {
      data['post_key'] = this.postKey;
    // }
    data['progress_bar'] = this.progressBar;
    data['auto_forward'] = this.autoForward;
    data['total_steps'] = this.totalSteps;
    if (this.stepTitles != null) {
      data['step_titles'] = this.stepTitles;
    }
    if (this.apiEndpoints != null) {
      data['api_endpoints'] = this.apiEndpoints!.toJson();
    }
    if (this.buttons != null) {
      data['buttons'] = this.buttons!.map((v) => v.toJson()).toList();
    }
    if (this.inputs != null) {
      data['inputs'] = this.inputs!.toJson();
    }
    return data;
  }
}

class ApiEndpoints {
  late Map<String, String?> stepEndpoints;

  ApiEndpoints({Map<String, String?>? stepEndpoints})
    : stepEndpoints = stepEndpoints ?? {};

  ApiEndpoints.fromJson(Map<String, dynamic> json) {
    stepEndpoints = {};
    json.forEach((key, value) {
      if (key.startsWith('step_') &&
          key.endsWith('_api_endpoint') &&
          value is String) {
        stepEndpoints[key] = value;
      }
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    stepEndpoints.forEach((key, value) {
      if (value != null) {
        data[key] = value;
      }
    });
    return data;
  }

  // Helper method to get API endpoint for a specific step
  String? getStepEndpoint(int stepIndex) {
    String endpointKey = 'step_${stepIndex + 1}_api_endpoint';
    return stepEndpoints[endpointKey];
  }
}

class Buttons {
  String? label;
  String? action;
  String? style;
  int? visibleFromStep;
  int? visibleUntilStep;
  int? visibleOnStep;

  Buttons({
    this.label,
    this.action,
    this.style,
    this.visibleFromStep,
    this.visibleUntilStep,
    this.visibleOnStep,
  });

  Buttons.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    action = json['action'];
    style = json['style'];
    visibleFromStep = json['visible_from_step'];
    visibleUntilStep = json['visible_until_step'];
    visibleOnStep = json['visible_on_step'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['action'] = this.action;
    if (this.style != null) {
      data['style'] = this.style;
    }
    if (this.visibleFromStep != null) {
      data['visible_from_step'] = this.visibleFromStep;
    }
    if (this.visibleUntilStep != null) {
      data['visible_until_step'] = this.visibleUntilStep;
    }
    if (this.visibleOnStep != null) {
      data['visible_on_step'] = this.visibleOnStep;
    }
    return data;
  }
}

class Inputs {
  late Map<String, List<StepInput>?> steps;

  Inputs({Map<String, List<StepInput>?>? steps}) : steps = steps ?? {};

  Inputs.fromJson(Map<String, dynamic> json) {
    steps = {};
    json.forEach((key, value) {
      if (key.startsWith('step_') && value is List) {
        List<StepInput> stepInputs = [];
        for (var item in value) {
          stepInputs.add(StepInput.fromJson(item));
        }
        steps[key] = stepInputs;
      }
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    steps.forEach((key, value) {
      if (value != null) {
        data[key] = value.map((e) => e.toJson()).toList();
      }
    });
    return data;
  }

  // Helper method to get inputs for a specific step
  List<StepInput>? getStepInputs(int stepIndex) {
    String stepKey = 'step_${stepIndex + 1}';
    return steps[stepKey];
  }

  // Helper method to get all available steps
  List<int> getAvailableSteps() {
    List<int> availableSteps = [];
    steps.forEach((key, value) {
      if (key.startsWith('step_') && value != null) {
        String stepNumber = key.replaceFirst('step_', '');
        int stepIndex = int.tryParse(stepNumber) ?? 0;
        if (stepIndex > 0) {
          availableSteps.add(stepIndex - 1);
        }
      }
    });
    availableSteps.sort();
    return availableSteps;
  }
}

class StepInput {
  bool? autoForward;
  bool? enterEnable;
  String? inputType;
  String? label;
  String? placeholder;
  String? name;
  bool? required;
  List<OptionItem>? options;
  List<StepValidation>? validations;
  dynamic value;
  List<dynamic>? stepSetting;

  StepInput({
    this.autoForward,
    this.enterEnable,
    this.inputType,
    this.label,
    this.placeholder,
    this.name,
    this.required,
    this.options,
    this.validations,
    this.value,
    this.stepSetting,
  });

  factory StepInput.fromJson(Map<String, dynamic> json) {
    List<OptionItem>? opts;
    if (json['options'] != null) {
      opts = <OptionItem>[];
      (json['options'] as List).forEach((v) {
        if (v is Map<String, dynamic>) {
          opts!.add(OptionItem.fromJson(v));
        } else {
          // Handle string options
          opts!.add(OptionItem(label: v.toString(), value: v.toString()));
        }
      });
    }

    List<StepValidation>? validationsList;
    if (json['validations'] != null) {
      validationsList = <StepValidation>[];
      (json['validations'] as List).forEach((v) {
        validationsList!.add(StepValidation.fromJson(v));
      });
    }

    return StepInput(
      autoForward: json['auto_forward'],
      enterEnable: json['enter_enable'],
      inputType: json['input_type'],
      label: json['label'],
      placeholder: json['placeholder'],
      name: json['name'],
      required: json['required'],
      options: opts,
      validations: validationsList,
      value: json['value'],
      stepSetting: json['step_setting'] != null
          ? (json['step_setting'] as List)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['auto_forward'] = this.autoForward;
    data['enter_enable'] = this.enterEnable;
    data['input_type'] = this.inputType;
    data['label'] = this.label;
    data['placeholder'] = this.placeholder;
    data['name'] = this.name;
    data['required'] = this.required;
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    if (this.validations != null) {
      data['validations'] = this.validations!.map((v) => v.toJson()).toList();
    }
    data['value'] = this.value;
    if (this.stepSetting != null) {
      data['step_setting'] = this.stepSetting;
    }
    return data;
  }
}

class OptionItem {
  String? label;
  String? value;

  OptionItem({this.label, this.value});

  factory OptionItem.fromJson(Map<String, dynamic> json) {
    return OptionItem(
      label: json['label']?.toString(),
      value: json['value']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['value'] = this.value;
    return data;
  }
}

class StepValidation {
  String? type;
  dynamic value; // Can be int, String, bool, etc.
  String? stringValue;
  String? pattern;
  String? field;
  String? errorMessage;
  int? minLength;
  int? maxLength;
  String? minLengthError;
  String? maxLengthError;
  String? patternErrorMessage;

  StepValidation({
    this.type,
    this.value,
    this.stringValue,
    this.pattern,
    this.field,
    this.errorMessage,
    this.minLength,
    this.maxLength,
    this.minLengthError,
    this.maxLengthError,
    this.patternErrorMessage,
  });

  factory StepValidation.fromJson(Map<String, dynamic> json) {
    final String? t = json['type']?.toString().toLowerCase();
    final dynamic rawValue = json['value'];

    int? parsedIntValue;
    String? inferredPattern;
    String? stringVal;

    if (rawValue is int) {
      parsedIntValue = rawValue;
      stringVal = rawValue.toString();
    } else if (rawValue is bool) {
      stringVal = rawValue.toString();
    } else if (rawValue is String) {
      stringVal = rawValue;
      final maybeInt = int.tryParse(rawValue);
      if (maybeInt != null) {
        parsedIntValue = maybeInt;
      } else {
        if (t == 'regex' || t == 'pattern' || t == 'password') {
          inferredPattern = rawValue;
        }
      }
    } else if (rawValue != null) {
      stringVal = rawValue.toString();
    }

    return StepValidation(
      type: json['type'],
      value: parsedIntValue ?? rawValue,
      stringValue: stringVal,
      pattern: json['pattern'] ?? inferredPattern,
      field: json['field'],
      errorMessage: json['error_message'],
      minLength: json['min_length'] is int
          ? json['min_length']
          : (json['min_length'] is String
                ? int.tryParse(json['min_length'])
                : null),
      maxLength: json['max_length'] is int
          ? json['max_length']
          : (json['max_length'] is String
                ? int.tryParse(json['max_length'])
                : null),
      minLengthError: json['min_length_error'],
      maxLengthError: json['max_length_error'],
      patternErrorMessage: json['pattern_error_message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['value'] = this.value ?? this.stringValue;
    if (this.pattern != null) {
      data['pattern'] = this.pattern;
    }
    if (this.field != null) {
      data['field'] = this.field;
    }
    if (this.errorMessage != null) {
      data['error_message'] = this.errorMessage;
    }
    if (this.minLength != null) {
      data['min_length'] = this.minLength;
    }
    if (this.maxLength != null) {
      data['max_length'] = this.maxLength;
    }
    if (this.minLengthError != null) {
      data['min_length_error'] = this.minLengthError;
    }
    if (this.maxLengthError != null) {
      data['max_length_error'] = this.maxLengthError;
    }
    if (this.patternErrorMessage != null) {
      data['pattern_error_message'] = this.patternErrorMessage;
    }
    return data;
  }
}
