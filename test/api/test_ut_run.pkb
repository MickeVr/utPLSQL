create or replace package body test_ut_run is

  procedure create_test_suite is
    pragma autonomous_transaction;
  begin
    execute immediate q'[
      create or replace package stateful_package as
        g_state varchar2(1) := 'A';
      end;
    ]';
    execute immediate q'[
      create or replace package test_stateful as
        --%suite
        --%suitepath(test_state)

        --%test
        procedure stateful_success;

        --%test
        --%beforetest(recompile_in_background)
        procedure failing_stateful_test;

        procedure recompile_in_background;

        --%test
        procedure dummy_success;

      end;
    ]';
    execute immediate q'{
    create or replace package body test_stateful as

      procedure stateful_success is
      begin
        ut3.ut.expect(stateful_package.g_state).to_equal('A');
      end;

      procedure failing_stateful_test is
      begin
        ut3.ut.expect(stateful_package.g_state).to_equal('abc');
      end;

      procedure dummy_success is
      begin
        ut3.ut.expect(1).to_equal(1);
      end;

      procedure recompile_in_background is
        l_job_name varchar2(30) := 'recreate_stateful_package';
        l_cnt      integer      := 1;
        pragma autonomous_transaction;
      begin
        dbms_scheduler.create_job(
          job_name      =>  l_job_name,
          job_type      =>  'PLSQL_BLOCK',
          job_action    =>  q'/
            begin
              execute immediate q'[
                create or replace package stateful_package as
                  g_state varchar2(3) := 'abc';
                end;]';
            end;/',
          start_date    =>  sysdate,
          enabled       =>  TRUE,
          auto_drop     =>  TRUE,
          comments      =>  'one-time job'
        );
        dbms_lock.sleep(0.2);
        while l_cnt > 0 loop
          select count(1) into l_cnt
            from dba_scheduler_running_jobs srj
           where srj.job_name = l_job_name;
        end loop;
      end;
    end;
    }';

  end;

  procedure raise_in_invalid_state is
    l_results   ut3.ut_varchar2_list;
    l_expected  varchar2(32767);
  begin
    --Arrange
    l_expected := 'test_state
  test_stateful
    stateful_success [% sec]
    failing_stateful_test [% sec] (FAILED - 1)
    dummy_success [% sec]%
Failures:%
  1) failing_stateful_test
      ORA-04061: existing state of package "UT3_TESTER.STATEFUL_PACKAGE" has been invalidated
      ORA-04065: not executed, altered or dropped package "UT3_TESTER.STATEFUL_PACKAGE"
      ORA-06508: PL/SQL: could not find program unit being called: "UT3_TESTER.STATEFUL_PACKAGE"
      ORA-06512: at "UT3_TESTER.TEST_STATEFUL", line 10%
      ORA-06512: at line 6%
3 tests, 0 failed, 1 errored, 0 disabled, 0 warning(s)%';

    --Act
    select * bulk collect into l_results from table(ut3.ut.run('test_stateful'));
    --Assert
    ut.fail('Expected exception but nothing was raised');
  exception
    when others then
      ut.expect( ut3.ut_utils.table_to_clob(l_results) ).to_be_like( l_expected );
      ut.expect(sqlcode).to_equal(-4068);
  end;

  procedure drop_test_suite is
    pragma autonomous_transaction;
  begin
    execute immediate 'drop package stateful_package';
    execute immediate 'drop package test_stateful';
  end;

end;
/
