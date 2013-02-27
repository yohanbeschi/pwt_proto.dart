part of pwt_utils;

bool isEmpty(String s) => s == null;

bool isNotEmpty(String s) => !isEmpty(s);

bool isBlank(String s) => isEmpty(s) || s.length == 0;

bool isNotBlank(String s) => !isBlank(s);

bool isSpace(String s) => isNotBlank(s) && (s == ' ' || s == '\t');

bool isNotSpace(String s) => !isSpace(s);

/**
* Converts property names with hyphens to camelCase.
*
* @param {String} text A property name
* @returns {String} text A camelCase property name
*/
String camelCase(final String s)
  => s.replaceAllMapped(new RegExp(r'-([a-z])', caseSensitive : false), 
                     (Match match) => match.group(1).toUpperCase());

/**
* Converts property names in camelCase to ones with hyphens.
*
* @param {String} text A property name
* @returns {String} text A camelCase property name
*/
String uncamel(final String s)
  => s.replaceAllMapped(new RegExp(r'([A-Z])'), 
                      (Match match) => '-${match.group(0).toLowerCase()}');


List<String> splitAtSpaces(final String string) {
  if (isNotBlank(string)) {
    final List<String> list = new List<String>();
    StringBuffer sb = new StringBuffer();
    
    String s;
    for (int i = 0; i <= string.length; i++) {
      if(i == string.length || isSpace(s = string[i])) {
        if (!sb.isEmpty) {
          list.add(sb.toString());
          sb = new StringBuffer();
        }
      } else {
        sb.write(s);
      }
    }
    
    return list;
  } else {
    return null;
  }
}