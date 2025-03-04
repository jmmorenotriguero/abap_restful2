@EndUserText.label: 'Consumption - Booking'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity Z_C_BOOKING_JMT as projection on Z_I_BOOKING_JMT
{
    key travel_id as TravelID,
    key booking_id as BookingID,
    booking_date as BookingDate,
    customer_id as CustomerID,
    @ObjectModel.text.element: ['CarrierName']
    carrier_id as CarrierID,
    _Carrier.Name as CarrierName,
    connection_id as ConnectionID,
    flight_date as FlightDate,
    @Semantics.amount.currencyCode : 'CurrencyCode'
    flight_price as FlightPrice,
    @Semantics.currencyCode: true
    currency_code as CurrencyCode,
    booking_status as BookingStatus,
    last_changed_at as LastChangedAt,
    /* Associations */
    _Travel : redirected to parent Z_C_TRAVEL_JMT,
    _BookingSupplement : redirected to composition child Z_C_BOOKSUPPL_JMT,
    _Carrier,
    _Connection,
    _Customer
}
