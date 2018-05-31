create or replace package test_ut_utils is

  --%suite
  --%suitepath(utplsql.core)

  --%test
  procedure test_clob_to_table;

  --%test
  procedure test_to_char;

  --%test
  procedure test_to_string_blob;

  --%test
  procedure test_to_string_clob;

  --%test
  procedure test_to_string_date;

  --%test
  procedure to_string_null;

  --%test
  procedure to_string;

  --%test(Trims long Blob to max lenght and appends '[...]' at the end of string)
  procedure to_string_big_blob;

  --%test(Trims long Clob to max lenght and appends '[...]' at the end of string)
  procedure to_string_big_clob;

  --%test(Returns a full string representation of a very big number)
  procedure to_string_big_number;

  --%test(Trims long varchars to max lenght and appends '[...]' at the end of string)
  procedure to_string_big_varchar2;

  --%test(Returns a full string representation of a very small number)
  procedure to_string_big_tiny_number;

  --%test(Table to clob function test)
  procedure test_table_to_clob;

  --%test(append_to_clob works With Multi Byte Chars)
  --%beforetest(setup_append_with_multibyte)
  --%aftertest(clean_append_with_multibyte)
  procedure test_append_with_multibyte;
  procedure setup_append_with_multibyte;
  procedure clean_append_with_multibyte;

  --%test(clob_to_table multibyte)
  --%disabled(We cannot run this test successfully on 12.1 until we change NLSCHARACTERSET from US7ASCII to AL32UTF8)
  procedure test_clob_to_table_multibyte;

  --%test(to_version splits version string into individual version components)
  procedure test_to_version_split;

  --%test(Trims the elements of a collection)
  procedure test_trim_list_elements;
  
  --%test(Trim list elements with null collection)
  procedure trim_list_elemts_null_collect;
  
  --%test(Trim list elements with empty collection)
  procedure trim_list_elemts_empty_collect;

  --%test(Filters the collection's elements)
  procedure test_filter_list;

  --%test(Filter list elements with null collection)
  procedure filter_list_null_collection;
  
  --%test(Filter list elements with empty collection)
  procedure filter_list_empty_collection;

  --%test(Replace multi-line comments with empty lines)
  procedure replace_multiline_comments;

end test_ut_utils;
/
