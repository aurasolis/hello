import { errorReporter } from 'rsvms/globals';
import parseLockSearch from '../parsing/parseLockSearch';
import busRequest from '../requests/busRequest';
import tmpReservRequest from '../requests/tmpReservRequest';
import parseTmpReservSearch from '../parsing/parseTmpReservSearch';
import { parsePassengersParams } from '../generalParsing';

function lockSeats (lockSeatsParams) {
  const {
    key,
    origin,
    destination,
    uuid,
  } = lockSeatsParams;

  const passengersInfo = parsePassengersParams(lockSeatsParams);

  const pickupKey = key;
  const timeout = 50000;

  let rsvpCode;

  return tmpReservRequest({ origin, destination, pickupKey, passengersInfo, timeout, uuid })
    .then(body => parseTmpReservSearch(body))
    .then((tmpRsvpInfo) => {
      rsvpCode = tmpRsvpInfo.code;
      return busRequest({ rsvpCode, timeout, uuid });
    })
    .then(body => parseLockSearch(body, rsvpCode, lockSeatsParams))
    .catch(errorReporter.notify({ lockSeatsParams, uuid }));
}

export default () => lockSeatsParams =>
  lockSeats(lockSeatsParams);
