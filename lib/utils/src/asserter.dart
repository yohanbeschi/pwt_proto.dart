part of pwt_utils;

void assertTrue(bool value) {
  assert(value);
}

void assertIntRange(int min, int max, int value) {
  assert(value >= min && value <= max);
}

void assertNumRange(num min, num max, num value) {
  assert(value >= min && value <= max);
}