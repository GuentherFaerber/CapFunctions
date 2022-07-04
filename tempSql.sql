
CREATE TABLE Environments (
  ID NVARCHAR(36) NOT NULL,
  environment NVARCHAR(5000),
  version NVARCHAR(5000),
  description NVARCHAR(5000),
  PRIMARY KEY(ID)
);

CREATE TABLE Functions (
  ID NVARCHAR(36) NOT NULL,
  environment_ID NVARCHAR(36),
  function NVARCHAR(5000),
  type_code NVARCHAR(10) DEFAULT 'AL',
  description NVARCHAR(5000),
  inputFunction_ID NVARCHAR(36),
  PRIMARY KEY(ID)
);

CREATE TABLE Fields (
  ID NVARCHAR(36) NOT NULL,
  environment_ID NVARCHAR(36),
  description NVARCHAR(5000),
  PRIMARY KEY(ID)
);

CREATE TABLE FunctionInputFields (
  ID NVARCHAR(36) NOT NULL,
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  inputFunction_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT FunctionInputFields_inputFunctionField UNIQUE (inputFunction_ID, field_ID)
);

CREATE TABLE FunctionResultFields (
  ID NVARCHAR(36) NOT NULL,
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID)
);

CREATE TABLE FunctionTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'AL',
  PRIMARY KEY(code)
);

CREATE TABLE FunctionTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'AL',
  PRIMARY KEY(locale, code)
);

CREATE TABLE DRAFT_DraftAdministrativeData (
  DraftUUID NVARCHAR(36) NOT NULL,
  CreationDateTime TIMESTAMP_TEXT,
  CreatedByUser NVARCHAR(256),
  DraftIsCreatedByMe BOOLEAN,
  LastChangeDateTime TIMESTAMP_TEXT,
  LastChangedByUser NVARCHAR(256),
  InProcessByUser NVARCHAR(256),
  DraftIsProcessedByMe BOOLEAN,
  PRIMARY KEY(DraftUUID)
);

