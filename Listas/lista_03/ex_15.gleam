/// Produz True se uma pessoa com a *idade* é supercentenária,
/// isto é, tem 110 anos ou mais, False caso contrário.

import sgleam/check

pub fn supercentenario(n: Int) -> Bool {
  case n >= 110 {
    True -> True
    False -> False
  }
}

pub fn supercentenario_examples() {
  check.eq(supercentenario(101), False)
  check.eq(supercentenario(110), True)
  check.eq(supercentenario(112), True)
}