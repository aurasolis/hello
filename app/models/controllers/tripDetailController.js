import { errorReporter } from 'rsvms/globals';
import ratesRequest from '../requests/ratesRequest';
import searchRequest from '../requests/searchRequest';
import parseSearch from '../parsing/parseSearch';

function tripDetail (tripSearchParams) {
  const {
    key,
    origin,
    destination,
    departure,
    uuid,
  } = tripSearchParams;

  const timeout = 50000;
  const student = 1;
  const teacher = 1;

  return Promise.all([
    ratesRequest({ origin, destination, departure, timeout, uuid }),
    ratesRequest({ origin, destination, departure, student, teacher, timeout, uuid }),
    searchRequest({ origin, destination, departure, timeout, uuid })])
    .then(body => parseSearch(body, tripSearchParams).find(t => t.key === key))
    .catch(errorReporter.notify({ tripSearchParams, uuid }));
}

export default () => tripSearchParams =>
  tripDetail(tripSearchParams);
