bool isBankLoaded=false;
bool isCurrencyLoaded=false;
bool isRateLoaded=false;

late Future<List<dynamic>> rateBankGrouped;
late Future<List<dynamic>> rateCurrencyGrouped;


//late Future<Map<String, List<Map<String, dynamic>>>> rateCurrencyGrouped;
//late Future<Map<String, List<Map<String, dynamic>>>> highRatePerCurrency;

// List<Map<String, dynamic>> currecy = [
//   {"id": 1, "name": "USD", "description": "US Dollar", "logo": "usa.png"},
//   {"id": 2, "name": "GBP", "description": "Pound Sterling", "logo": "uk.png"},
//   {"id": 3, "name": "SAR", "description": "SAUDI Rial", "logo": "sar.png"},
//   {"id": 4, "name": "EUR", "description": "euro", "logo": "uro.png"},
//   {"id": 5, "name": "AED", "description": "UAE-Drham", "logo": "drm.png"},
//   {"id": 6, "name": "CAD", "description": "Canada Dollar", "logo": "cad.png"},
//   {"id": 7, "name": "CHF", "description": "Swis Frank", "logo": "chf.png"},
//   {
//     "id": 8,
//     "name": "SEK",
//     "description": "SWEDISH KRONER",
//     "logo": "chf.png"
//   },
//   {
//     "id": 9,
//     "name": "NOK",
//     "description": "NORWEGIAN KRONER",
//     "logo": "chf.png"
//   },
//   {
//     "id": 10,
//     "name": "DKK",
//     "description": "DANISH KRONER",
//     "logo": "DKK.png"
//   },
//   {
//     "id": 11,
//     "name": "DJF",
//     "description": "DJIBOUTI FRANC",
//     "logo": "DJF.png"
//   },
//   {
//     "id": 13,
//     "name": "ZAR",
//     "description": "SOUTH AFRICAN RAND",
//     "logo": "zar.png"
//   },
//   {
//     "id": 14,
//     "name": "AUD",
//     "description": "AUSTRALIAN DOLLAR",
//     "logo": "aud.png"
//   },
//   {
//     "id": 15,
//     "name": "KES",
//     "description": "KENNYAN SHILLING",
//     "logo": "KES.png"
//   },
//   {"id": 18, "name": "CNY", "description": "CHINESE YUAN", "logo": "cyn.png"},
//   {
//     "id": 19,
//     "name": "KWD",
//     "description": "KUWAITI DINAR",
//     "logo": "KWD.png"
//   },
//   {"id": 20, "name": "INR", "description": "Indina Rupe", "logo": "inr.png"},
//   {"id": 21, "name": "JPY", "description": "japanes Yen", "logo": "jpy.png"}
// ];


