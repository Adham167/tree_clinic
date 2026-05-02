import 'package:flutter/material.dart';

class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    final appLocalizations = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    assert(
      appLocalizations != null,
      'AppLocalizations was not found in the widget tree.',
    );
    return appLocalizations!;
  }

  static const supportedLocales = [Locale('en'), Locale('ar')];

  static const Map<String, Map<String, String>> _localizedValues = {
    'ar': {
      'Add': 'إضافة',
      'Added to cart': 'تمت الإضافة إلى السلة',
      'Add a clearer description': 'أضف وصفًا أوضح',
      'Add Product': 'إضافة منتج',
      'Add treatments and supplies so farmers can find them in the shop.':
          'أضف العلاجات والمستلزمات حتى يتمكن المزارعون من العثور عليها في المتجر.',
      'Add {name} as a {category} product?':
          'إضافة {name} كمنتج من فئة {category}؟',
      'Address': 'العنوان',
      'Address is required': 'العنوان مطلوب',
      'All': 'الكل',
      'Anthracnose': 'أنثراكنوز',
      'Application notes': 'ملاحظات الاستخدام',
      'Apple': 'تفاح',
      'apple': 'تفاح',
      'Approved': 'تمت الموافقة',
      'Approved sales only': 'يتم احتساب المبيعات الموافق عليها فقط',
      'Approve': 'موافقة',
      'Approval requests': 'طلبات الموافقة',
      'Arabic': 'العربية',
      'Average Order': 'متوسط الطلب',
      'Back': 'رجوع',
      'Bacterial Canker': 'التقرح البكتيري',
      'Banana': 'موز',
      'banana': 'موز',
      'Black rot': 'العفن الأسود',
      'Buyer': 'المشتري',
      'Buyer Details': 'بيانات المشتري',
      'Camera': 'الكاميرا',
      'Cancel': 'إلغاء',
      'Canker': 'اللفحة',
      'Cart is empty': 'السلة فارغة',
      'Category': 'الفئة',
      'Cedar rust': 'صدأ الأرز',
      'Checking shop': 'جارٍ التحقق من المتجر',
      'Checkout': 'إتمام الشراء',
      'Chemical treatment': 'العلاج الكيميائي',
      'Condition': 'الحالة',
      'Confirm product': 'تأكيد المنتج',
      'Could not load your shop: {message}': 'تعذر تحميل متجرك: {message}',
      'cordana': 'كوردانا',
      'Create a shop before adding products.':
          'أنشئ متجرًا قبل إضافة المنتجات.',
      'Create a shop first before adding products.':
          'أنشئ متجرك أولًا قبل إضافة المنتجات.',
      'Create your shop first.': 'أنشئ متجرك أولًا.',
      'Create your shop first, then add products.':
          'أنشئ متجرك أولًا ثم أضف المنتجات.',
      'Create Shop': 'إنشاء متجر',
      'Create Your Shop': 'أنشئ متجرك',
      'Crop': 'المحصول',
      'CSV report copied to clipboard.': 'تم نسخ تقرير CSV إلى الحافظة.',
      'Current language': 'اللغة الحالية',
      'Cutting Weevil': 'سوسة القطع',
      'Daily': 'يومي',
      'Date': 'التاريخ',
      'Delete': 'حذف',
      'Delete product': 'حذف المنتج',
      'Delete {name}? This action cannot be undone.':
          'حذف {name}؟ لا يمكن التراجع عن هذا الإجراء.',
      'Description': 'الوصف',
      'Description is required': 'الوصف مطلوب',
      'Die Back': 'موت الأفرع',
      'Disease': 'المرض',
      'Disease is required': 'المرض مطلوب',
      'Disease Overview': 'نظرة عامة على المرض',
      'Edit': 'تعديل',
      'Edit Product': 'تعديل المنتج',
      'Edit Shop': 'تعديل المتجر',
      'EGP': 'ج.م',
      'Email': 'البريد الإلكتروني',
      'English': 'الإنجليزية',
      'Enter a custom disease': 'أدخل مرضًا مخصصًا',
      'Enter a custom tree': 'أدخل شجرة مخصصة',
      'Enter a valid image URL': 'أدخل رابط صورة صالحًا',
      'Enter a valid positive price': 'أدخل سعرًا صحيحًا أكبر من صفر',
      'Export CSV': 'تصدير CSV',
      'Farmer': 'مزارع',
      'Fertilizer': 'سماد',
      'Fungicide': 'مبيد فطري',
      'Gall Midge': 'ذبابة التورم',
      'Gallery': 'المعرض',
      'Guava': 'جوافة',
      'guava': 'جوافة',
      'healthy': 'سليم',
      'Healthy': 'سليم',
      'Home': 'الرئيسية',
      'Image preview is not available': 'معاينة الصورة غير متاحة',
      'Image URL (optional)': 'رابط الصورة (اختياري)',
      'Image URL must start with http or https':
          'يجب أن يبدأ رابط الصورة بـ http أو https',
      'Insecticide': 'مبيد حشري',
      'Irrigation': 'الري',
      'Items Sold': 'العناصر المباعة',
      'Language': 'اللغة',
      'Leaf Spot (Cercospora)': 'تبقع الأوراق (سركسبورا)',
      'Likely Causes': 'الأسباب المحتملة',
      'Loading...': 'جارٍ التحميل...',
      'Loading your merchant shop status...':
          'جارٍ تحميل حالة متجر التاجر الخاص بك...',
      'Manage Products': 'إدارة المنتجات',
      'Manage your agricultural shop easily': 'أدر متجرك الزراعي بسهولة',
      'Mango': 'مانجو',
      'mango': 'مانجو',
      'Media': 'الوسائط',
      'Merchant': 'تاجر',
      'Merchant Dashboard': 'لوحة تحكم التاجر',
      'Merchant tools': 'أدوات التاجر',
      'Monthly': 'شهري',
      'Mummification': 'التحنيط',
      'My Cart': 'سلتي',
      'My Shop': 'متجري',
      'N/A': 'غير متاح',
      'Name': 'الاسم',
      'Next': 'التالي',
      'No approval requests found.': 'لا توجد طلبات موافقة حاليًا.',
      'No description is available for this diagnosis.':
          'لا يوجد وصف متاح لهذا التشخيص.',
      'No image URL selected': 'لم يتم اختيار رابط صورة',
      'No Image Selected': 'لم يتم اختيار صورة',
      'No items available.': 'لا توجد عناصر متاحة.',
      'No orders found for this period.': 'لا توجد طلبات في هذه الفترة.',
      'No product sales in this period.':
          'لا توجد مبيعات منتجات في هذه الفترة.',
      'No products yet': 'لا توجد منتجات بعد',
      'No recommendations available.': 'لا توجد توصيات متاحة.',
      'No shop yet': 'لا يوجد متجر بعد',
      'Order Approvals': 'موافقات الطلبات',
      'Orders': 'الطلبات',
      'Order request approved.': 'تمت الموافقة على طلب الشراء.',
      'Order request rejected.': 'تم رفض طلب الشراء.',
      'Order request sent for merchant approval.':
          'تم إرسال طلبك إلى التاجر للموافقة.',
      'Organic treatment': 'العلاج العضوي',
      'Order placed successfully!': 'تم تنفيذ الطلب بنجاح!',
      'Other': 'أخرى',
      'Pending': 'قيد الانتظار',
      'pestalotiopsis': 'بيستالوتيوبسيس',
      'Phone': 'الهاتف',
      'Powdery Mildew': 'البياض الدقيقي',
      'Predict': 'تشخيص',
      'Prediction Result': 'نتيجة التشخيص',
      'Prevention': 'الوقاية',
      'Price': 'السعر',
      'Product': 'المنتج',
      'Product added successfully.': 'تمت إضافة المنتج بنجاح.',
      'Product updated successfully.': 'تم تحديث المنتج بنجاح.',
      'Product deleted successfully.': 'تم حذف المنتج بنجاح.',
      'Product Name': 'اسم المنتج',
      'Product must be linked to a shop.': 'يجب ربط المنتج بمتجر.',
      'Product name is required': 'اسم المنتج مطلوب',
      'Products': 'المنتجات',
      'Products you add will be linked to this shop.':
          'المنتجات التي تضيفها ستُربط بهذا المتجر.',
      'Profile': 'الملف الشخصي',
      'Pull down to refresh your shop status.': 'اسحب لأسفل لتحديث حالة متجرك.',
      'Qty': 'الكمية',
      'Quantity': 'الكمية',
      'Recommendations': 'التوصيات',
      'Rejected': 'مرفوض',
      'Reject': 'رفض',
      'Report Details': 'تفاصيل التقرير',
      'Review': 'مراجعة',
      'Review & Add': 'مراجعة وإضافة',
      'Revenue': 'الإيراد',
      'Revenue Trend': 'اتجاه الإيراد',
      'Risk': 'المخاطر',
      'Rust': 'الصدأ',
      'Sales': 'المبيعات',
      'Sales Analytics': 'تحليلات المبيعات',
      'Save Changes': 'حفظ التغييرات',
      'Scab': 'الجرب',
      'Scientific': 'الاسم العلمي',
      'Search treatments...': 'ابحث عن العلاجات...',
      'Select a leaf image first.': 'اختر صورة الورقة أولًا.',
      'Select disease': 'اختر المرض',
      'Select tree': 'اختر الشجرة',
      'Shop': 'المتجر',
      'Shop check failed': 'فشل التحقق من المتجر',
      'Shop Name': 'اسم المتجر',
      'Shop name is required': 'اسم المتجر مطلوب',
      'Shop name must be at least 3 characters':
          'يجب ألا يقل اسم المتجر عن 3 أحرف',
      'Shop updated successfully.': 'تم تحديث المتجر بنجاح.',
      'sigatoka': 'سيجاتوكا',
      'Sign Out': 'تسجيل الخروج',
      'Sooty Mould': 'العفن الهبابي',
      'success': 'نجاح',
      'This field is required': 'هذا الحقل مطلوب',
      'This tree already exists in the list. Please choose it from the list.':
          'هذه الشجرة موجودة بالفعل ضمن القائمة، برجاء اختيارها من القائمة.',
      'Top Products': 'أعلى المنتجات',
      'Total': 'الإجمالي',
      'Total:': 'الإجمالي:',
      'Treatment': 'العلاج',
      'Tree': 'الشجرة',
      'Type': 'النوع',
      'Unknown disease': 'مرض غير معروف',
      'Update': 'تحديث',
      'Update {name} as a {category} product?':
          'تحديث {name} كمنتج من فئة {category}؟',
      'Update Your Shop': 'حدّث متجرك',
      'Uploaded leaf image': 'صورة الورقة المرفوعة',
      'Use at least 3 characters': 'استخدم 3 أحرف على الأقل',
      'Weekly': 'أسبوعي',
      'Welcome Merchant': 'مرحبًا أيها التاجر',
      'Please sign in before adding products.':
          'يرجى تسجيل الدخول قبل إضافة المنتجات.',
      '{count} items sold': 'تم بيع {count} عنصر',
      '{pending} pending from {total} total requests':
          '{pending} طلبات معلقة من أصل {total} طلبات',
    },
  };

  static const Map<String, String> _fallbackArabicValues = {
    'Welcome': 'مرحبا',
    'Welcome Back': 'مرحبًا بعودتك',
    'Login': 'تسجيل الدخول',
    'Register': 'إنشاء حساب',
    'Sign Up': 'إنشاء حساب',
    'Password': 'كلمة المرور',
    'Confirm Password': 'تأكيد كلمة المرور',
    'Continue': 'استمر',
    'Continue with Google': 'المتابعة باستخدام جوجل',
    'Forgot Password': 'نسيت كلمة المرور',
    'Forgot Password?': 'نسيت كلمة المرور؟',
    'Create Account': 'إنشاء حساب',
    'Register now and enjoy the app': 'سجل الآن واستمتع بالتطبيق',
    'Full Name': 'الاسم الكامل',
    'E-mail': 'البريد الإلكتروني',
    'User Type': 'نوع المستخدم',
    'Already have an account?': 'لديك حساب بالفعل؟',
    'Login or create a new account to start using\nthe smart agriculture platform.':
        'سجل الدخول أو أنشئ حسابًا جديدًا لتبدأ استخدام\nمنصة الزراعة الذكية.',
    'or': 'أو',
    'Successful': 'تم بنجاح',
    'Your Email': 'بريدك الإلكتروني',
    'Reset Password': 'إعادة تعيين كلمة المرور',
    'Please enter your email to reset the password.':
        'يرجى إدخال بريدك الإلكتروني لإعادة تعيين كلمة المرور.',
    'Email is Invalid': 'البريد الإلكتروني غير صحيح',
    'This Field is required': 'هذا الحقل مطلوب',
    'Invalid email': 'البريد الإلكتروني غير صحيح',
    'Password is required': 'كلمة المرور مطلوبة',
    'Full name is required': 'الاسم الكامل مطلوب',
    'Invalid phone number': 'رقم الهاتف غير صحيح',
    'Password must be at least 6 characters':
        'يجب أن تكون كلمة المرور 6 أحرف على الأقل',
    'Passwords do not match.': 'كلمتا المرور غير متطابقتين.',
    'Unable to create the account. Please try again.':
        'تعذر إنشاء الحساب. يرجى المحاولة مرة أخرى.',
    'The password provided is too weak.': 'كلمة المرور المدخلة ضعيفة جدًا.',
    'The account already exists for that email.':
        'هذا البريد الإلكتروني مسجل بالفعل.',
    'Unable to sign in. Please check your credentials.':
        'تعذر تسجيل الدخول. يرجى مراجعة بياناتك.',
    'No user found for that email.': 'لا يوجد مستخدم مسجل بهذا البريد.',
    'Wrong password provided for that user.': 'كلمة المرور غير صحيحة.',
    'Google sign-in is not supported on this platform.':
        'تسجيل الدخول بجوجل غير مدعوم على هذه المنصة.',
    'Google sign-in did not return a valid identity token.':
        'لم يقم تسجيل الدخول بجوجل بإرجاع رمز هوية صحيح.',
    'Google sign-in failed. Please try again.':
        'فشل تسجيل الدخول بجوجل. يرجى المحاولة مرة أخرى.',
    'Google sign-in was cancelled.': 'تم إلغاء تسجيل الدخول بجوجل.',
    'Google sign-in UI is not available on this device.':
        'واجهة تسجيل الدخول بجوجل غير متاحة على هذا الجهاز.',
    'Google sign-in failed. Check Google OAuth setup and try again.':
        'فشل تسجيل الدخول بجوجل. تأكد من إعدادات Google OAuth ثم أعد المحاولة.',
    'This email is already linked to another sign-in method.':
        'هذا البريد مرتبط بطريقة تسجيل دخول أخرى.',
    'Google returned invalid credentials. Please try again.':
        'أعاد جوجل بيانات اعتماد غير صحيحة. يرجى المحاولة مرة أخرى.',
    'Network error during Google sign-in. Check your connection.':
        'حدث خطأ في الشبكة أثناء تسجيل الدخول بجوجل. تحقق من الاتصال.',
    'Google sign-in is not fully configured in Firebase. Enable Google provider and add the Android SHA keys.':
        'تسجيل الدخول بجوجل لم يكتمل إعداده في Firebase. فعّل مزود Google وأضف مفاتيح Android SHA.',
    'Firebase could not complete Google sign-in.':
        'لم يتمكن Firebase من إكمال تسجيل الدخول بجوجل.',
    'Google sign-in is not configured for Android yet. Add a Web OAuth client in Firebase and re-download google-services.json, or provide GOOGLE_SERVER_CLIENT_ID.':
        'تسجيل الدخول بجوجل غير معد بعد لأندرويد. أضف Web OAuth client في Firebase وأعد تحميل google-services.json أو مرر GOOGLE_SERVER_CLIENT_ID.',
    'Delivery Details': 'بيانات التوصيل',
    'Fill in your delivery information before checkout.':
        'أدخل بيانات التوصيل قبل إتمام الشراء.',
    'Recipient Name': 'اسم المستلم',
    'Recipient name is required': 'اسم المستلم مطلوب',
    'Governorate': 'المحافظة',
    'Governorate is required': 'المحافظة مطلوبة',
    'Delivery Address': 'عنوان التوصيل',
    'Delivery address is required': 'عنوان التوصيل مطلوب',
    'Phone is required': 'رقم الهاتف مطلوب',
    'Enter a valid phone number': 'أدخل رقم هاتف صحيح',
    'Place Type': 'نوع المكان',
    'House': 'منزل',
    'Workplace': 'محل عمل',
    'Preferred availability': 'مواعيد التواجد',
    'Preferred availability is required': 'مواعيد التواجد مطلوبة',
    'Location availability': 'مواعيد التواجد في المكان',
    'Location availability is required': 'مواعيد التواجد في المكان مطلوبة',
    'Submit Order': 'إرسال الطلب',
    'New order approval request received.': 'تم استلام طلب موافقة جديد.',
    '{count} new order approval requests received.':
        'تم استلام {count} طلبات موافقة جديدة.',
    'Open Dashboard': 'افتح لوحة التحكم',
    'Cairo': 'القاهرة',
    'Giza': 'الجيزة',
    'Alexandria': 'الإسكندرية',
    'Dakahlia': 'الدقهلية',
    'Red Sea': 'البحر الأحمر',
    'Beheira': 'البحيرة',
    'Fayoum': 'الفيوم',
    'Gharbia': 'الغربية',
    'Ismailia': 'الإسماعيلية',
    'Menofia': 'المنوفية',
    'Minya': 'المنيا',
    'Qalyubia': 'القليوبية',
    'New Valley': 'الوادي الجديد',
    'Suez': 'السويس',
    'Aswan': 'أسوان',
    'Assiut': 'أسيوط',
    'Beni Suef': 'بني سويف',
    'Port Said': 'بورسعيد',
    'Damietta': 'دمياط',
    'Sharkia': 'الشرقية',
    'South Sinai': 'جنوب سيناء',
    'Kafr El Sheikh': 'كفر الشيخ',
    'Matrouh': 'مطروح',
    'Luxor': 'الأقصر',
    'Qena': 'قنا',
    'North Sinai': 'شمال سيناء',
    'Sohag': 'سوهاج',
    '08:00 AM - 10:00 AM': '08:00 ص - 10:00 ص',
    '10:00 AM - 12:00 PM': '10:00 ص - 12:00 م',
    '12:00 PM - 02:00 PM': '12:00 م - 02:00 م',
    '02:00 PM - 04:00 PM': '02:00 م - 04:00 م',
    '04:00 PM - 06:00 PM': '04:00 م - 06:00 م',
    '06:00 PM - 08:00 PM': '06:00 م - 08:00 م',
    '08:00 PM - 10:00 PM': '08:00 م - 10:00 م',
    'Reset Shop': 'تصفير المتجر',
    'Delete Shop': 'حذف المتجر',
    'Delete this shop and all products inside it? This action cannot be undone.':
        'سيتم حذف هذا المتجر وكل المنتجات الموجودة بداخله نهائيًا. لا يمكن التراجع عن هذا الإجراء.',
    'Please sign in before deleting a shop.':
        'يرجى تسجيل الدخول قبل حذف المتجر.',
    'Shop and its products were removed successfully.':
        'تم حذف المتجر وكل المنتجات التابعة له بنجاح.',
  };

  String translate(String key, {Map<String, String>? params}) {
    var value =
        _localizedValues[locale.languageCode]?[key] ??
        (locale.languageCode == 'ar' ? _fallbackArabicValues[key] : null) ??
        key;
    if (params != null) {
      for (final entry in params.entries) {
        value = value.replaceAll('{${entry.key}}', entry.value);
      }
    }
    return value;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales.any(
    (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
  );

  @override
  Future<AppLocalizations> load(Locale locale) {
    return Future.value(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
