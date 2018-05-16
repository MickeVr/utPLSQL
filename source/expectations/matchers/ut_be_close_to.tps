create or replace type ut_be_close_to under ut_matcher(
  data_value ut_data_value,
  data_precision ut_data_value,
  member procedure init(self in out nocopy ut_be_close_to, a_value ut_data_value, a_precision ut_data_value),
  constructor function ut_be_close_to(self in out nocopy ut_be_close_to, a_value number, a_precision number)
    return self as result,
  overriding member function run_matcher(self in out nocopy ut_be_close_to, a_actual ut_data_value) return boolean,
  overriding member function failure_message(a_actual ut_data_value) return varchar2,
  overriding member function failure_message_when_negated(a_actual ut_data_value) return varchar2
)
/