CREATE TABLE ModelingService_Functions_drafts (
  ID NVARCHAR(36) NOT NULL,
  environment_ID NVARCHAR(36) NULL,
  function NVARCHAR(5000) NULL,
  type_code NVARCHAR(10) NULL DEFAULT 'AL',
  description NVARCHAR(5000) NULL,
  inputFunction_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_FunctionInputFields_drafts (
  ID NVARCHAR(36) NOT NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  inputFunction_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_FunctionResultFields_drafts (
  ID NVARCHAR(36) NOT NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE VIEW ModelingService_Functions AS SELECT
  functions_0.ID,
  functions_0.environment_ID,
  functions_0.function,
  functions_0.type_code,
  functions_0.description,
  functions_0.inputFunction_ID
FROM Functions AS functions_0;

CREATE VIEW FunctionsVH AS SELECT
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.type_code,
  Functions_0.description,
  Functions_0.ID AS parameter1
FROM Functions AS Functions_0
WHERE Functions_0.type_code IN ('MT', 'AL', 'CA');

CREATE VIEW FunctionInputFieldsVH AS SELECT
  Fields_0.ID,
  Fields_0.environment_ID,
  Fields_0.description,
  FunctionResultFields_1.function_ID AS function_ID
FROM (Fields AS Fields_0 LEFT JOIN FunctionResultFields AS FunctionResultFields_1 ON Fields_0.ID = FunctionResultFields_1.field_ID AND Fields_0.environment_ID = FunctionResultFields_1.environment_ID);

CREATE VIEW ModelingService_Environments AS SELECT
  Environments_0.ID,
  Environments_0.environment,
  Environments_0.version,
  Environments_0.description
FROM Environments AS Environments_0;

CREATE VIEW ModelingService_FunctionTypes AS SELECT
  FunctionTypes_0.name,
  FunctionTypes_0.descr,
  FunctionTypes_0.code
FROM FunctionTypes AS FunctionTypes_0;

CREATE VIEW ModelingService_FunctionInputFields AS SELECT
  FunctionInputFields_0.ID,
  FunctionInputFields_0.environment_ID,
  FunctionInputFields_0.function_ID,
  FunctionInputFields_0.inputFunction_ID,
  FunctionInputFields_0.field_ID
FROM FunctionInputFields AS FunctionInputFields_0;

CREATE VIEW ModelingService_FunctionResultFields AS SELECT
  FunctionResultFields_0.ID,
  FunctionResultFields_0.environment_ID,
  FunctionResultFields_0.function_ID,
  FunctionResultFields_0.field_ID
FROM FunctionResultFields AS FunctionResultFields_0;

CREATE VIEW ModelingService_FunctionTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM FunctionTypes_texts AS texts_0;

CREATE VIEW ModelingService_Fields AS SELECT
  Fields_0.ID,
  Fields_0.environment_ID,
  Fields_0.description
FROM Fields AS Fields_0;

CREATE VIEW localized_FunctionTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (FunctionTypes AS L_0 LEFT JOIN FunctionTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_Functions AS SELECT
  L.ID,
  L.environment_ID,
  L.function,
  L.type_code,
  L.description,
  L.inputFunction_ID
FROM Functions AS L;

CREATE VIEW localized_FunctionInputFields AS SELECT
  L.ID,
  L.environment_ID,
  L.function_ID,
  L.inputFunction_ID,
  L.field_ID
FROM FunctionInputFields AS L;

CREATE VIEW localized_FunctionResultFields AS SELECT
  L.ID,
  L.environment_ID,
  L.function_ID,
  L.field_ID
FROM FunctionResultFields AS L;

CREATE VIEW ModelingService_DraftAdministrativeData AS SELECT
  DraftAdministrativeData.DraftUUID,
  DraftAdministrativeData.CreationDateTime,
  DraftAdministrativeData.CreatedByUser,
  DraftAdministrativeData.DraftIsCreatedByMe,
  DraftAdministrativeData.LastChangeDateTime,
  DraftAdministrativeData.LastChangedByUser,
  DraftAdministrativeData.InProcessByUser,
  DraftAdministrativeData.DraftIsProcessedByMe
FROM DRAFT_DraftAdministrativeData AS DraftAdministrativeData;

CREATE VIEW ModelingService_FunctionsVH AS SELECT
  FunctionsVH_0.environment_ID,
  FunctionsVH_0.ID,
  FunctionsVH_0.type_code,
  FunctionsVH_0.description,
  FunctionsVH_0.parameter1
FROM FunctionsVH AS FunctionsVH_0;

CREATE VIEW ModelingService_FunctionInputFieldsVH AS SELECT
  FunctionInputFieldsVH_0.ID,
  FunctionInputFieldsVH_0.environment_ID,
  FunctionInputFieldsVH_0.description,
  FunctionInputFieldsVH_0.function_ID
FROM FunctionInputFieldsVH AS FunctionInputFieldsVH_0;

CREATE VIEW localized_FunctionsVH AS SELECT
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.type_code,
  Functions_0.description,
  Functions_0.ID AS parameter1
FROM localized_Functions AS Functions_0
WHERE Functions_0.type_code IN ('MT', 'AL', 'CA');

CREATE VIEW localized_ModelingService_FunctionTypes AS SELECT
  FunctionTypes_0.name,
  FunctionTypes_0.descr,
  FunctionTypes_0.code
FROM localized_FunctionTypes AS FunctionTypes_0;

CREATE VIEW localized_ModelingService_Functions AS SELECT
  functions_0.ID,
  functions_0.environment_ID,
  functions_0.function,
  functions_0.type_code,
  functions_0.description,
  functions_0.inputFunction_ID
FROM localized_Functions AS functions_0;

CREATE VIEW localized_ModelingService_FunctionInputFields AS SELECT
  FunctionInputFields_0.ID,
  FunctionInputFields_0.environment_ID,
  FunctionInputFields_0.function_ID,
  FunctionInputFields_0.inputFunction_ID,
  FunctionInputFields_0.field_ID
FROM localized_FunctionInputFields AS FunctionInputFields_0;

CREATE VIEW localized_ModelingService_FunctionResultFields AS SELECT
  FunctionResultFields_0.ID,
  FunctionResultFields_0.environment_ID,
  FunctionResultFields_0.function_ID,
  FunctionResultFields_0.field_ID
FROM localized_FunctionResultFields AS FunctionResultFields_0;

CREATE VIEW localized_ModelingService_FunctionsVH AS SELECT
  FunctionsVH_0.environment_ID,
  FunctionsVH_0.ID,
  FunctionsVH_0.type_code,
  FunctionsVH_0.description,
  FunctionsVH_0.parameter1
FROM localized_FunctionsVH AS FunctionsVH_0;

CREATE VIEW localized_de_FunctionTypes AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (FunctionTypes AS L_0 LEFT JOIN FunctionTypes_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_FunctionTypes AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (FunctionTypes AS L_0 LEFT JOIN FunctionTypes_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_Functions AS SELECT
  L.ID,
  L.environment_ID,
  L.function,
  L.type_code,
  L.description,
  L.inputFunction_ID
FROM Functions AS L;

CREATE VIEW localized_fr_Functions AS SELECT
  L.ID,
  L.environment_ID,
  L.function,
  L.type_code,
  L.description,
  L.inputFunction_ID
FROM Functions AS L;

CREATE VIEW localized_de_FunctionInputFields AS SELECT
  L.ID,
  L.environment_ID,
  L.function_ID,
  L.inputFunction_ID,
  L.field_ID
FROM FunctionInputFields AS L;

CREATE VIEW localized_fr_FunctionInputFields AS SELECT
  L.ID,
  L.environment_ID,
  L.function_ID,
  L.inputFunction_ID,
  L.field_ID
FROM FunctionInputFields AS L;

CREATE VIEW localized_de_FunctionResultFields AS SELECT
  L.ID,
  L.environment_ID,
  L.function_ID,
  L.field_ID
FROM FunctionResultFields AS L;

CREATE VIEW localized_fr_FunctionResultFields AS SELECT
  L.ID,
  L.environment_ID,
  L.function_ID,
  L.field_ID
FROM FunctionResultFields AS L;

CREATE VIEW localized_de_FunctionsVH AS SELECT
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.type_code,
  Functions_0.description,
  Functions_0.ID AS parameter1
FROM localized_de_Functions AS Functions_0
WHERE Functions_0.type_code IN ('MT', 'AL', 'CA');

CREATE VIEW localized_fr_FunctionsVH AS SELECT
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.type_code,
  Functions_0.description,
  Functions_0.ID AS parameter1
FROM localized_fr_Functions AS Functions_0
WHERE Functions_0.type_code IN ('MT', 'AL', 'CA');

CREATE VIEW localized_de_ModelingService_FunctionTypes AS SELECT
  FunctionTypes_0.name,
  FunctionTypes_0.descr,
  FunctionTypes_0.code
FROM localized_de_FunctionTypes AS FunctionTypes_0;

CREATE VIEW localized_fr_ModelingService_FunctionTypes AS SELECT
  FunctionTypes_0.name,
  FunctionTypes_0.descr,
  FunctionTypes_0.code
FROM localized_fr_FunctionTypes AS FunctionTypes_0;

CREATE VIEW localized_de_ModelingService_Functions AS SELECT
  functions_0.ID,
  functions_0.environment_ID,
  functions_0.function,
  functions_0.type_code,
  functions_0.description,
  functions_0.inputFunction_ID
FROM localized_de_Functions AS functions_0;

CREATE VIEW localized_fr_ModelingService_Functions AS SELECT
  functions_0.ID,
  functions_0.environment_ID,
  functions_0.function,
  functions_0.type_code,
  functions_0.description,
  functions_0.inputFunction_ID
FROM localized_fr_Functions AS functions_0;

CREATE VIEW localized_de_ModelingService_FunctionInputFields AS SELECT
  FunctionInputFields_0.ID,
  FunctionInputFields_0.environment_ID,
  FunctionInputFields_0.function_ID,
  FunctionInputFields_0.inputFunction_ID,
  FunctionInputFields_0.field_ID
FROM localized_de_FunctionInputFields AS FunctionInputFields_0;

CREATE VIEW localized_fr_ModelingService_FunctionInputFields AS SELECT
  FunctionInputFields_0.ID,
  FunctionInputFields_0.environment_ID,
  FunctionInputFields_0.function_ID,
  FunctionInputFields_0.inputFunction_ID,
  FunctionInputFields_0.field_ID
FROM localized_fr_FunctionInputFields AS FunctionInputFields_0;

CREATE VIEW localized_de_ModelingService_FunctionResultFields AS SELECT
  FunctionResultFields_0.ID,
  FunctionResultFields_0.environment_ID,
  FunctionResultFields_0.function_ID,
  FunctionResultFields_0.field_ID
FROM localized_de_FunctionResultFields AS FunctionResultFields_0;

CREATE VIEW localized_fr_ModelingService_FunctionResultFields AS SELECT
  FunctionResultFields_0.ID,
  FunctionResultFields_0.environment_ID,
  FunctionResultFields_0.function_ID,
  FunctionResultFields_0.field_ID
FROM localized_fr_FunctionResultFields AS FunctionResultFields_0;

CREATE VIEW localized_de_ModelingService_FunctionsVH AS SELECT
  FunctionsVH_0.environment_ID,
  FunctionsVH_0.ID,
  FunctionsVH_0.type_code,
  FunctionsVH_0.description,
  FunctionsVH_0.parameter1
FROM localized_de_FunctionsVH AS FunctionsVH_0;

CREATE VIEW localized_fr_ModelingService_FunctionsVH AS SELECT
  FunctionsVH_0.environment_ID,
  FunctionsVH_0.ID,
  FunctionsVH_0.type_code,
  FunctionsVH_0.description,
  FunctionsVH_0.parameter1
FROM localized_fr_FunctionsVH AS FunctionsVH_0;
