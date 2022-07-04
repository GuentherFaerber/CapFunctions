using ModelingService as service from '../../srv/service';
using from '../../srv/service';
using from '../../db/schema';


annotate service.Functions with @(UI.LineItem : [
    {
        $Type : 'UI.DataField',
        Label : 'function',
        Value : function,
    },
    {
        $Type : 'UI.DataField',
        Label : 'type_code',
        Value : type_code,
    },
    {
        $Type : 'UI.DataField',
        Label : 'description',
        Value : description,
    },
]);

annotate service.Functions with @(
    UI.Facets                         : [
        {
            $Type  : 'UI.ReferenceFacet',
            Label  : 'General Information',
            ID     : 'GeneralInformation',
            Target : '@UI.FieldGroup#GeneralInformation',
        },
        {
            $Type  : 'UI.ReferenceFacet',
            Label  : 'Input Fields',
            ID     : 'InputFields',
            Target : 'inputFields/@UI.LineItem#InputFields',
        },
    ],
    UI.FieldGroup #GeneralInformation : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {
                $Type : 'UI.DataField',
                Value : function,
                Label : 'function',
            },
            {
                $Type : 'UI.DataField',
                Value : type_code,
                Label : 'type_code',
            },
            {
                $Type : 'UI.DataField',
                Value : description,
                Label : 'description',
            },
            {
                $Type : 'UI.DataField',
                Value : environment_ID,
                Label : 'environment_ID',
            },
            {
                $Type : 'UI.DataField',
                Value : inputFunction_ID,
                Label : 'inputFunction_ID',
            },
        ],
    }
);

annotate service.FunctionsVH with {
    ID @Common.Text : description
};

annotate service.FunctionInputFields with @(UI.LineItem #InputFields : [
    {
        $Type : 'UI.DataField',
        Value : field_ID,
        Label : 'field_ID',
    },
    {
        $Type : 'UI.DataField',
        Value : environment_ID,
        Label : 'environment_ID',
    },
    {
        $Type : 'UI.DataField',
        Value : function_ID,
        Label : 'function_ID',
    },
    {
        $Type : 'UI.DataField',
        Value : inputFunction_ID,
        Label : 'inputFunction_ID',
    },]);

annotate service.FunctionInputFields with @(
    UI.Facets                  : [{
        $Type  : 'UI.ReferenceFacet',
        Label  : 'Input Fields',
        ID     : 'InputFields',
        Target : '@UI.FieldGroup#InputFields',
    }, ],
    UI.FieldGroup #InputFields : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {
                $Type : 'UI.DataField',
                Value : field_ID,
                Label : 'field_ID',
            },
            {
                $Type : 'UI.DataField',
                Value : environment_ID,
                Label : 'environment_ID',
            },
            {
                $Type : 'UI.DataField',
                Value : function_ID,
                Label : 'function_ID',
            },
            {
                $Type : 'UI.DataField',
                Value : inputFunction_ID,
                Label : 'inputFunction_ID',
            },
        ],
    }
);

annotate service.FunctionInputFields with {
    field @Common.ValueListWithFixedValues : false
};

annotate service.FunctionInputFieldsVH with {
    ID @Common.Text : description
};

annotate service.FunctionInputFields with {
    field @Common.ValueList : {
        $Type          : 'Common.ValueListType',
        CollectionPath : 'FunctionInputFieldsVH',
        Parameters     : [
            {
                $Type             : 'Common.ValueListParameterIn',
                LocalDataProperty : environment_ID,
                ValueListProperty : 'environment_ID',
            },
            {
                $Type             : 'Common.ValueListParameterIn',
                LocalDataProperty : inputFunction_ID,
                ValueListProperty : 'function_ID',
            },
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : field_ID,
                ValueListProperty : 'ID',
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'description',
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'environment_ID',
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'function_ID',
            },
        ],
    }
};

annotate service.Functions with {
    inputFunction @(Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'FunctionsVH',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterIn',
                    LocalDataProperty : ID,
                    ValueListProperty : 'parameter1',
                },
                {
                    $Type : 'Common.ValueListParameterIn',
                    LocalDataProperty : environment_ID,
                    ValueListProperty : 'environment_ID',
                },
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : inputFunction_ID,
                    ValueListProperty : 'ID',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'type_code',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'description',
                },
            ],
        },
        Common.ValueListWithFixedValues : false
)};

annotate service.FunctionInputFields with {
    field @Common.Text : field.description
};
