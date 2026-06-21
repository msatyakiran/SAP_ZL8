@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Address'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zgen_b_address
  as select from    adrc
  -- Need the person number if this is a person address to get the communication data
    left outer join adcp on  adcp.addrnumber = adrc.addrnumber
                         and adcp.date_from  = '00010101'
                         and adcp.nation     = ' '
                         and adcp.comp_pers  = 'P'


  association [0..1]

                     to I_AddressPhoneNumber  as _DefaultPhoneNumber           on  _DefaultPhoneNumber.AddressID       = $projection.AddressID
                                                                               and (
                                                                                  _DefaultPhoneNumber.Person           = $projection.Person
                                                                                  or _DefaultPhoneNumber.Person        = ' '
                                                                                )
                                                                               and _DefaultPhoneNumber.PhoneNumberType = '1'

  association [0..1] to I_AddressPhoneNumber  as _DefaultPrivatePhoneNumber    on  _DefaultPrivatePhoneNumber.AddressID       = $projection.AddressID
                                                                               and _DefaultPrivatePhoneNumber.Person          = $projection.Person
                                                                               and _DefaultPrivatePhoneNumber.PhoneNumberType = '1'

  association [0..1] to I_AddressPhoneNumber  as _DefaultCorporatePhoneNumber  on  _DefaultCorporatePhoneNumber.AddressID       = $projection.AddressID
                                                                               and _DefaultCorporatePhoneNumber.Person          = ' '
                                                                               and _DefaultCorporatePhoneNumber.PhoneNumberType = '1'

  association [0..1] to I_AddressPhoneNumber  as _DefaultMobilePhoneNumber     on  _DefaultMobilePhoneNumber.AddressID       = $projection.AddressID
                                                                               and (
                                                                                  _DefaultMobilePhoneNumber.Person           = $projection.Person
                                                                                  or _DefaultMobilePhoneNumber.Person        = ' '
                                                                                )
                                                                               and _DefaultMobilePhoneNumber.PhoneNumberType = '3'

  association [0..1] to I_AddressPhoneNumber  as _DefaultPvtMobilePhoneNumber  on  _DefaultPvtMobilePhoneNumber.AddressID       = $projection.AddressID
                                                                               and _DefaultPvtMobilePhoneNumber.Person          = $projection.Person
                                                                               and _DefaultPvtMobilePhoneNumber.PhoneNumberType = '3'

  association [0..1] to I_AddressPhoneNumber  as _DefaultCorpMobilePhoneNumber on  _DefaultCorpMobilePhoneNumber.AddressID       = $projection.AddressID
                                                                               and _DefaultCorpMobilePhoneNumber.Person          = ' '
                                                                               and _DefaultCorpMobilePhoneNumber.PhoneNumberType = '3'


  association [0..1] to I_AddressFaxNumber    as _DefaultFaxNumber             on  _DefaultFaxNumber.AddressID          = $projection.AddressID
                                                                               and (
                                                                                  _DefaultFaxNumber.Person              = $projection.Person
                                                                                  or _DefaultFaxNumber.Person           = ' '
                                                                                )
                                                                               and _DefaultFaxNumber.IsDefaultFaxNumber = 'X'

  association [0..1] to I_AddressFaxNumber    as _DefaultPrivateFaxNumber      on  _DefaultPrivateFaxNumber.AddressID          = $projection.AddressID
                                                                               and _DefaultPrivateFaxNumber.Person             = $projection.Person
                                                                               and _DefaultPrivateFaxNumber.IsDefaultFaxNumber = 'X'

  association [0..1] to I_AddressFaxNumber    as _DefaultCorpFaxNumber         on  _DefaultCorpFaxNumber.AddressID          = $projection.AddressID
                                                                               and _DefaultCorpFaxNumber.Person             = ' '
                                                                               and _DefaultCorpFaxNumber.IsDefaultFaxNumber = 'X'


  association [0..1] to I_AddressEmailAddress as _DefaultEmailAddress          on  _DefaultEmailAddress.AddressID             = $projection.AddressID
                                                                               and (
                                                                                  _DefaultEmailAddress.Person                 = $projection.Person
                                                                                  or _DefaultEmailAddress.Person              = ' '
                                                                                )
                                                                               and _DefaultEmailAddress.IsDefaultEmailAddress = 'X'

  association [0..1] to I_AddressEmailAddress as _DefaultPvtEmailAddress       on  _DefaultPvtEmailAddress.AddressID             = $projection.AddressID
                                                                               and _DefaultPvtEmailAddress.Person                = $projection.Person
                                                                               and _DefaultPvtEmailAddress.IsDefaultEmailAddress = 'X'

  association [0..1] to I_AddressEmailAddress as _DefaultCorpEmailAddress      on  _DefaultCorpEmailAddress.AddressID             = $projection.AddressID
                                                                               and _DefaultCorpEmailAddress.Person                = ' '
                                                                               and _DefaultCorpEmailAddress.IsDefaultEmailAddress = 'X'

  association [0..1] to I_AddressHomepageURL  as _DefaultURLAddress            on  _DefaultURLAddress.AddressID           = $projection.AddressID
                                                                               and (
                                                                                  _DefaultURLAddress.Person               = $projection.Person
                                                                                  or _DefaultURLAddress.Person            = ' '
                                                                                )
                                                                               and _DefaultURLAddress.IsDefaultURLAddress = 'X'

  association [0..1] to I_AddressHomepageURL  as _DefaultPvtURLAddress         on  _DefaultPvtURLAddress.AddressID           = $projection.AddressID
                                                                               and _DefaultPvtURLAddress.Person              = $projection.Person
                                                                               and _DefaultPvtURLAddress.IsDefaultURLAddress = 'X'

  association [0..1] to I_AddressHomepageURL  as _DefaultCorpURLAddress        on  _DefaultCorpURLAddress.AddressID           = $projection.AddressID
                                                                               and _DefaultCorpURLAddress.Person              = ' '
                                                                               and _DefaultCorpURLAddress.IsDefaultURLAddress = 'X'

  association [0..1] to I_Region              as _Region                       on  $projection.Region  = _Region.Region
                                                                               and $projection.Country = _Region.Country
  association [0..1] to I_Country             as _Country                      on  $projection.Country = _Country.Country

  association [0..1] to I_CityCode            as _CityCode                     on  $projection.Country  = _CityCode.Country
                                                                               and $projection.Region   = _CityCode.Region
                                                                               and $projection.CityCode = _CityCode.CityCode

  association [0..1] to I_CountyCode          as _CountyCode                   on  $projection.Country    = _CountyCode.Country
                                                                               and $projection.Region     = _CountyCode.Region
                                                                               and $projection.CountyCode = _CountyCode.County

  association [0..1] to I_FormOfAddress       as _FormOfAddress                on  $projection.FormOfAddress = _FormOfAddress.FormOfAddress

  association [0..1] to I_CountryText         as _CountryText                  on  $projection.Country   = _CountryText.Country
                                                                               and _CountryText.Language = $session.system_language

  // association [0..1] to C_BPLanguageVH as _LanguageValueHelp         on  $projection.CorrespondenceLanguage = _LanguageValueHelp.Language

  //  association [0..*] to I_LanguageText as _LanguageText on $projection.CorrespondenceLanguage = _LanguageText.LanguageCode




