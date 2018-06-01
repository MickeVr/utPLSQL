CREATE OR REPLACE TYPE BODY ut_be_close_to IS
   MEMBER PROCEDURE init(self IN OUT NOCOPY ut_be_close_to, a_value ut_data_value, a_precision ut_data_value) IS
   BEGIN
      self.self_type := $$plsql_unit;
      self.data_value := a_value;
      self.data_precision := a_precision;
   END;

   CONSTRUCTOR FUNCTION ut_be_close_to(self IN OUT NOCOPY ut_be_close_to, a_value NUMBER, a_precision NUMBER)
      RETURN SELF AS RESULT IS
   BEGIN
      init(ut_data_value_number(a_value), ut_data_value_number(a_precision));
      RETURN;
   END;
   OVERRIDING MEMBER FUNCTION run_matcher(self IN OUT NOCOPY ut_be_close_to, a_actual ut_data_value)
      RETURN BOOLEAN IS
      l_lower_result          BOOLEAN;
      l_upper_result          BOOLEAN;
      l_result                BOOLEAN;
      l_actual                ut_data_value_number;
      l_self_data_value       ut_data_value_number;
      l_self_data_precision   ut_data_value_number;
   BEGIN
      IF self.data_value IS OF (ut_data_value_number) AND a_actual IS OF (ut_data_value_number) AND self.data_precision IS OF (ut_data_value_number) THEN
         l_actual := TREAT(a_actual AS ut_data_value_number);
         l_self_data_value := TREAT(self.data_value AS ut_data_value_number);
         l_self_data_precision := TREAT(self.data_precision AS ut_data_value_number);
         l_result :=
            TO_CHAR(ROUND(l_actual.data_value, l_self_data_precision.data_value)) =
               TO_CHAR(ROUND(l_self_data_value.data_value, l_self_data_precision.data_value));
      ELSE
         l_result := (self AS ut_matcher).run_matcher(a_actual);
      END IF;

      RETURN l_result;
   END;
   OVERRIDING MEMBER FUNCTION failure_message(a_actual ut_data_value)
      RETURN VARCHAR2 IS
   BEGIN
      RETURN (self AS ut_matcher).failure_message(a_actual) || ': ' || self.data_value.to_string_report(TRUE, FALSE) ||
             ' with a precision of the first ' || self.data_precision.to_string_report(a_with_object_info => FALSE) || ' decimals';
   END;
   OVERRIDING MEMBER FUNCTION failure_message_when_negated(a_actual ut_data_value)
      RETURN VARCHAR2 IS
   BEGIN
      RETURN (self AS ut_matcher).failure_message_when_negated(a_actual) || ': ' || self.data_value.to_string_report(TRUE, FALSE) ||
             ' with a precision of the first ' || self.data_precision.to_string_report(a_with_object_info => FALSE) || ' decimals';
   END;
END;
/