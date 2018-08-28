import { errorReporter } from 'rsvms/globals';
import parseUnlockSeats from '../parsing/parseUnlockSeats';
import busRequest from '../requests/busRequest';

function unlockSeats (unlockSeatsParams) {
  const {
    lockId,
    uuid,
  } = unlockSeatsParams;

  const timeout = 50000;

  const rsvpCode = lockId;

  return busRequest({ rsvpCode, timeout, uuid })
    .then(body => parseUnlockSeats(body, unlockSeatsParams))
    .catch(errorReporter.notify({ unlockSeatsParams, uuid }));
}

export default () => unlockSeatsParams =>
  unlockSeats(unlockSeatsParams);
