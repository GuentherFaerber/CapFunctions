using {sap.common.CodeList} from '@sap/cds/common';

@cds.autoexpose
@cds.odata.valuelist
entity Environments {
    key ID: UUID;
    environment: String;
    version: String;
    description: String; 
}

entity Functions {
    environment: Association to one Environments;
    key ID            : UUID;
        type          : Association to one FunctionTypes;
        description   : String;
        inputFunction : Association to one Functions;
        inputFields   : Composition of many FunctionInputFields
                            on inputFields.function = $self;
}

entity FunctionInputFields {
    key ID       : UUID;
        function : Association to one Functions;
        field    : String;
}

type FunctionType @(assert.range) : String(10) enum {
    ModelTable  = 'MT';
    ModelView   = 'MV';
    Allocation  = 'AL';
    Calculation = 'CA';
    Query       = 'QE';
}

entity FunctionTypes : CodeList {
    key code : FunctionType default 'AL';
};
