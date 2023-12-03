*&---------------------------------------------------------------------*
*& Report ZMB_USER_DETAILS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmb_user_details.



TYPE-POOLS: slis .
DATA: it_tab       TYPE STANDARD TABLE OF zst_user,
      wa_tab       TYPE zst_user,
      lv_fm_detail TYPE rs38l_fnam.

PARAMETERS: p_userId TYPE xubname,
            p_dateC  TYPE dats.



SELECT ua~name_first
       ua~name_last
       ua~company
       ag~agr_name
       us02~class
       pu~smtp_addr    INTO TABLE it_tab
       FROM user_addr  AS ua  INNER JOIN usr02 AS us02
       ON ua~bname = us02~bname
       INNER JOIN puser002 AS pu
       ON pu~bname = ua~bname
       LEFT  JOIN  agr_users AS ag
       ON ua~bname =  ag~uname
       WHERE ua~bname = p_userid AND us02~erdat = p_datec .


DATA:it_design_alv  TYPE slis_t_fieldcat_alv,
     wa_design_alv  TYPE slis_fieldcat_alv,
     it_sort_fields TYPE slis_t_sortinfo_alv,
     wa_sort_fields TYPE slis_sortinfo_alv,
     wa_layout_alv  TYPE slis_layout_alv.
.
CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    i_callback_program      = sy-repid
    i_callback_user_command = 'USER_DETAILS'
    i_structure_name        = 'zst_user'
    is_layout               = wa_layout_alv
    it_fieldcat             = it_design_alv
    it_sort                 = it_sort_fields
  TABLES
    t_outtab                = it_tab.










FORM user_details USING
                         p_ucomm TYPE sy-ucomm
                         p_selfdetails TYPE slis_selfield ."selection field detail
  DATA: v_hold TYPE BAPIBNAME-BAPIBNAME .
  READ TABLE it_tab INTO DATA(w_detail) INDEX p_selfdetails-tabindex .
  v_hold = w_detail-last_name.


  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname = 'ZMB_USER_DATA'
*     VARIANT  = ' '
*     DIRECT_CALL              = ' '
    IMPORTING
      fm_name  = lv_fm_detail.
* EXCEPTIONS
*   NO_FORM                  = 1
*   NO_FUNCTION_MODULE       = 2
*   OTHERS                   = 3
  .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
   CALL FUNCTION lv_fm_detail
    EXPORTING
*     ARCHIVE_INDEX              =
*     ARCHIVE_INDEX_TAB          =
*     ARCHIVE_PARAMETERS         =
*     CONTROL_PARAMETERS         =
*     MAIL_APPL_OBJ              =
*     MAIL_RECIPIENT             =
*     MAIL_SENDER                =
*     OUTPUT_OPTIONS             =
*     USER_SETTINGS              = 'X'
      ip_user = v_hold
* IMPORTING
*     DOCUMENT_OUTPUT_INFO       =
*     JOB_OUTPUT_INFO            =
*     JOB_OUTPUT_OPTIONS         =
* EXCEPTIONS
*     FORMATTING_ERROR           = 1
*     INTERNAL_ERROR             = 2
*     SEND_ERROR                 = 3
*     USER_CANCELED              = 4
*     OTHERS  = 5
    .
ENDFORM.
