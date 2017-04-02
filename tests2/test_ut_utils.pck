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
  

end test_ut_utils;
/
create or replace package body test_ut_utils is

  procedure common_clob_to_table_exec(p_clob varchar2, p_delimiter varchar2, p_expected_list ut_varchar2_list, p_limit number) is
  begin
    execute immediate 'declare
  l_clob       clob := '''||p_clob||''';
  l_delimiter  varchar2(1) := '''||p_delimiter||''';
  l_expected   ut_varchar2_list := :p_expected_list;
  l_result     ut_varchar2_list;
  l_limit      integer := '||p_limit||q'[;
  l_result_str varchar2(32767);
  l_errors     integer := 0;
  function compare_element(a_element_id integer, a_expected ut_varchar2_list, a_actual ut_varchar2_list) return integer is
  begin
    if a_expected.exists(a_element_id) and a_actual.exists(a_element_id) then
      if a_expected(a_element_id) = a_actual(a_element_id) or a_expected(a_element_id) is null and  a_actual(a_element_id) is null then
        return 0;
      else
        dbms_output.put('a_expected('||a_element_id||')='||a_expected(a_element_id)||' | a_actual('||a_element_id||')='||a_actual(a_element_id));
      end if;
    end if;
    if not a_expected.exists(a_element_id) then
      dbms_output.put('a_expected('||a_element_id||') does not exist ');
    end if;
    if not a_actual.exists(a_element_id) then
      dbms_output.put('a_actual('||a_element_id||') does not exist ');
    end if;
    dbms_output.put_line(null);
    return 1;
  end;
begin
--Act
  select column_value bulk collect into l_result from table( ut_utils.clob_to_table(l_clob, l_limit, l_delimiter) );
  for i in 1 .. l_result.count loop
    l_result_str := l_result_str||''''||l_result(i)||''''||l_delimiter;
  end loop;
  l_result_str := rtrim(l_result_str,l_delimiter);
--Assert
  for i in 1 .. greatest(l_expected.count, l_result.count) loop
    l_errors := l_errors + compare_element(i, l_expected, l_result);
  end loop;
  ut.expect(l_errors).to_equal(0);
end;]' using p_expected_list;
  end;

  procedure test_clob_to_table is
  begin
    common_clob_to_table_exec('a,b,c,d', ',', ut_varchar2_list('a','b','c','d'), 1000);
    common_clob_to_table_exec( '', ',', ut_varchar2_list(), 1000);
    common_clob_to_table_exec( '1,b,c,d', '', ut_varchar2_list('1,b,','c,d'), 4);
    common_clob_to_table_exec( 'abcdefg,hijk,axa,a', ',', ut_varchar2_list('abc','def','g','hij','k','axa','a'), 3);
    common_clob_to_table_exec( ',a,,c,d,', ',', ut_varchar2_list('','a','','c','d',''), 1000);
  end;
  
  procedure test_to_char is
  begin
    ut.expect(ut_utils.test_result_to_char(-1),'test unknown').to_equal('Unknown(-1)');
    ut.expect(ut_utils.test_result_to_char(null),'test unknown').to_equal('Unknown(NULL)');
    ut.expect(ut_utils.test_result_to_char(ut_utils.tr_success),'test unknown').to_equal(ut_utils.tr_success_char);
  end;
  
  procedure test_to_string_blob is
    l_text     varchar2(32767) := 'A test char';
    l_value    blob := utl_raw.cast_to_raw(l_text);
    l_expected varchar2(32767) := ''''||rawtohex(l_value)||'''';    
    l_result   varchar2(32767);
  begin
    l_result :=  ut_utils.to_String(l_value);
    ut.expect(l_result).to_equal(l_expected);
  end;
  
  procedure test_to_string_clob is
  l_value    clob := 'A test char';
  l_expected varchar2(32767) := ''''||l_value||'''';
  l_result   varchar2(32767);
  begin
    l_result :=  ut_utils.to_String(l_value);
    ut.expect(l_result).to_equal(l_expected);
  end;  
  
  procedure test_to_string_date is
  l_value    date := to_date('2016-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
  l_expected varchar2(100) := '2016-12-31T23:59:59';
  l_result   varchar2(32767);
  begin
    l_result :=  ut_utils.to_String(l_value);
    ut.expect(l_result).to_equal(l_expected);
  end;
  
  procedure to_string_null is
  begin
    ut.expect(ut_utils.to_String(to_blob(NULL))).to_equal('NULL');
    ut.expect(ut_utils.to_String(to_clob(NULL))).to_equal('NULL');
    ut.expect(ut_utils.to_String(to_date(NULL))).to_equal('NULL');
    ut.expect(ut_utils.to_String(to_number(NULL))).to_equal('NULL');
    ut.expect(ut_utils.to_String(to_timestamp(NULL))).to_equal('NULL');
  end;
  
  procedure to_string is
    l_value    timestamp(9) := to_timestamp('2016-12-31 23:59:59.123456789', 'yyyy-mm-dd hh24:mi:ss.ff');
    l_value2    timestamp(9) with local time zone:= to_timestamp('2016-12-31 23:59:59.123456789', 'yyyy-mm-dd hh24:mi:ss.ff');
    l_value3    timestamp(9) with time zone := to_timestamp_tz('2016-12-31 23:59:59.123456789 -8:00', 'yyyy-mm-dd hh24:mi:ss.ff tzh:tzm');
    l_value4    varchar2(20) := 'A test char';
    l_expected varchar2(100);
    l_result   varchar2(100);
    l_delimiter varchar2(10);
  begin
    select substr(value, 1, 1) into l_delimiter from nls_session_parameters t where t.parameter = 'NLS_NUMERIC_CHARACTERS';
    l_expected := '2016-12-31T23:59:59'||l_delimiter||'123456789';
    
    l_result :=  ut_utils.to_String(l_value);
    ut.expect(l_result,'Returns a full string representation of a timestamp with maximum precission').to_equal(l_expected);
    
    l_expected := '2016-12-31T23:59:59'||l_delimiter||'123456789';
    l_result :=  ut_utils.to_String(l_value2);
    ut.expect(l_result,'Returns a full string representation of a timestamp with maximum precission').to_equal(l_expected);    

    l_expected := '2016-12-31T23:59:59'||l_delimiter||'123456789 -08:00';
    
    l_result :=  ut_utils.to_String(l_value3);
    ut.expect(l_result,'Returns a full string representation of a timestamp with maximum precission').to_equal(l_expected);    
    
    l_expected := ''''||l_value4||'''';    
    l_result :=  ut_utils.to_String(l_value4);
    ut.expect(l_result,'Returns a varchar2 eclosed in quotes').to_equal(l_expected);    
    
  end;
  
  procedure to_string_big_blob is
    l_text     clob := lpad('A test char',32767,'1')||lpad('1',32767,'1');
    l_value    blob;
    l_result   varchar2(32767);
    l_delimiter varchar2(1);
    function clob_to_blob(p_clob clob) return blob
    as
      l_blob          blob;
      l_dest_offset   integer := 1;
      l_source_offset integer := 1;
      l_lang_context  integer := dbms_lob.default_lang_ctx;
      l_warning       integer := dbms_lob.warn_inconvertible_char;
    begin
      dbms_lob.createtemporary(l_blob, true);
      dbms_lob.converttoblob(
        dest_lob    =>l_blob,
        src_clob    =>p_clob,
        amount      =>DBMS_LOB.LOBMAXSIZE,
        dest_offset =>l_dest_offset,
        src_offset  =>l_source_offset,
        blob_csid   =>DBMS_LOB.DEFAULT_CSID,
        lang_context=>l_lang_context,
        warning     =>l_warning
      );
      return l_blob;
    end;
  begin
    l_value := clob_to_blob(l_text);
  --Act
    l_result :=  ut_utils.to_String(l_value);
  --Assert
    ut.EXPECT(length(l_result)).to_equal(ut_utils.gc_max_output_string_length);
    ut.EXPECT(l_result).to_be_like('%'||ut_utils.gc_more_data_string);

  end;
  
  procedure to_string_big_clob is
    l_value    clob := lpad('A test char',32767,'1')||lpad('1',32767,'1');
    l_result   varchar2(32767);
    l_delimiter varchar2(1);
  begin
  --Act
    l_result :=  ut_utils.to_String(l_value);
  --Assert
    ut.EXPECT(length(l_result)).to_equal(ut_utils.gc_max_output_string_length);
    ut.EXPECT(l_result).to_be_like('%'||ut_utils.gc_more_data_string);
  end;
  
  procedure to_string_big_number is
    l_value    number := 1234567890123456789012345678901234567890;
    l_expected varchar2(100) := '1234567890123456789012345678901234567890';
    l_result   varchar2(100);
  begin
  --Act
    l_result :=  ut_utils.to_String(l_value);
  --Assert
    ut.expect(l_result).TO_equal(l_expected);
  end;
  
  procedure to_string_big_varchar2 is
    l_value    varchar2(32767) := lpad('A test char',32767,'1');
    l_result   varchar2(32767);
    l_delimiter varchar2(1);
  begin
  --Act
    l_result :=  ut_utils.to_String(l_value);
  --Assert
    ut.EXPECT(length(l_result)).to_equal(ut_utils.gc_max_output_string_length);
    ut.EXPECT(l_result).to_be_like('%'||ut_utils.gc_more_data_string);
  end;

  procedure to_string_big_tiny_number is
    l_value    number := 0.123456789012345678901234567890123456789;
    l_expected varchar2(100);
    l_result   varchar2(100);
    l_delimiter varchar2(1);
  begin
  --Act
    select substr(value, 1, 1) into l_delimiter from nls_session_parameters t where t.parameter = 'NLS_NUMERIC_CHARACTERS';
    l_expected := l_delimiter||'123456789012345678901234567890123456789';
    
    l_result :=  ut_utils.to_String(l_value);
    
  --Assert
    ut.expect(l_result).TO_equal(l_expected);

  end;

end test_ut_utils;
/
