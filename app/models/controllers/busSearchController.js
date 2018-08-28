import { errorReporter } from 'rsvms/globals';
import tmpReservRequest from '../requests/tmpReservRequest';
import parseTmpReservSearch from '../parsing/parseTmpReservSearch';
import busRequest from '../requests/busRequest';
import parseBusSearch from '../parsing/parseBusSearch';


function busSearch (busSearchParams) {
  const {
    key: pickupKey,
    origin,
    destination,
    uuid,
  } = busSearchParams;

  const timeout = 50000;

  return tmpReservRequest({ origin, destination, pickupKey, timeout, uuid })
    .then(body => parseTmpReservSearch(body))
    .then((tmpRsvpInfo) => {
      const rsvpCode = tmpRsvpInfo.code;
      return busRequest({ rsvpCode, timeout, uuid });
    })
    .then(body => parseBusSearch(body))
    .catch(errorReporter.notify({ busSearchParams, uuid }));
}

export default () => busSearchParams =>
  busSearch(busSearchParams);
