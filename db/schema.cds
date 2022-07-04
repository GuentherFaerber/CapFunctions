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
    key ID            : UUID @odata.Type : 'Edm.String'  @UI.Hidden;
        environment   : Association to one Environments;
        function      : String;
        type          : Association to one FunctionTypes;
        description   : String;
        inputFunction : Association to one FunctionsVH;
        inputFields   : Composition of many FunctionInputFields
                            on inputFields.function = $self;

        resultFields  : Composition of many FunctionResultFields
                            on resultFields.function = $self;
}

@cds.autoexpose
@cds.odata.valuelist
entity Fields {
    key ID          : UUID @odata.Type : 'Edm.String'  @UI.Hidden;
        environment : Association to one Environments;
        description : String;
}

@cds.autoexpose
@cds.odata.valuelist
entity FunctionsVH           as projection on Functions {
    environment,
    ID,
    type,
    description,
    ID as parameter1 : String
} where(
    type.code in (
        'MT', 'AL', 'CA')
    );

@assert.unique : {inputFunctionField : [
    inputFunction,
    field,
], }
entity FunctionInputFields {
    key ID            : UUID @odata.Type : 'Edm.String'  @UI.Hidden;
        environment   : Association to one Environments;
        function      : Association to one Functions;
        inputFunction : Association to one Functions;
        field         : Association to one FunctionInputFieldsVH;
}


entity FunctionResultFields {
    key ID          : UUID @odata.Type : 'Edm.String'  @UI.Hidden;
        environment : Association to one Environments;
        function    : Association to one Functions;
        field       : Association to one Fields;
}

@cds.autoexpose
@cds.odata.valuelist
entity FunctionInputFieldsVH as
    select from Fields
    left join FunctionResultFields
        on  Fields.ID             = FunctionResultFields.field.ID
        and Fields.environment.ID = FunctionResultFields.environment.ID
    {
        key Fields.ID,
            Fields.environment,
            Fields.description,
            FunctionResultFields.function.ID as function_ID
    };

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
