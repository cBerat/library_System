*&---------------------------------------------------------------------*
*& Report ZBC_LIBRARY_SYSTEM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc_library_system.

INCLUDE zbc_library_system_top.
INCLUDE zbc_library_system_forms.
INCLUDE zbc_library_system_i.
INCLUDE zbc_library_system_o.


START-OF-SELECTION.
  PERFORM get_data.
  PERFORM set_layout.
  PERFORM set_fc.
  PERFORM display_alv.
  CALL SCREEN 0100.
