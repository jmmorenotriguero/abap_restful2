FUNCTION z_suppl_jmt.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IT_SUPPLEMENTS) TYPE  ZTT_SUPPL_JMT
*"     REFERENCE(IV_OP_TYPE) TYPE  ZDE_FLAG_JMT
*"  EXPORTING
*"     REFERENCE(EV_UPDATED) TYPE  ZDE_FLAG_JMT
*"----------------------------------------------------------------------
  CHECK NOT it_supplements IS INITIAL.
  CASE iv_op_type.
    WHEN 'C'.
      INSERT ztb_booksupp_jmt FROM TABLE
      @it_supplements.
    WHEN 'U'.
      UPDATE ztb_booksupp_jmt FROM TABLE
      @it_supplements.
    WHEN 'D'.
      DELETE ztb_booksupp_jmt FROM TABLE
      @it_supplements.
  ENDCASE.
  IF sy-subrc EQ 0.
    ev_updated = abap_true.
  ENDIF.



ENDFUNCTION.
