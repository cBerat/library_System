*&---------------------------------------------------------------------*
*& Include          ZBC_LIBRARY_SYSTEM_TOP
*&---------------------------------------------------------------------*
TABLES zbc_books.
TABLES zbc_users.
DATA: gv_username        TYPE char20,
      gv_username_hire   TYPE char20,
      gv_password        TYPE char20,
      gv_username_sign   TYPE char20,
      gv_password_sign   TYPE char20,
      gv_logincheck      TYPE boolean,
      gv_bookname        TYPE string,
      gv_admin           TYPE c,
      gv_admin_sign      TYPE c,
      gv_bool            TYPE boolean,
      gv_bookcount       TYPE i,
      gv_book_hire       TYPE char20,
      gv_book_exist      TYPE boolean,
      gv_count_exist     TYPE boolean,
      gv_hire_count      TYPE i,
      gv_user_hire_exist TYPE boolean,
      gv_temp_msg        TYPE string,
      gv_message         TYPE char50.

DATA: gt_users TYPE TABLE OF zbc_users WITH HEADER LINE,
      gs_users TYPE zbc_users,
      gt_books TYPE TABLE OF zbc_books WITH HEADER LINE,
      gs_books TYPE zbc_books.

CONTROLS main_menu TYPE TABSTRIP.

DATA: is_stable TYPE lvc_s_stbl.

DATA: go_alv_books  TYPE REF TO cl_gui_alv_grid,
      go_cont_books TYPE REF TO cl_gui_custom_container,
      gt_fc_merge   TYPE lvc_t_fcat,
      gs_fc_merge   TYPE lvc_s_fcat,
      gs_layout     TYPE lvc_s_layo.
