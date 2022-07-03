using {Functions as functions} from '../db/schema';

@path : 'modeling'
service ModelingService {
    @odata.draft.enabled
    entity Functions as projection on functions;
}
