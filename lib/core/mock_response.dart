const String mockAppContentResponse = r'''
{
    "response_code": 200,
    "success": true,
    "message": "App content fetched successfully",
    "result": {
        "intro_slider": {
            "page_name": "intro_slider",
            "page_title": "Serwiz Intro",
            "page_description": "Welcome to intro slider page",
            "login_required": false,
            "intro_slider": [
                {
                    "image": "https://serwiz.co/assets/img/serwiz-img/electrician.jpg",
                    "title": "Welcome to SerWiz",
                    "description": "Your trusted service booking platform.",
                    "redirect_to": "https://www.google.com/"
                },
                {
                    "image": "https://serwiz.co/assets/img/serwiz-img/Air-Conditioner.jpg",
                    "title": "Find Experts Easily",
                    "description": "Browse and book professionals in minutes.",
                    "redirect_to": "https://www.technlogi.com/"
                },
                {
                    "image": "https://serwiz.co/assets/img/serwiz-img/air-cooler.jpg",
                    "title": "Safe & Secure",
                    "description": "Verified providers with secure payment options.",
                    "redirect_to": "https://www.google.com/"
                }
            ]
        },
        "register": {
            "page_name": "register",
            "page_title": "Register",
            "page_description": "Create a new account to get started.",
            "login_required": false,
            "inputs": [
                {
                    "auto_forward": false,
                    "enter_enable": false,
                    "input_type": "text",
                    "label": "Mobile Number",
                    "placeholder": "Enter your 10-digit mobile number",
                    "name": "username",
                    "required": true,
                    "options": [],
                    "validations": [
                        {
                            "type": "numeric",
                            "error_message": "Mobile number must be numeric"
                        },
                        {
                            "type": "exact_length",
                            "value": 10,
                            "error_message": "Mobile number must be exactly 10 digits"
                        }
                    ],
                    "value": null
                },
                {
                    "auto_forward": false,
                    "enter_enable": false,
                    "input_type": "password",
                    "label": "Password",
                    "placeholder": "Enter Password",
                    "name": "password",
                    "required": true,
                    "options": [],
                    "validations": [
                        {
                            "type": "password",
                            "min_length": 8,
                            "max_length": null,
                            "min_length_error": "Password must be at least 8 characters",
                            "max_length_error": null,
                            "pattern": "(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])",
                            "pattern_error_message": "Password must include uppercase, lowercase, number, and special character"
                        }
                    ],
                    "value": null
                },
                {
                    "auto_forward": false,
                    "enter_enable": false,
                    "input_type": "password",
                    "label": "Confirm Password",
                    "placeholder": "Re-enter Password",
                    "name": "confirm_password",
                    "required": true,
                    "options": [],
                    "validations": [
                        {
                            "type": "matches",
                            "field": "password",
                            "error_message": "Passwords do not match"
                        }
                    ],
                    "value": null
                }
            ]
        },
        "login_with_password": {
            "page_name": "login_with_password",
            "page_title": "Login with Password",
            "page_description": "Access your account using your registered mobile number and password.",
            "login_required": false,
            "inputs": [
                {
                    "auto_forward": false,
                    "enter_enable": false,
                    "input_type": "text",
                    "label": "Mobile Number",
                    "placeholder": "Enter your 10-digit mobile number",
                    "name": "username",
                    "required": true,
                    "options": [],
                    "validations": [
                        {
                            "type": "numeric",
                            "error_message": "Mobile number must be numeric"
                        },
                        {
                            "type": "exact_length",
                            "value": 10,
                            "error_message": "Mobile number must be exactly 10 digits"
                        }
                    ],
                    "value": null
                },
                {
                    "auto_forward": false,
                    "enter_enable": false,
                    "input_type": "password",
                    "label": "Password",
                    "placeholder": "Enter Password",
                    "name": "password",
                    "required": true,
                    "options": [],
                    "validations": [
                        {
                            "type": "min_length",
                            "value": 8,
                            "error_message": "Password must be at least 8 characters"
                        }
                    ],
                    "value": null
                }
            ]
        },
        "login_with_otp": {
            "page_name": "login_with_otp",
            "page_title": "Login with OTP",
            "page_description": "Access your account using a one-time password sent to your mobile number.",
            "login_required": false,
            "inputs": [
                {
                    "auto_forward": false,
                    "enter_enable": false,
                    "input_type": "text",
                    "label": "Mobile Number",
                    "placeholder": "Enter your 10-digit mobile number",
                    "name": "username",
                    "required": true,
                    "options": [],
                    "validations": [
                        {
                            "type": "numeric",
                            "error_message": "Mobile number must be numeric"
                        },
                        {
                            "type": "exact_length",
                            "value": 10,
                            "error_message": "Mobile number must be exactly 10 digits"
                        }
                    ],
                    "value": null
                }
            ]
        },
        "verify_otp": {
            "page_name": "verify_otp",
            "page_title": "Verify OTP",
            "page_description": "Enter the one-time password (OTP) sent to your registered mobile number.",
            "login_required": false,
            "inputs": [
                {
                    "auto_forward": false,
                    "enter_enable": false,
                    "input_type": "text",
                    "label": "OTP",
                    "placeholder": "Enter the OTP received on your mobile",
                    "name": "otp",
                    "required": true,
                    "options": [],
                    "validations": [
                        {
                            "type": "numeric",
                            "error_message": "OTP must be numeric"
                        },
                        {
                            "type": "exact_length",
                            "value": 4,
                            "error_message": "OTP must be 4 digits"
                        }
                    ],
                    "value": null
                }
            ]
        },
        "home_page": {
            "page_name": "home_page",
            "page_title": "Home",
            "page_description": "Home page description here",
            "login_required": false,
            "design": {
                "header_menu": {
                    "bg_color": "linear-gradient(to right, #69B22A, #69B22A)",
                    "bg_img": "https://serwiz.co/assets/img/serwiz-img/Air-Conditioner.jpg",
                    "user_info": true,
                    "current_location": true,
                    "header_menu": [
                        {
                            "icon": "https://www.citypng.com/public/uploads/preview/free-notifications-bell-outline-icon-png-701751694974381h7wblk6fpx.png",
                            "label": "",
                            "is_active": true,
                            "login_required": true,
                            "api_endpoint": "notification",
                            "view_type": "",
                            "page_name": "notification",
                            "page_image": "",
                            "title": "Notification",
                            "description": "Notification page details",
                            "design": []
                        },
                        {
                            "icon": "https://www.citypng.com/public/uploads/preview/free-notifications-bell-outline-icon-png-701751694974381h7wblk6fpx.png",
                            "label": "",
                            "is_active": true,
                            "login_required": false,
                            "api_endpoint": "get-posts",
                            "view_type": "custom_vertical_listview_list",
                            "page_name": "recent_posts",
                            "page_image": "",
                            "title": "Recent Posts",
                            "description": "Recent post page details",
                            "design": []
                        }
                    ]
                },
                "body": [
                    {
                        "bg_color": "linear-gradient(to right, #69B22A, #69B22A)",
                        "bg_img": "https://serwiz.co/assets/img/serwiz-img/Air-Conditioner.jpg",
                        "label": "",
                        "is_active": true,
                        "login_required": false,
                        "api_endpoint": "get-posts",
                        "view_type": "search_bar",
                        "page_name": "search_bar",
                        "page_image": "",
                        "title": "Search keyword...",
                        "description": "Type Post Id, Key word",
                        "design": []
                    },
                    {
                        "bg_color": "linear-gradient(to right, #69B22A, #69B22A)",
                        "bg_img": "https://serwiz.co/assets/img/serwiz-img/Air-Conditioner.jpg",
                        "label": "Category",
                        "is_active": true,
                        "login_required": false,
                        "api_endpoint": "category",
                        "view_type": "category_horizontal_icon_widget",
                        "page_name": "select_category",
                        "page_image": "",
                        "title": "Select Category",
                        "description": "Select any one",
                        "design": []
                    },
                    {
                        "bg_color": "linear-gradient(to right, #69B22A, #69B22A)",
                        "bg_img": "https://serwiz.co/assets/img/serwiz-img/Air-Conditioner.jpg",
                        "label": "",
                        "is_active": true,
                        "login_required": false,
                        "api_endpoint": "banner/home_banner",
                        "view_type": "custom_banner",
                        "page_name": "",
                        "page_image": "",
                        "title": "",
                        "description": "",
                        "design": []
                    },
                    {
                        "bg_color": "linear-gradient(to right, #69B22A, #69B22A)",
                        "bg_img": "https://serwiz.co/assets/img/serwiz-img/Air-Conditioner.jpg",
                        "label": "",
                        "is_active": true,
                        "login_required": false,
                        "api_endpoint": "banner/video_banner",
                        "view_type": "custom_banner_with_video",
                        "page_name": "",
                        "page_image": "",
                        "title": "",
                        "description": "",
                        "design": []
                    },
                    {
                        "bg_color": "linear-gradient(to right, #ffffffff, #ffffffff)",
                        "bg_img": null,
                        "label": "Fast Move",
                        "is_active": true,
                        "login_required": false,
                        "api_endpoint": "",
                        "view_type": "custom_tapbar",
                        "page_name": "",
                        "page_image": "",
                        "title": "",
                        "description": "",
                        "design": {
                            "inputs": {
                                "select": {
                                    "input_type": "select",
                                    "label": "Status",
                                    "placeholder": "",
                                    "name": "status",
                                    "required": false,
                                    "api_endpoint": "get-posts",
                                    "options": [
                                        {
                                            "label": "Latest",
                                            "value": "latest"
                                        },
                                        {
                                            "label": "Live",
                                            "value": "live"
                                        },
                                        {
                                            "label": "Nearby",
                                            "value": "nearby"
                                        }
                                    ]
                                }
                            }
                        }
                    },
                    {
                        "bg_color": "linear-gradient(to right, #ffffffff, #ffffffff)",
                        "bg_img": null,
                        "label": "Live Auctions",
                        "is_active": true,
                        "login_required": false,
                        "api_endpoint": "get-posts/live/5",
                        "view_type": "custom_horizontal_gridview_list",
                        "page_name": "",
                        "page_image": "",
                        "title": "",
                        "description": "",
                        "design": []
                    },
                    {
                        "bg_color": "linear-gradient(to right, #ffffffff, #ffffffff)",
                        "bg_img": null,
                        "label": "Upcoming Auctions",
                        "is_active": true,
                        "login_required": false,
                        "api_endpoint": "get-posts/upcoming/5",
                        "view_type": "custom_horizontal_listview_list",
                        "page_name": "",
                        "page_image": "",
                        "title": "",
                        "description": "",
                        "design": []
                    },
                    {
                        "bg_color": "linear-gradient(to right, #ffffffff, #ffffffff)",
                        "bg_img": null,
                        "label": "Recently Viewed",
                        "is_active": true,
                        "login_required": false,
                        "api_endpoint": "get-posts/recent_viewed/5",
                        "view_type": "custom_vertical_listview_list",
                        "page_name": "",
                        "page_image": "",
                        "title": "",
                        "description": "",
                        "design": []
                    }
                ]
            }
        },
        "profile_form": {
            "page_name": "profile_form",
            "page_title": "Profile Form",
            "page_description": "Complete or update your profile in 3 guided steps.",
            "login_required": true,
            "progress_bar": true,
            "auto_forward": true,
            "total_steps": 3,
            "step_titles": [
                "Basic Information",
                "Address Details",
                "Document Verification"
            ],
            "api_endpoints": {
                "step_1_api_endpoint": "profile/update",
                "step_2_api_endpoint": "profile/update",
                "step_3_api_endpoint": "profile/update"
            },
            "buttons": [
                {
                    "label": "Previous",
                    "action": "prev_step",
                    "visible_from_step": 2
                },
                {
                    "label": "Next",
                    "action": "next_step",
                    "visible_until_step": 2
                },
                {
                    "label": "Submit",
                    "action": "submit_form",
                    "visible_on_step": 3
                },
                {
                    "label": "Add",
                    "action": "add_form",
                    "visible_on_step": 0
                }
            ],
            "inputs": {
                "step_1": [
                    {
                        "auto_forward": false,
                        "enter_enable": false,
                        "input_type": "single",
                        "label": "Step Type",
                        "placeholder": "Step Type",
                        "name": "step_type",
                        "required": true,
                        "options": [],
                        "validations": [],
                        "value": null
                    },
                    {
                        "auto_forward": false,
                        "enter_enable": false,
                        "input_type": "file",
                        "label": "Display Picture",
                        "placeholder": "Upload Display Picture",
                        "name": "dp_image",
                        "required": false,
                        "options": [],
                        "validations": [
                            {
                                "type": "file",
                                "value": "jpg, jpeg, png",
                                "error_message": "Only JPG JPEG or PNG files allowed"
                            },
                            {
                                "type": "max_size",
                                "value": 2048,
                                "error_message": "Maximum file size 2MB"
                            }
                        ],
                        "value": null
                    },
                    {
                        "auto_forward": false,
                        "enter_enable": false,
                        "input_type": "file",
                        "label": "Banner Image",
                        "placeholder": "Upload Banner Image",
                        "name": "banner_image",
                        "required": false,
                        "options": [],
                        "validations": [
                            {
                                "type": "file",
                                "value": "jpg, jpeg, png, webp, heif, heic, gif, bmp, avif, svg",
                                "error_message": "Only JPG JPEG or PNG files allowed"
                            },
                            {
                                "type": "max_size",
                                "value": 2048,
                                "error_message": "Maximum file size 2MB"
                            }
                        ],
                        "value": null
                    },
                    {
                        "auto_forward": false,
                        "enter_enable": false,
                        "input_type": "select",
                        "label": "User Type",
                        "placeholder": "Select User Type",
                        "name": "user_type",
                        "required": true,
                        "options": [
                            {
                                "label": "Individual",
                                "value": "individual"
                            },
                            {
                                "label": "Organisation",
                                "value": "organisation"
                            }
                        ],
                        "validations": [],
                        "value": null
                    },
                    {
                        "auto_forward": false,
                        "enter_enable": false,
                        "input_type": "text",
                        "label": "Name",
                        "placeholder": "Enter Full Name",
                        "name": "name",
                        "required": true,
                        "options": [],
                        "validations": [
                            {
                                "type": "regex",
                                "value": "^[A-Za-z ]+$",
                                "error_message": "Name should only contain alphabets and spaces"
                            }
                        ],
                        "value": null
                    },
                    {
                        "auto_forward": false,
                        "enter_enable": false,
                        "input_type": "text",
                        "label": "Username",
                        "placeholder": "Enter Username",
                        "name": "username",
                        "required": true,
                        "options": [],
                        "validations": [
                            {
                                "type": "regex",
                                "value": "^[a-zA-Z0-9_]+$",
                                "error_message": "Username can contain only letters, numbers, and underscores"
                            },
                            {
                                "type": "min_length",
                                "value": 4,
                                "error_message": "Username must be at least 4 characters"
                            }
                        ],
                        "value": null
                    },
                    {
                        "auto_forward": false,
                        "enter_enable": false,
                        "input_type": "text",
                        "label": "Mobile No",
                        "placeholder": "Enter Mobile Number",
                        "name": "mobile",
                        "required": true,
                        "options": [],
                        "validations": [
                            {
                                "type": "numeric",
                                "error_message": "Mobile number must be numeric"
                            },
                            {
                                "type": "exact_length",
                                "value": 10,
                                "error_message": "Mobile number must be exactly 10 digits"
                            }
                        ],
                        "value": null
                    },
                    {
                        "auto_forward": false,
                        "enter_enable": false,
                        "input_type": "email",
                        "label": "Email",
                        "placeholder": "Enter Email Address",
                        "name": "email",
                        "required": true,
                        "options": [],
                        "validations": [
                            {
                                "type": "regex",
                                "value": "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$",
                                "error_message": "Enter a valid email address"
                            }
                        ],
                        "value": null
                    }
                ],
                "step_2": [
                    {
                        "auto_forward": false,
                        "enter_enable": false,
                        "input_type": "multiple",
                        "label": "Step Type",
                        "placeholder": "Step Type",
                        "name": "step_type",
                        "required": true,
                        "options": [],
                        "validations": [],
                        "value": null
                    },
                    {
                        "auto_forward": false,
                        "enter_enable": false,
                        "input_type": "select",
                        "label": "Address Type",
                        "placeholder": "Select Address Type",
                        "name": "address_type",
                        "required": true,
                        "options": [
                            {
                                "label": "Home",
                                "value": "home"
                            },
                            {
                                "label": "Office",
                                "value": "office"
                            },
                            {
                                "label": "Other",
                                "value": "other"
                            }
                        ],
                        "validations": [],
                        "value": null
                    },
                    {
                        "auto_forward": false,
                        "enter_enable": false,
                        "input_type": "text",
                        "label": "Landmark",
                        "placeholder": "Enter Landmark",
                        "name": "landmark",
                        "required": false,
                        "options": [],
                        "validations": [],
                        "value": null
                    },
                    {
                        "auto_forward": false,
                        "enter_enable": false,
                        "input_type": "address",
                        "label": "Address",
                        "placeholder": "Enter Full Address",
                        "name": "address",
                        "required": true,
                        "options": [],
                        "validations": [
                            {
                                "type": "min_length",
                                "value": 10,
                                "error_message": "Address must be at least 10 characters"
                            }
                        ],
                        "value": null
                    },
                    {
                        "auto_forward": false,
                        "enter_enable": false,
                        "input_type": "checkbox",
                        "label": "Default Address",
                        "placeholder": null,
                        "name": "default_address",
                        "required": false,
                        "options": [],
                        "validations": [],
                        "value": null
                    }
                ],
                "step_3": [
                    {
                        "auto_forward": false,
                        "enter_enable": false,
                        "input_type": "single",
                        "label": "Step Type",
                        "placeholder": "Step Type",
                        "name": "step_type",
                        "required": true,
                        "options": [],
                        "validations": [],
                        "value": null
                    },
                    {
                        "auto_forward": false,
                        "enter_enable": false,
                        "input_type": "text",
                        "label": "Aadhar Number",
                        "placeholder": "Enter 12-digit Aadhar Number",
                        "name": "aadhar_number",
                        "required": true,
                        "options": [],
                        "validations": [
                            {
                                "type": "numeric",
                                "error_message": "Aadhar number must be numeric"
                            },
                            {
                                "type": "exact_length",
                                "value": 12,
                                "error_message": "Aadhar number must be exactly 12 digits"
                            }
                        ],
                        "value": null
                    },
                    {
                        "auto_forward": false,
                        "enter_enable": false,
                        "input_type": "file",
                        "label": "Aadhar Front",
                        "placeholder": "Upload Aadhar Front Image",
                        "name": "aadhar_front",
                        "required": true,
                        "options": [],
                        "validations": [
                            {
                                "type": "file",
                                "value": "jpg, jpeg, png, pdf",
                                "error_message": "Only JPG JPEG or PNG files allowed"
                            },
                            {
                                "type": "max_size",
                                "value": 2048,
                                "error_message": "Maximum file size 2MB"
                            }
                        ],
                        "value": null
                    },
                    {
                        "auto_forward": false,
                        "enter_enable": false,
                        "input_type": "file",
                        "label": "Aadhar Back",
                        "placeholder": "Upload Aadhar Back Image",
                        "name": "aadhar_back",
                        "required": true,
                        "options": [],
                        "validations": [
                            {
                                "type": "file",
                                "value": "jpg, jpeg, png, pdf",
                                "error_message": "Only JPG JPEG or PNG files allowed"
                            },
                            {
                                "type": "max_size",
                                "value": 2048,
                                "error_message": "Maximum file size 2MB"
                            }
                        ],
                        "value": null
                    },
                    {
                        "auto_forward": false,
                        "enter_enable": false,
                        "input_type": "text",
                        "label": "PAN Number",
                        "placeholder": "Enter PAN Number",
                        "name": "pan_number",
                        "required": true,
                        "options": [],
                        "validations": [
                            {
                                "type": "regex",
                                "value": "^[A-Z]{5}[0-9]{4}[A-Z]{1}$",
                                "error_message": "Enter a valid PAN number (e.g., ABCDE1234F)"
                            }
                        ],
                        "value": null
                    },
                    {
                        "auto_forward": false,
                        "enter_enable": false,
                        "input_type": "file",
                        "label": "PAN Card",
                        "placeholder": "Upload PAN Card",
                        "name": "pan_card",
                        "required": true,
                        "options": [],
                        "validations": [
                            {
                                "type": "file",
                                "value": "jpg, jpeg, png, pdf",
                                "error_message": "Only JPG JPEG or PNG files allowed"
                            },
                            {
                                "type": "max_size",
                                "value": 2048,
                                "error_message": "Maximum file size 2MB"
                            }
                        ],
                        "value": null
                    },
                    {
                        "auto_forward": false,
                        "enter_enable": false,
                        "input_type": "text",
                        "label": "GSTN",
                        "placeholder": "Enter GST Number",
                        "name": "gstn",
                        "required": false,
                        "options": [],
                        "validations": [
                            {
                                "type": "regex",
                                "value": "^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$",
                                "error_message": "Enter a valid GST number (e.g., 22ABCDE1234F1Z5)"
                            }
                        ],
                        "value": null
                    },
                    {
                        "auto_forward": false,
                        "enter_enable": false,
                        "input_type": "file",
                        "label": "GST Certificate",
                        "placeholder": "Upload GST Certificate",
                        "name": "gst_certificate",
                        "required": false,
                        "options": [],
                        "validations": [
                            {
                                "type": "file",
                                "value": "jpg, jpeg, png, pdf",
                                "error_message": "Only JPG JPEG or PNG files allowed"
                            },
                            {
                                "type": "max_size",
                                "value": 2048,
                                "error_message": "Maximum file size 2MB"
                            }
                        ],
                        "value": null
                    },
                    {
                        "auto_forward": false,
                        "enter_enable": false,
                        "input_type": "text",
                        "label": "Registration Number",
                        "placeholder": "Enter Registration Number",
                        "name": "registration_number",
                        "required": false,
                        "options": [],
                        "validations": [],
                        "value": null
                    },
                    {
                        "auto_forward": false,
                        "enter_enable": false,
                        "input_type": "file",
                        "label": "Registration Certificate",
                        "placeholder": "Upload Registration Certificate",
                        "name": "registration_certificate",
                        "required": false,
                        "options": [],
                        "validations": [
                            {
                                "type": "file",
                                "value": "jpg, jpeg, png, pdf",
                                "error_message": "Only JPG JPEG or PNG files allowed"
                            },
                            {
                                "type": "max_size",
                                "value": 2048,
                                "error_message": "Maximum file size 2MB"
                            }
                        ],
                        "value": null
                    },
                    {
                        "step_setting": [],
                        "input_type": "group",
                        "label": "Uploaded Documents",
                        "placeholder": null,
                        "name": "user_documents",
                        "required": false,
                        "options": [],
                        "validations": [],
                        "value": []
                    }
                ]
            }
        },
        "post_form": {
            "page_name": "post_form",
            "page_title": "Create Post",
            "page_description": "Create or update your post in multiple guided steps.",
            "login_required": true,
            "progress_bar": true,
            "auto_forward": true,
            "total_steps": 26,
            "step_titles": [
                "Type",
                "Mode",
                "Category",
                "Condition",
                "Title",
                "Description",
                "Address",
                "Upload Media",
                "Participation Allowed",
                "Quantity Details",
                "Lot Size (Qty)",
                "Reserve Price per Unit",
                "Increment Value",
                "Inspection Start",
                "Inspection End",
                "Bid Start",
                "Bid End",
                "Bid Visibility",
                "Payment Due Days",
                "Auto Extension Minutes",
                "Bid Approval Required",
                "Bid Document Required",
                "Inspection Open",
                "Inspection Close",
                "EMD Last Date",
                "Security Deposit Days",
                "Payment Deposit Days",
                "Load Complete Days"
            ],
            "api_endpoints": {
                "step_1_api_endpoint": "post/store",
                "step_2_api_endpoint": "post/store",
                "step_3_api_endpoint": "post/store",
                "step_4_api_endpoint": "post/store",
                "step_5_api_endpoint": "post/store",
                "step_6_api_endpoint": "post/store",
                "step_7_api_endpoint": "post/store",
                "step_8_api_endpoint": "post/store",
                "step_9_api_endpoint": "post/store",
                "step_10_api_endpoint": "post/store",
                "step_11_api_endpoint": "post/store",
                "step_12_api_endpoint": "post/store",
                "step_13_api_endpoint": "post/store",
                "step_14_api_endpoint": "post/store",
                "step_15_api_endpoint": "post/store",
                "step_16_api_endpoint": "post/store",
                "step_17_api_endpoint": "post/store",
                "step_18_api_endpoint": "post/store",
                "step_19_api_endpoint": "post/store",
                "step_20_api_endpoint": "post/store",
                "step_21_api_endpoint": "post/store",
                "step_22_api_endpoint": "post/store",
                "step_23_api_endpoint": "post/store",
                "step_24_api_endpoint": "post/store",
                "step_26_api_endpoint": "post/store",
                "step_27_api_endpoint": "post/store"
            },
            "buttons": [
                {
                    "label": "Previous",
                    "action": "prev_step",
                    "visible_from_step": 2
                },
                {
                    "label": "Next",
                    "action": "next_step",
                    "visible_until_step": 25
                },
                {
                    "label": "Submit",
                    "action": "submit_form",
                    "visible_on_step": 26
                }
            ],
            "inputs": {
                "step_1": [
                    {
                        "auto_forward": false,
                        "enter_enable": false,
                        "input_type": "hidden",
                        "label": "Current Lat",
                        "placeholder": "Enter Current Lat",
                        "name": "current_lat",
                        "required": false,
                        "options": [],
                        "validations": [],
                        "value": null
                    },
                    {
                        "auto_forward": false,
                        "enter_enable": false,
                        "input_type": "hidden",
                        "label": "Current Long",
                        "placeholder": "Enter Current Long",
                        "name": "current_long",
                        "required": false,
                        "options": [],
                        "validations": [],
                        "value": null
                    },
                    {
                        "auto_forward": true,
                        "enter_enable": false,
                        "input_type": "select",
                        "label": "Type",
                        "placeholder": "Enter Type",
                        "name": "type",
                        "required": true,
                        "options": [
                            {
                                "label": "Forward (Sale)",
                                "value": "forward_sale"
                            },
                            {
                                "label": "Reverse (Buy)",
                                "value": "reverse_buy"
                            }
                        ],
                        "validations": [],
                        "value": null
                    }
                ],
                "step_2": [
                    {
                        "auto_forward": true,
                        "enter_enable": false,
                        "input_type": "select",
                        "label": "Mode",
                        "placeholder": "Enter Mode",
                        "name": "mode",
                        "required": true,
                        "options": [
                            {
                                "label": "English (Ascending)",
                                "value": "english_ascending"
                            },
                            {
                                "label": "Dutch (Descending)",
                                "value": "dutch_descending"
                            },
                            {
                                "label": "Buyout (Fixed Price)",
                                "value": "buyout"
                            },
                            {
                                "label": "Yankee (Multi-lot)",
                                "value": "yankee"
                            },
                            {
                                "label": "All Pay (Pay Advance)",
                                "value": "all_pay_advance"
                            },
                            {
                                "label": "Sealed (Secret)",
                                "value": "sealed"
                            }
                        ],
                        "validations": [],
                        "value": null
                    }
                ],
                "step_3": [
                    {
                        "auto_forward": true,
                        "enter_enable": false,
                        "input_type": "select",
                        "label": "Category",
                        "placeholder": "Enter Category",
                        "name": "category",
                        "required": true,
                        "options": [
                            {
                                "label": "Individual",
                                "value": "individual"
                            },
                            {
                                "label": "Organisation",
                                "value": "organisation"
                            }
                        ],
                        "validations": [],
                        "value": null
                    }
                ],
                "step_4": [
                    {
                        "auto_forward": false,
                        "enter_enable": true,
                        "input_type": "checkbox",
                        "label": "Condition",
                        "placeholder": "Enter Condition",
                        "name": "condition",
                        "required": true,
                        "options": [
                            {
                                "label": "New",
                                "value": "new"
                            },
                            {
                                "label": "Used",
                                "value": "used"
                            },
                            {
                                "label": "Refurbished",
                                "value": "refurbished"
                            },
                            {
                                "label": "Scrap",
                                "value": "scrap"
                            }
                        ],
                        "validations": [],
                        "value": null
                    }
                ],
                "step_5": [
                    {
                        "auto_forward": false,
                        "enter_enable": true,
                        "input_type": "text",
                        "label": "Title",
                        "placeholder": "Enter Title",
                        "name": "title",
                        "required": true,
                        "options": [],
                        "validations": [
                            {
                                "type": "min_length",
                                "value": 3,
                                "error_message": "Title must be at least 3 characters"
                            }
                        ],
                        "value": null
                    }
                ],
                "step_6": [
                    {
                        "auto_forward": false,
                        "enter_enable": false,
                        "input_type": "textarea",
                        "label": "Description",
                        "placeholder": "Enter Description",
                        "name": "description",
                        "required": true,
                        "options": [],
                        "validations": [
                            {
                                "type": "min_length",
                                "value": 10,
                                "error_message": "Description must be at least 10 characters"
                            }
                        ],
                        "value": null
                    }
                ],
                "step_7": [
                    {
                        "auto_forward": true,
                        "enter_enable": false,
                        "input_type": "address",
                        "label": "Address",
                        "placeholder": "Enter Address",
                        "name": "address",
                        "required": true,
                        "options": [],
                        "validations": [],
                        "value": null
                    },
                    {
                        "auto_forward": false,
                        "enter_enable": false,
                        "input_type": "hidden",
                        "label": "Address Lat",
                        "placeholder": "Enter Address Lat",
                        "name": "address_lat",
                        "required": false,
                        "options": [],
                        "validations": [],
                        "value": null
                    },
                    {
                        "auto_forward": false,
                        "enter_enable": false,
                        "input_type": "hidden",
                        "label": "Address Long",
                        "placeholder": "Enter Address Long",
                        "name": "address_long",
                        "required": false,
                        "options": [],
                        "validations": [],
                        "value": null
                    },
                    {
                        "auto_forward": false,
                        "enter_enable": true,
                        "input_type": "text",
                        "label": "Landmark",
                        "placeholder": "Enter Landmark",
                        "name": "landmark",
                        "required": false,
                        "options": [],
                        "validations": [],
                        "value": null
                    }
                ],
                "step_8": [
                    {
                        "auto_forward": true,
                        "enter_enable": false,
                        "input_type": "file",
                        "label": "Video",
                        "placeholder": "Enter Video",
                        "name": "video",
                        "required": false,
                        "options": [],
                        "validations": [
                            {
                                "type": "file",
                                "value": "mp4, mov, mkv, avi, webm, 3gp, hevc"
                            }
                        ],
                        "value": null
                    },
                    {
                        "auto_forward": false,
                        "enter_enable": true,
                        "input_type": "files",
                        "label": "Photos",
                        "placeholder": "Enter Photos",
                        "name": "photo",
                        "required": false,
                        "options": [],
                        "validations": [
                            {
                                "type": "file",
                                "value": "jpg, jpeg, png, webp, heif, heic, gif, bmp, avif, svg"
                            }
                        ],
                        "value": null
                    }
                ],
                "step_9": [
                    {
                        "auto_forward": true,
                        "enter_enable": false,
                        "input_type": "toggle",
                        "label": "Participation Allowed",
                        "placeholder": "Enter Participation Allowed",
                        "name": "participation_allowed",
                        "required": true,
                        "options": [],
                        "validations": [],
                        "value": null
                    }
                ],
                "step_10": [
                    {
                        "auto_forward": false,
                        "enter_enable": true,
                        "input_type": "number",
                        "label": "Total Quantity",
                        "placeholder": "Enter Total Quantity",
                        "name": "total_quantity",
                        "required": true,
                        "options": [],
                        "validations": [],
                        "value": null
                    },
                    {
                        "auto_forward": true,
                        "enter_enable": false,
                        "input_type": "dropdown",
                        "label": "Unit",
                        "placeholder": "Enter Unit",
                        "name": "unit",
                        "required": true,
                        "options": [
                            {
                                "label": "MTS",
                                "value": "mts"
                            },
                            {
                                "label": "NOS",
                                "value": "nos"
                            }
                        ],
                        "validations": [],
                        "value": null
                    }
                ],
                "step_11": [
                    {
                        "auto_forward": false,
                        "enter_enable": true,
                        "input_type": "number",
                        "label": "Lot Size (Qty)",
                        "placeholder": "Enter Lot Size (Qty)",
                        "name": "lot_size_qty",
                        "required": true,
                        "options": [],
                        "validations": [],
                        "value": null
                    }
                ],
                "step_12": [
                    {
                        "auto_forward": false,
                        "enter_enable": true,
                        "input_type": "number",
                        "label": "Reserve Price per Unit",
                        "placeholder": "Enter Reserve Price per Unit",
                        "name": "reserve_price_per_unit",
                        "required": true,
                        "options": [],
                        "validations": [],
                        "value": null
                    }
                ],
                "step_13": [
                    {
                        "auto_forward": false,
                        "enter_enable": true,
                        "input_type": "number",
                        "label": "Increment Value",
                        "placeholder": "Enter Increment Value",
                        "name": "increment_value",
                        "required": true,
                        "options": [],
                        "validations": [],
                        "value": null
                    }
                ],
                "step_14": [
                    {
                        "auto_forward": true,
                        "enter_enable": false,
                        "input_type": "date",
                        "label": "Inspection Start",
                        "placeholder": "Enter Inspection Start",
                        "name": "inspection_start",
                        "required": false,
                        "options": [],
                        "validations": [
                            {
                                "type": "allow_past",
                                "value": false,
                                "error_message": ""
                            }
                        ],
                        "value": null
                    }
                ],
                "step_15": [
                    {
                        "auto_forward": true,
                        "enter_enable": false,
                        "input_type": "date",
                        "label": "Inspection End",
                        "placeholder": "Enter Inspection End",
                        "name": "inspection_end",
                        "required": false,
                        "options": [],
                        "validations": [
                            {
                                "type": "allow_past",
                                "value": false,
                                "error_message": ""
                            }
                        ],
                        "value": null
                    }
                ],
                "step_16": [
                    {
                        "auto_forward": true,
                        "enter_enable": false,
                        "input_type": "daterange",
                        "label": "Bid Start",
                        "placeholder": "Enter Bid Start",
                        "name": "bid_start",
                        "required": true,
                        "options": [],
                        "validations": [
                            {
                                "type": "allow_past",
                                "value": false,
                                "error_message": ""
                            }
                        ],
                        "value": null
                    }
                ],
                "step_17": [
                    {
                        "auto_forward": true,
                        "enter_enable": false,
                        "input_type": "datetimerange",
                        "label": "Bid End",
                        "placeholder": "Enter Bid End",
                        "name": "bid_end",
                        "required": true,
                        "options": [],
                        "validations": [
                            {
                                "type": "allow_past",
                                "value": false,
                                "error_message": ""
                            }
                        ],
                        "value": null
                    }
                ],
                "step_18": [
                    {
                        "auto_forward": true,
                        "enter_enable": false,
                        "input_type": "radio",
                        "label": "Bid Visibility",
                        "placeholder": "Enter Bid Visibility",
                        "name": "bid_visibility",
                        "required": true,
                        "options": [
                            {
                                "label": "Single",
                                "value": "single"
                            },
                            {
                                "label": "Multiple",
                                "value": "multiple"
                            }
                        ],
                        "validations": [],
                        "value": null
                    }
                ],
                "step_19": [
                    {
                        "auto_forward": false,
                        "enter_enable": true,
                        "input_type": "number",
                        "label": "Payment Due Days",
                        "placeholder": "Enter Payment Due Days",
                        "name": "payment_due_days",
                        "required": true,
                        "options": [],
                        "validations": [
                            {
                                "type": "min",
                                "value": 1,
                                "error_message": "Minimum 1 day required"
                            }
                        ],
                        "value": null
                    }
                ],
                "step_20": [
                    {
                        "auto_forward": false,
                        "enter_enable": true,
                        "input_type": "number",
                        "label": "Auto Extension Minutes",
                        "placeholder": "Enter Auto Extension Minutes",
                        "name": "auto_extension_minutes",
                        "required": false,
                        "options": [],
                        "validations": [],
                        "value": null
                    }
                ],
                "step_21": [
                    {
                        "auto_forward": true,
                        "enter_enable": false,
                        "input_type": "toggle",
                        "label": "Bid Approval Required",
                        "placeholder": "Enter Bid Approval Required",
                        "name": "bid_approval_required",
                        "required": false,
                        "options": [
                            {
                                "label": "Yes",
                                "value": "yes"
                            },
                            {
                                "label": "No",
                                "value": "no"
                            }
                        ],
                        "validations": [],
                        "value": null
                    }
                ],
                "step_22": [
                    {
                        "auto_forward": true,
                        "enter_enable": false,
                        "input_type": "toggle",
                        "label": "Bid Document Required",
                        "placeholder": "Enter Bid Document Required",
                        "name": "bid_document_required",
                        "required": false,
                        "options": [
                            {
                                "label": "Yes",
                                "value": "yes"
                            },
                            {
                                "label": "No",
                                "value": "no"
                            }
                        ],
                        "validations": [],
                        "value": null
                    },
                    {
                        "step_setting": [],
                        "input_type": "group",
                        "label": "Uploaded Documents",
                        "placeholder": null,
                        "name": "user_documents",
                        "required": false,
                        "options": [],
                        "validations": [],
                        "value": []
                    }
                ],
                "step_23": [
                    {
                        "auto_forward": true,
                        "enter_enable": false,
                        "input_type": "datetime",
                        "label": "Inspection Open",
                        "placeholder": "Enter Inspection Open",
                        "name": "inspection_open",
                        "required": false,
                        "options": [],
                        "validations": [
                            {
                                "type": "allow_past",
                                "value": false,
                                "error_message": ""
                            }
                        ],
                        "value": null
                    }
                ],
                "step_24": [
                    {
                        "auto_forward": true,
                        "enter_enable": false,
                        "input_type": "datetime",
                        "label": "Inspection Close",
                        "placeholder": "Enter Inspection Close",
                        "name": "inspection_close",
                        "required": false,
                        "options": [],
                        "validations": [
                            {
                                "type": "allow_past",
                                "value": false,
                                "error_message": ""
                            }
                        ],
                        "value": null
                    }
                ],
                "step_25": [
                    {
                        "auto_forward": true,
                        "enter_enable": false,
                        "input_type": "datetime",
                        "label": "EMD Last Date",
                        "placeholder": "Enter EMD Last Date",
                        "name": "emd_last_date",
                        "required": false,
                        "options": [],
                        "validations": [
                            {
                                "type": "allow_past",
                                "value": false,
                                "error_message": ""
                            }
                        ],
                        "value": null
                    }
                ],
                "step_26": [
                    {
                        "auto_forward": false,
                        "enter_enable": true,
                        "input_type": "number",
                        "label": "Security Deposit Days",
                        "placeholder": "Enter Security Deposit Days",
                        "name": "security_deposit_days",
                        "required": false,
                        "options": [],
                        "validations": [],
                        "value": null
                    },
                    {
                        "auto_forward": false,
                        "enter_enable": true,
                        "input_type": "number",
                        "label": "Payment Deposit Days",
                        "placeholder": "Enter Payment Deposit Days",
                        "name": "payment_deposit_days",
                        "required": false,
                        "options": [],
                        "validations": [],
                        "value": null
                    },
                    {
                        "auto_forward": false,
                        "enter_enable": true,
                        "input_type": "number",
                        "label": "Load Complete Days",
                        "placeholder": "Enter Load Complete Days",
                        "name": "load_complete_days",
                        "required": false,
                        "options": [],
                        "validations": [],
                        "value": null
                    }
                ]
            }
        }
    }
}
''';
