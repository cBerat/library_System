*&---------------------------------------------------------------------*
*& Include          ZBC_LIBRARY_SYSTEM_FORMS
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form GET_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  SELECT * FROM zbc_users INTO gs_users.
    APPEND gs_users TO gt_users.
    CLEAR: gs_users.
  ENDSELECT.

  SELECT * FROM zbc_books INTO gs_books.
    APPEND gs_books TO gt_books.
    CLEAR gs_books.
  ENDSELECT.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_alv .
  CREATE OBJECT go_cont_books
    EXPORTING
*     parent                      =                  " Parent container
      container_name              = 'CC_BOOKS'                  " Name of the Screen CustCtrl Name to Link Container To
*     style                       =                  " Windows Style Attributes Applied to this Container
*     lifetime                    = lifetime_default " Lifetime
*     repid                       =                  " Screen to Which this Container is Linked
*     dynnr                       =                  " Report To Which this Container is Linked
*     no_autodef_progid_dynnr     =                  " Don't Autodefined Progid and Dynnr?
    EXCEPTIONS
      cntl_error                  = 1                " CNTL_ERROR
      cntl_system_error           = 2                " CNTL_SYSTEM_ERROR
      create_error                = 3                " CREATE_ERROR
      lifetime_error              = 4                " LIFETIME_ERROR
      lifetime_dynpro_dynpro_link = 5                " LIFETIME_DYNPRO_DYNPRO_LINK
      OTHERS                      = 6.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CREATE OBJECT go_alv_books
    EXPORTING
*     i_shellstyle      = 0                " Control Style
*     i_lifetime        =                  " Lifetime
      i_parent          = go_cont_books                 " Parent Container
*     i_appl_events     = space            " Register Events as Application Events
*     i_parentdbg       =                  " Internal, Do not Use
*     i_applogparent    =                  " Container for Application Log
*     i_graphicsparent  =                  " Container for Graphics
*     i_name            =                  " Name
*     i_fcat_complete   = space            " Boolean Variable (X=True, Space=False)
    EXCEPTIONS
      error_cntl_create = 1                " Error when creating the control
      error_cntl_init   = 2                " Error While Initializing Control
      error_cntl_link   = 3                " Error While Linking Control
      error_dp_create   = 4                " Error While Creating DataProvider Control
      OTHERS            = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CALL METHOD go_alv_books->set_table_for_first_display
    EXPORTING
*     i_buffer_active               =                  " Buffering Active
*     i_bypassing_buffer            =                  " Switch Off Buffer
*     i_consistency_check           =                  " Starting Consistency Check for Interface Error Recognition
*     i_structure_name              =                  " Internal Output Table Structure Name
*     is_variant                    =                  " Layout
*     i_save                        =                  " Save Layout
*     i_default                     = 'X'              " Default Display Variant
      is_layout                     = gs_layout                 " Layout
*     is_print                      =                  " Print Control
*     it_special_groups             =                  " Field Groups
*     it_toolbar_excluding          =                  " Excluded Toolbar Standard Functions
*     it_hyperlink                  =                  " Hyperlinks
*     it_alv_graphics               =                  " Table of Structure DTC_S_TC
*     it_except_qinfo               =                  " Table for Exception Quickinfo
*     ir_salv_adapter               =                  " Interface ALV Adapter
    CHANGING
      it_outtab                     = gt_books[]                 " Output Table
      it_fieldcatalog               = gt_fc_merge                " Field Catalog
*     it_sort                       =                  " Sort Criteria
*     it_filter                     =                  " Filter Criteria
    EXCEPTIONS
      invalid_parameter_combination = 1                " Wrong Parameter
      program_error                 = 2                " Program Errors
      too_many_lines                = 3                " Too many Rows in Ready for Input Grid
      OTHERS                        = 4.
  IF sy-subrc <> 0.
*   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form SET_FC
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fc .
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
*     I_BUFFER_ACTIVE        =
      i_structure_name       = 'ZBC_BOOKS'
*     I_CLIENT_NEVER_DISPLAY = 'X'
*     I_BYPASSING_BUFFER     =
*     I_INTERNAL_TABNAME     =
    CHANGING
      ct_fieldcat            = gt_fc_merge
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
  LOOP AT gt_fc_merge INTO gs_fc_merge.
    CASE gs_fc_merge-fieldname.
      WHEN 'Field'.
        gs_fc_merge-fieldname = 'Book Name'.
      WHEN 'Integer'.
        gs_fc_merge-fieldname = 'Amount'.
    ENDCASE.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_LAYOUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_layout .
  CLEAR gs_layout.
  gs_layout-zebra = abap_true.
  gs_layout-cwidth_opt = abap_true.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM refresh_alv_books .

  LOOP AT gt_books.
    DELETE gt_books INDEX 1.
  ENDLOOP.

  CLEAR gs_books.
  SELECT * FROM zbc_books INTO gs_books.
    APPEND gs_books TO gt_books.
  ENDSELECT.

  go_alv_books->refresh_table_display(
  EXPORTING
    is_stable      = is_stable                 " With Stable Rows/Columns
*                  i_soft_refresh =                  " Without Sort, Filter, etc.
  EXCEPTIONS
    finished       = 1                " Display was Ended (by Export)
    OTHERS         = 2
  ).
  IF sy-subrc <> 0.
*                 MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                   WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
