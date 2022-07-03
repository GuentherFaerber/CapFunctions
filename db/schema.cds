using {sap.common.CodeList} from '@sap/cds/common';

@cds.autoexpose
@cds.odata.valuelist
entity Environments {
    key ID          : UUID @odata.Type : 'Edm.String'  @UI.Hidden;
        environment : String;
        version     : String;
        description : String;
}

@cds.autoexpose
@cds.odata.valuelist
entity Functions {
        environment   : Association to one Environments;
    key ID            : UUID @odata.Type : 'Edm.String'  @UI.Hidden;
        type          : Association to one FunctionTypes;
        description   : String;
        // @NX.valuehelp :                    `(inputFunction.ID <> $self.ID)`
        inputFunction : Association to one FunctionsVH;
        inputFields   : Composition of many FunctionInputFields
                            on inputFields.function = $self;

        resultFields  : Composition of many FunctionResultFields
                            on resultFields.function = $self;
}

@cds.autoexpose
@cds.odata.valuelist
entity Fields {
        environment : Association to one Environments;
    key ID          : UUID @odata.Type : 'Edm.String'  @UI.Hidden;
        description : String;
}

@cds.autoexpose
@cds.odata.valuelist
 // Don't use projection, as YO generators get confused
entity FunctionsVH as
    select from Functions {
        environment,
        ID,
        type,
        description,
        '' || ID as parameter1 // Cheat, otherwise CDS would treat it as additional primary key
    }
    where
        (
            type.code in (
                'MT', 'AL', 'CA')
            );


@cds.autoexpose
@cds.odata.valuelist
entity FunctionInputFields {
        environment   : Association to one Environments;
        function      : Association to one Functions;
    key ID            : UUID @odata.Type : 'Edm.String'  @UI.Hidden;
        inputFunction : Association to one Functions;
        field         : Association to one Fields;
}

@cds.autoexpose
@cds.odata.valuelist
entity FunctionResultFields {
        environment : Association to one Environments;
        function    : Association to one Functions;
    key ID          : UUID @odata.Type : 'Edm.String'  @UI.Hidden;
        field       : Association to one Fields;
}

// @cds.autoexpose
// @cds.odata.valuelist
// entity FunctionInputFieldsVH as projection on FunctionResultFields {
//     *,
//     function.ID as parameter1
// };

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
