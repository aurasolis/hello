import { errorReporter } from 'rsvms/globals';
import tmpReservRequest from '../requests/tmpReservRequest';
import parseTmpReservSearch from '../parsing/parseTmpReservSearch';
import reserveSeatsRequest from '../requests/reserveSeatsRequest';
import parseReserveSeatsSearch from '../parsing/parseReserveSeatsSearch';
import { contactParser, parsePassengers } from '../generalParsing';

function reserveSeatsSearch (reserveSearchParams) {
  const {
    contacts,
    oneWayTrip,
    uuid,
  } = reserveSearchParams;

  const ticketInfo = oneWayTrip;
  const contact = contactParser(contacts);

  const { origin, destination, key, tickets } = oneWayTrip;
  const passengersInfo = parsePassengers(tickets);

  const timeout = 180000;

  return tmpReservRequest({ origin,
    destination,
    pickupKey: key,
    contact,
    passengersInfo,
    timeout,
    uuid })
    .then(body => parseTmpReservSearch(body))
    .then((tmpRsvpInfo) => {
      const rsvpCode = tmpRsvpInfo.code;
      return reserveSeatsRequest({ ticketInfo, rsvpCode, timeout, uuid });
    })
    .then(body => parseReserveSeatsSearch(body, reserveSearchParams))
    .catch(errorReporter.notify({ reserveSearchParams, uuid }));
}


export default () => reserveSearchParams =>
  reserveSeatsSearch(reserveSearchParams);
