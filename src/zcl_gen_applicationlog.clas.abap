CLASS zcl_gen_applicationlog DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE .

  PUBLIC SECTION.

    METHODS update_logs
      IMPORTING
        !iv_object      TYPE balobj_d
        !im_subobject   TYPE balsubobj
        !im_external_id TYPE zgen_balnrext
        !it_msg         TYPE zgen_bal_t_msg .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_gen_applicationlog IMPLEMENTATION.


  METHOD update_logs.
    TRY.
        DATA(l_log) = cl_bali_log=>create_with_header( cl_bali_header_setter=>create( object =
         iv_object subobject = im_subobject ) ).
        LOOP AT it_msg INTO DATA(l_s_msg) .

          DATA(l_message) = cl_bali_message_setter=>create( severity   = if_bali_constants=>c_severity_error
                                                            id         = l_s_msg-msgid
                                                            number     = l_s_msg-msgno
                                                            variable_1 = l_s_msg-msgv1
                                                            variable_3 = l_s_msg-msgv3
                                                            variable_4 = l_s_msg-msgv4
                                                            variable_2 = l_s_msg-msgv2 ).
          l_log->add_item( item = l_message ).
        ENDLOOP.
        cl_bali_log_db=>get_instance( )->save_log( log = l_log assign_to_current_appl_job = abap_true ).
*        COMMIT WORK.
      CATCH cx_bali_runtime INTO DATA(l_runtime_exception).##NO_HANDLER
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
