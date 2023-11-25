*&---------------------------------------------------------------------*
*& Include          ZBC_LIBRARY_SYSTEM_O
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR '0100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0101 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0101 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR '0100'.
  LOOP AT SCREEN. " buras# kullan#c# ekle butonunun görünürlülü#ü için yap#ld#. kullan#c#n#n admin olup olmad###na ba#l# olarak de#i#ecek.
    IF screen-name = 'ADD_USER' OR screen-name = 'ADD_BOOK'.
      IF gv_admin = '-'.
        screen-active = 0.
      ELSE.
        screen-active = 1.
      ENDIF.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.
ENDMODULE.
