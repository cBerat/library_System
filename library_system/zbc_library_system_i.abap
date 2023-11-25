*&---------------------------------------------------------------------*
*& Include          ZBC_LIBRARY_SYSTEM_I
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN '&BACK'.
      LEAVE TO SCREEN 0.
    WHEN '&LOGIN'.
      TRANSLATE gv_username TO UPPER CASE.
      gv_logincheck = abap_false.

      LOOP AT gt_users.
        TRANSLATE gt_users-username TO UPPER CASE.
        IF gt_users-username = gv_username AND gt_users-password = gv_password.
          gv_logincheck = abap_true.
          gv_admin = gt_users-admin.
          CONCATENATE 'Welcome ' gv_username '  Admin: ' gv_admin INTO gv_message SEPARATED BY space.
        ENDIF.
      ENDLOOP.
      IF gv_logincheck = abap_true.
        MESSAGE 'Login Successful' TYPE 'I'.
        CALL SCREEN 0101.
      ELSE.
        MESSAGE 'User does not exist' TYPE 'I'.
      ENDIF.
    WHEN '&SIGN'.
      CALL SCREEN 0105 STARTING AT 10 10
                       ENDING AT 70 20.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0101  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0101 INPUT.
  CASE sy-ucomm.
    WHEN '&BACK'.
      LEAVE TO SCREEN 0.
    WHEN '&TAB1'.
      PERFORM refresh_alv_books.
      main_menu-activetab = '&TAB1'.
    WHEN '&TAB2'.
      main_menu-activetab = '&TAB2'.
    WHEN '&TAB3'.
      gv_username = ''.
      gv_password = ''.
      gv_username_sign = ''.
      gv_password_sign = ''.
      main_menu-activetab = '&TAB3'.
    WHEN '&TAB4'.
      main_menu-activetab = '&TAB4'.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0103  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0103 INPUT. " Book addition
  CASE sy-ucomm.
    WHEN '&SAVE'.
      IF gv_bookcount IS NOT INITIAL AND gv_bookname IS NOT INITIAL.
        gv_book_exist = abap_false.

        LOOP AT gt_books.
          DELETE gt_books INDEX 1.
        ENDLOOP.
        SELECT * FROM zbc_books INTO gs_books.
          APPEND gs_books TO gt_books.
        ENDSELECT.

        LOOP AT gt_books.
          IF gt_books-bookname = gv_bookname.
            gv_book_exist = abap_true.
          ENDIF.
        ENDLOOP.
        IF gv_book_exist = abap_false.

          CLEAR gs_books.

          gs_books-bookcount = gv_bookcount.
          gs_books-bookname = gv_bookname.
          APPEND gs_books TO gt_books.

          INSERT zbc_books FROM gs_books.

          CLEAR gs_books.
          gv_bookcount = ''.
          gv_bookname = ''.

          PERFORM refresh_alv_books.

          MESSAGE 'Saved Successfully.' TYPE 'I'.
        ELSE.
          UPDATE zbc_books SET bookcount = bookcount + gv_bookcount WHERE bookname = gv_bookname.
          gv_bookcount = ''.
          gv_bookname = ''.
          PERFORM refresh_alv_books.
          MESSAGE 'Saved Successfully.' TYPE 'I'.
        ENDIF.
      ELSE.
        MESSAGE 'Please fill the neccessary places' TYPE 'W'.
      ENDIF.
  ENDCASE.


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0104  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0104 INPUT.
  CASE sy-ucomm.
    WHEN '&KAYDET'.
      IF gv_username_sign IS NOT INITIAL AND gv_password_sign IS NOT INITIAL AND gv_admin_sign IS NOT INITIAL.
        CLEAR gs_users.
        gs_users-username = gv_username_sign.
        gs_users-password = gv_password_sign.
        gs_users-admin    = gv_admin_sign.
        INSERT zbc_users FROM gs_users.
        CLEAR gs_users.
        gv_username_sign = ''.
        gv_password_sign = ''.
        gv_admin_sign    = ''.
        MESSAGE 'Ekleme basarili' TYPE 'I'.
      ELSE.
        MESSAGE 'Hatali giris' TYPE 'I'.
      ENDIF.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0105  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0105 INPUT.
  CASE sy-ucomm.
    WHEN '&CIKIS'.
      LEAVE TO SCREEN 0.
    WHEN '&KAYDOL'.
      gv_bool = abap_false.
      IF gv_username_sign IS NOT INITIAL AND gv_password_sign IS NOT INITIAL.
        LOOP AT gt_users INTO gs_users.
          IF gs_users-username = gv_username_sign.
            gv_bool = abap_true.
            EXIT.
          ENDIF.
        ENDLOOP.
        IF gv_bool = abap_false.
          CLEAR gs_users.
          gs_users-username = gv_username_sign.
          gs_users-password = gv_password_sign.
          gs_users-admin    = '-'.
          INSERT zbc_users FROM gs_users.
          CLEAR gs_users.
          MESSAGE 'Signed Successfully' TYPE 'I'.
          gv_username_sign = ''.
          gv_password_sign = ''.
        ELSE.
          MESSAGE 'User already exist.' TYPE 'I'.
        ENDIF.
      ELSE.
        MESSAGE 'Please fill the neccessary places' TYPE 'I'.
      ENDIF.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0106  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0106 INPUT.
  CASE sy-ucomm.
    WHEN '&HIRE'.
      IF gv_book_hire IS NOT INITIAL AND gv_hire_count IS NOT INITIAL AND gv_username_hire IS NOT INITIAL.
        gv_book_exist = abap_false.
        gv_count_exist = abap_false.
        gv_user_hire_exist = abap_false.
        LOOP AT gt_books INTO gs_books.
          IF gv_book_hire = gs_books-bookname.
            gv_book_exist = abap_true.
          ENDIF.
        ENDLOOP.
        LOOP AT gt_users INTO gs_users.
          IF gv_username_hire = gs_users-username.
            gv_user_hire_exist = abap_true.
          ENDIF.
        ENDLOOP.
        IF gv_user_hire_exist = abap_false.
          MESSAGE 'This user does not exist' TYPE 'W'.
        ENDIF.
        IF gv_book_exist = abap_true.
          LOOP AT gt_books INTO gs_books.
            IF gv_book_hire = gs_books-bookname.
              IF gv_hire_count <= gs_books-bookcount.
                gs_books-bookcount = gs_books-bookcount - gv_hire_count.
                UPDATE zbc_books SET bookcount = gs_books-bookcount WHERE bookname = gv_book_hire.
                PERFORM refresh_alv_books.
                CONCATENATE 'Hired successfully by ' gv_username_hire INTO gv_temp_msg SEPARATED BY space.
                MESSAGE gv_temp_msg TYPE 'I'.
                EXIT.
              ELSE.
                MESSAGE 'Not enough books' TYPE 'W'.
              ENDIF.
            ENDIF.
          ENDLOOP.
        ELSE.
          MESSAGE 'This book does not exist' TYPE 'W'.
        ENDIF.

      ENDIF.
  ENDCASE.

ENDMODULE.
