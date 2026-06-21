CLASS zcl_gen_get_address DEFINITION
  PUBLIC

  FINAL
  CREATE PRIVATE .

  PUBLIC SECTION.
    TYPES : BEGIN OF ty_address,
              businesspartnername1      TYPE zgen_b_address-businesspartnername1,
              businesspartnername2      TYPE zgen_b_address-businesspartnername2,
              housenumber               TYPE zgen_b_address-housenumber,
              housenumbersupplementtext TYPE zgen_b_address-housenumbersupplementtext,
              streetname                TYPE zgen_b_address-streetname,
              homecityname              TYPE zgen_b_address-homecityname,
              districtname              TYPE zgen_b_address-district,
              postalcode                TYPE zgen_b_address-pobox,
              cityname                  TYPE zgen_b_address-cityname,
              country                   TYPE zgen_b_address-country,
              region                    TYPE zgen_b_address-region,
              completeaddress           TYPE zgen_b_address-completeaddress.
    TYPES :       END OF ty_address.
    TYPES : tt_address TYPE STANDARD TABLE OF ty_address.

    TYPES:BEGIN OF ty_formataddress,
            title            TYPE string,
            name1            TYPE string,
            name2            TYPE string,
            name3            TYPE string,
            name4            TYPE char35,
            streetandhouseno TYPE char35,
            pobox            TYPE char10,
            postalcode       TYPE char10,
            city             TYPE char35,
            country          TYPE char3,
            region           TYPE char3,
            line0            TYPE char80,
            line1            TYPE char80,
            line2            TYPE char80,
            line3            TYPE char80,
            line4            TYPE char80,
            line5            TYPE char80,
            line6            TYPE char80,
            line7            TYPE char80,
            line8            TYPE char80,
            line9            TYPE char80.
    TYPES :          END OF ty_formataddress.
    TYPES : tt_formataddress TYPE STANDARD TABLE OF ty_formataddress.

    METHODS get_address
      IMPORTING
        !iv_mail_address         TYPE char1_run_type OPTIONAL
        !iv_service_address      TYPE char1_run_type OPTIONAL
        !iv_business_partner     TYPE i_businesspartner-businesspartner OPTIONAL
        !iv_contract_account     TYPE i_contractaccountpartner-contractaccount OPTIONAL
        !iv_premise              TYPE i_utilitiespremise-utilitiespremise OPTIONAL
        !iv_installation         TYPE i_utilitiesinstallation-utilitiesinstallation OPTIONAL
      EXPORTING
        !es_service_address_data TYPE ty_address
        !es_service_address      TYPE ty_formataddress
        !es_mailing_address_data TYPE ty_address
        !es_mailing_address      TYPE ty_formataddress.

  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS get_bussiness_partner
      IMPORTING
        !iv_business_partner TYPE i_businesspartner-businesspartner OPTIONAL
      EXPORTING
        !es_address          TYPE ty_address .

    METHODS get_contract_account
      IMPORTING
        !iv_contract_account TYPE i_contractaccountpartner-contractaccount OPTIONAL
      EXPORTING
        !es_address          TYPE ty_address .

    METHODS get_premise
      IMPORTING
        !iv_premise TYPE i_utilitiespremise-utilitiespremise OPTIONAL
      EXPORTING
        !es_address TYPE ty_address .
    METHODS get_formataddress
      IMPORTING
        !is_address_data TYPE ty_address
      EXPORTING
        !es_address      TYPE ty_formataddress.
ENDCLASS.

