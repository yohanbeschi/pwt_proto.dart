part of pwt_utils;

bool isEmptyList(List list) {
  return list == null || list.isEmpty;
}

bool isNotEmptyList(List list) {
  return !isEmptyList(list);
}

