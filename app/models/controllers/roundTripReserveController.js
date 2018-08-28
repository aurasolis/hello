import { errorReporter } from 'rsvms/globals';
import tmpReservRequest from '../requests/tmpReservRequest';
import parseTmpReservSearch from '../parsing/parseTmpReservSearch';
import roundTripReserveRequest from '../requests/roundTripReserveRequest';
import parseRoundTripReserveSearch from '../parsing/parseRoundTripReserveSearch';
import { contactParser, parsePassengers } from '../generalParsing';


function roundTripReserveSearch (rtReserveSearchParams) {
  const {
    oneWayTrips,
    uuid,
  } = rtReserveSearchParams;

  const pickupTrip = oneWayTrips[0];
  const dropoffTrip = oneWayTrips[1];

  const { origin, destination } = pickupTrip;
  const round = true;

  const pickupKey = pickupTrip.key;
  const dropoffKey = dropoffTrip.key;

  const contact = contactParser(rtReserveSearchParams.contacts);

  const passengersInfo = parsePassengers(pickupTrip.tickets);

  const timeout = 180000;

  let rsvpCode;
  let rsvpInfo;

  return tmpReservRequest({ origin,
    destination,
    round,
    pickupKey,
    dropoffKey,
    contact,
    passengersInfo,
    timeout,
    uuid })
    .then(body => parseTmpReservSearch(body))
    .then((tmpRsvpInfo) => {
      rsvpCode = tmpRsvpInfo.code;
      rsvpInfo = tmpRsvpInfo;
      return roundTripReserveRequest({ rsvpCode, rtReserveSearchParams, timeout, uuid });
    })
    .then(body => parseRoundTripReserveSearch(body, rtReserveSearchParams, rsvpInfo))
    .catch(errorReporter.notify({ rtReserveSearchParams, uuid }));
}

export default () => rtReserveSearchParams =>
  roundTripReserveSearch(rtReserveSearchParams);
