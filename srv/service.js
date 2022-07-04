const cds = require("@sap/cds");

module.exports = function () {
  this.before("READ", "FunctionsVH", async (req) => {
    // parameter1 <> ID of own function
    req.query.SELECT.where[1] = "<>";
  });
  this.before("READ", "FunctionInputFieldsVH", async (req) => {
    // Modification of value help to avoid showing existing fields
    console.log(req.query.where);
    // req.query.SELECT.where.push("and ID not in (SELECT field_ID from ModelingService_FunctionInputFields_drafts AS X WHERE X.DraftAdministrativeData_DraftUUID = DraftAdministrativeData_DraftUUID)");
  });
  this.before("NEW", "FunctionInputFields", async (req) => {
    const mainEntity = await SELECT.one
      .from("ModelingService_Functions_drafts")
      .where({
        DraftAdministrativeData_DraftUUID:
          req.data.DraftAdministrativeData_DraftUUID,
      });
    req.data.environment_ID = mainEntity.environment_ID;
    req.data.inputFunction_ID = mainEntity.inputFunction_ID;
  });
};
