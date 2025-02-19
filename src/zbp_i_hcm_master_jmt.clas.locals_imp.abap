CLASS lcl_buffer DEFINITION.
  PUBLIC SECTION.
    CONSTANTS: created TYPE c LENGTH 1 VALUE 'C',
               updated TYPE c LENGTH 1 VALUE 'U',
               deleted TYPE c LENGTH 1 VALUE 'D'.
    TYPES: BEGIN OF ty_buffer_master.
             INCLUDE TYPE zhc_master_jmt AS data.
    TYPES:   flag TYPE c LENGTH 1,
           END OF ty_buffer_master.
    TYPES: tt_master TYPE SORTED TABLE OF ty_buffer_master
    WITH UNIQUE KEY e_number.
    CLASS-DATA mt_buffer_master TYPE tt_master.
ENDCLASS.

CLASS lhc_HCMMaster DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR HCMMaster RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE HCMMaster.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE HCMMaster.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE HCMMaster.

    METHODS read FOR READ
      IMPORTING keys FOR READ HCMMaster RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK HCMMaster.

ENDCLASS.

CLASS lhc_HCMMaster IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.

    GET TIME STAMP FIELD DATA(lv_time_stamp).
    DATA(lv_uname) =
    cl_abap_context_info=>get_user_technical_name( ).
    SELECT MAX( e_number ) FROM zhc_master_jmt
    INTO @DATA(lv_max_employee_number).
    LOOP AT entities INTO DATA(ls_entities).
      ls_entities-%data-crea_date_time = lv_time_stamp.
      ls_entities-%data-crea_uname = lv_uname.
      ls_entities-%data-e_number =
      lv_max_employee_number + 1.
      INSERT VALUE #( flag = lcl_buffer=>created
      data = CORRESPONDING #( ls_entities-%data ) ) INTO TABLE lcl_buffer=>mt_buffer_master.
      IF NOT ls_entities-%cid IS INITIAL.
        INSERT VALUE #( %cid = ls_entities-%cid
        e_number = ls_entities-e_number )
        INTO TABLE mapped-hcmmaster.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_Z_I_HCM_MASTER_JMT DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_Z_I_HCM_MASTER_JMT IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.

    DATA: lt_data_created TYPE STANDARD TABLE OF zhc_master_jmt,
          lt_data_updated TYPE STANDARD TABLE OF zhc_master_jmt,
          lt_data_deleted TYPE STANDARD TABLE OF zhc_master_jmt.
    lt_data_created = VALUE #( FOR <row> IN
    lcl_buffer=>mt_buffer_master
    WHERE ( flag = lcl_buffer=>created )
    ( <row>-data ) ).
    IF NOT lt_data_created IS INITIAL.
      INSERT zhc_master_jmt FROM TABLE @lt_data_created.
    ENDIF.
    lt_data_updated = VALUE #( FOR <row> IN
    lcl_buffer=>mt_buffer_master
    WHERE ( flag = lcl_buffer=>updated ) (
    <row>-data ) ).
    IF NOT lt_data_updated IS INITIAL.
      UPDATE zhc_master_jmt FROM TABLE @lt_data_updated.
    ENDIF.
    lt_data_deleted = VALUE #( FOR <row> IN
    lcl_buffer=>mt_buffer_master
    WHERE ( flag = lcl_buffer=>deleted ) (
    <row>-data ) ).
    IF NOT lt_data_deleted IS INITIAL.
      DELETE zhc_master_jmt FROM TABLE @lt_data_deleted.
    ENDIF.
    CLEAR lcl_buffer=>mt_buffer_master.

  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