CLASS zcl_gen_get_address IMPLEMENTATION.
  METHOD get_bussiness_partner.
    SELECT SINGLE zgen_b_address~businesspartnername1 AS name1,
           zgen_b_address~businesspartnername2 AS name2,
           zgen_b_address~housenumber,
           zgen_b_address~housenumbersupplementtext,
           zgen_b_address~streetname,
           zgen_b_address~homecityname,
           zgen_b_address~district  AS districtname,
           zgen_b_address~pobox AS postalcode,
           zgen_b_address~cityname,
           zgen_b_address~country,
           zgen_b_address~region,
           zgen_b_address~completeaddress FROM i_businesspartneraddresstp_3
           INNER JOIN zgen_b_address ON zgen_b_address~addressid = i_businesspartneraddresstp_3~addressnumber
           WHERE businesspartner EQ @iv_business_partner
           INTO @es_address.
  ENDMETHOD.


  METHOD get_contract_account.
    SELECT SINGLE zgen_b_address~businesspartnername1 AS name1,
           zgen_b_address~businesspartnername2 AS name2,
           zgen_b_address~housenumber,
           zgen_b_address~housenumbersupplementtext,
           zgen_b_address~streetname,
           zgen_b_address~homecityname,
           zgen_b_address~district  AS districtname,
           zgen_b_address~pobox AS postalcode,
           zgen_b_address~cityname,
           zgen_b_address~country,
           zgen_b_address~region,
           zgen_b_address~completeaddress FROM i_contractaccountpartner
           INNER JOIN zgen_b_address ON zgen_b_address~addressid = i_contractaccountpartner~addressid
           WHERE contractaccount EQ @iv_contract_account
           INTO @es_address.
  ENDMETHOD.


  METHOD get_premise.
    SELECT SINGLE zgen_b_address~businesspartnername1 AS name1,
           zgen_b_address~businesspartnername2 AS name2,
           zgen_b_address~housenumber,
           zgen_b_address~housenumbersupplementtext,
           zgen_b_address~streetname,
           zgen_b_address~homecityname,
           zgen_b_address~district  AS districtname,
           zgen_b_address~pobox AS postalcode,
           zgen_b_address~cityname,
           zgen_b_address~country,
           zgen_b_address~region,
           zgen_b_address~completeaddress FROM i_utilstechobjlocationaddr
                           INNER JOIN zgen_b_address ON zgen_b_address~addressid = i_utilstechobjlocationaddr~addressid
                           WHERE functionallocation = @iv_premise
                             INTO @es_address.
  ENDMETHOD.

  METHOD get_address.
    IF iv_contract_account IS NOT INITIAL.
      SELECT SINGLE contractaccount,
                    businesspartner FROM i_contractaccountpartner
                    WHERE contractaccount EQ @iv_contract_account
                    INTO @DATA(ls_contract_account).
      IF ls_contract_account IS NOT INITIAL.

      ENDIF.
    ELSEIF iv_premise IS INITIAL.
      SELECT SINGLE utilitiespremise,
                    utilitiesinstallation FROM i_utilitiesinstallation
                    WHERE utilitiespremise = @iv_premise
                    INTO @DATA(ls_premise).
      IF  ls_premise-utilitiesinstallation IS NOT INITIAL.
      ENDIF.
    ELSEIF iv_installation IS NOT INITIAL.
    ENDIF.
    IF  iv_mail_address IS NOT INITIAL.
      IF iv_contract_account IS NOT INITIAL.
        get_contract_account( EXPORTING iv_contract_account = iv_contract_account IMPORTING es_address = es_mailing_address_data ).
      ELSEIF iv_business_partner IS NOT INITIAL.
        get_bussiness_partner( EXPORTING iv_business_partner = iv_business_partner IMPORTING es_address = es_mailing_address_data ).
      ENDIF.
      get_formataddress( EXPORTING is_address_data = es_mailing_address_data IMPORTING es_address = es_mailing_address ).

    ENDIF.
    IF iv_service_address IS NOT INITIAL.
      IF iv_premise IS NOT INITIAL.
        get_premise( EXPORTING iv_premise = iv_premise IMPORTING es_address = es_service_address_data ).
        get_formataddress( EXPORTING is_address_data = es_mailing_address_data IMPORTING es_address = es_service_address ).
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD get_formataddress.
    es_address-name1 = is_address_data-businesspartnername1.
    es_address-name2 = is_address_data-businesspartnername2.

    es_address-line0 = |{ is_address_data-housenumber }{ is_address_data-housenumbersupplementtext }{ is_address_data-housenumbersupplementtext }|.
    es_address-line1 = |{ is_address_data-districtname }{ is_address_data-homecityname }{ is_address_data-region }{ is_address_data-country }|.
  ENDMETHOD.

ENDCLASS.
