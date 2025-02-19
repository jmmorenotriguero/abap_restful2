@EndUserText.label: 'Consumption - Booking Supplement'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity Z_C_BOOKSUPPL_JMT
  as projection on Z_I_BOOKSUPPL_JMT
{
  key travel_id                   as TravelID,
  key booking_id                  as BookingID,
  key booking_supplement_id       as BookingSupplementID,
      supplement_id               as SupplementID,
      _SupplementText.Description as SupplementDescription : localized,
      @Semantics.amount.currencyCode : 'CurrencyCode'
      price                       as Price,
      @Semantics.currencyCode: true
      currency_code               as CurrencyCode,
      last_changed_at             as LastChangedAt,
      /* Associations */
      _Travel  : redirected to Z_C_TRAVEL_JMT,
      _Booking : redirected to parent Z_C_BOOKING_JMT,
      _Product,
      _SupplementText
}