{
  key adrc.addrnumber                                                                                       as AddressID,
      adrc.adrc_uuid                                                                                        as AddressUUID,

      adrc.name_co                                                                                          as CareOfName,
      adrc.location                                                                                         as AdditionalStreetSuffixName,
      //      @ObjectModel: {
      //             foreignKey.association: '_LanguageValueHelp'
      //,mandatory: true
      //           }
      //      @ObjectModel.text.association: '_LanguageText'
      adrc.langu                                                                                            as CorrespondenceLanguage,

      adrc.deflt_comm                                                                                       as PrfrdCommMediumType,

      adrc.po_box                                                                                           as POBox,
      adrc.po_box_num                                                                                       as POBoxIsWithoutNumber,
      adrc.post_code2                                                                                       as POBoxPostalCode,
      adrc.po_box_lobby                                                                                     as POBoxLobbyName,
      adrc.po_box_loc                                                                                       as POBoxDeviatingCityName,
      adrc.po_box_reg                                                                                       as POBoxDeviatingRegion,
      adrc.po_box_cty                                                                                       as POBoxDeviatingCountry,

      adrc.deli_serv_type                                                                                   as DeliveryServiceTypeCode,
      adrc.deli_serv_number                                                                                 as DeliveryServiceNumber,
      adrc.time_zone                                                                                        as AddressTimeZone,
      adrc.chckstatus                                                                                       as CityFileTestStatus,
      adrc.dont_use_s                                                                                       as AddressStreetUnusable,
      adrc.dont_use_p                                                                                       as AddressPostBoxUnusable,



      /*
            , case when type = '1' then but000.name1_text
                   when type = '2'
                     //workaround to add the space: name_org1+' '+name_org2
                     then substring(replace(concat(name_org1, concat(' &@', name_org2)), '&@', ''),1,80)
               else '' //add this to avoid the warning
                 end as BusinessPartnerName
      */

      cast(substring(replace(concat(adrc.name1, concat(' &@', adrc.name2)), '&@', ''),1,80) as adfullname ) as FullName,

      // name1 as Name,

      // name2 as AdditionalName,

      adrc.city1                                                                                            as CityName,

      adrc.city2                                                                                            as District,
      adrc.city_code                                                                                        as CityCode,


      adrc.home_city                                                                                        as HomeCityName,
      adrc.post_code1                                                                                       as PostalCode,
      adrc.post_code3                                                                                       as CompanyPostalCode,

      adrc.street                                                                                           as StreetName,
      adrc.str_suppl1                                                                                       as StreetPrefixName,
      adrc.str_suppl2                                                                                       as AdditionalStreetPrefixName,
      adrc.str_suppl3                                                                                       as StreetSuffixName,

      adrc.house_num1                                                                                       as HouseNumber,

      adrc.house_num2                                                                                       as HouseNumberSupplementText,

      adrc.building                                                                                         as Building,

      adrc.floor                                                                                            as Floor,

      adrc.roomnumber                                                                                       as RoomNumber,

      adrc.country                                                                                          as Country,

      adrc.region                                                                                           as Region,

      adrc.county                                                                                           as County,

      adrc.county_code                                                                                      as CountyCode,

      adrc.township_code                                                                                    as TownshipCode,
      adrc.township                                                                                         as TownshipName,

      //  title as Title, // replace with FormOf Address
      adrc.title                                                                                            as FormOfAddress,


      //fields required for globalisation
      adrc.name1                                                                                            as BusinessPartnerName1,
      adrc.name2                                                                                            as BusinessPartnerName2,
      adrc.nation                                                                                           as Nation,
      adrc.tel_number                                                                                       as PhoneNumber,
      adrc.fax_number                                                                                       as FaxNumber,
      adrc.sort1                                                                                            as SearchTerm1,
      adrc.sort2                                                                                            as SearchTerm2,
      adrc.mc_street                                                                                        as StreetSearch,
      adrc.mc_city1                                                                                         as CitySearch,

      //Following fields are needed in BP Customer-Supplier Apps

      adrc.name3                                                                                            as BusinessPartnerName3,
      adrc.name4                                                                                            as BusinessPartnerName4,

      adrc.taxjurcode                                                                                       as TaxJurisdiction,
      adrc.transpzone                                                                                       as TransportZone,
      adrc.city_code2                                                                                       as AddressCityPostBoxCode,

      // Disabled NULL handling due to Performance. Do Null Handling in consuming layer, please
      //  We tested that it is cheaper to add the OR conditions into the child-associations
      //      case
      //          when adcp.persnumber is null then '          '
      //      -- possible alternative to the above when adrc.pers_addr = ' ' then '          '
      //          else adcp.persnumber
      //        end                                                                                       as Person,
      adcp.persnumber                                                                                       as Person, //NULL possible here.
      concat_with_space(
      concat(
      concat_with_space(
      concat_with_space(
        concat_with_space(adrc.house_num1,adrc.street,1)
        ,',',1)
      ,adrc.city1,1)
      ,',')
      ,concat_with_space(_CountryText.CountryName,adrc.post_code1,1)
      ,1)                                                                                                   as CompleteAddress,
      _DefaultPhoneNumber,
      _DefaultPrivatePhoneNumber,
      _DefaultCorporatePhoneNumber,
      _DefaultMobilePhoneNumber,
      _DefaultPvtMobilePhoneNumber,
      _DefaultCorpMobilePhoneNumber,
      _DefaultFaxNumber,
      _DefaultPrivateFaxNumber,
      _DefaultCorpFaxNumber,
      _DefaultEmailAddress,
      _DefaultPvtEmailAddress,
      _DefaultCorpEmailAddress,
      _DefaultURLAddress,
      _DefaultPvtURLAddress,
      _DefaultCorpURLAddress,

      _Region,
      _Country,
      _CountyCode, // to be aligned: better without "Code"?
      _CityCode, // to be aligned: better without "Code"?
      _FormOfAddress

      //_LanguageValueHelp,
      //_LanguageText

}
where
      adrc.date_from = '00010101'
  and adrc.nation    = ' '
