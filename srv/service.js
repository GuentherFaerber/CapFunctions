const cds = require("@sap/cds");

module.exports = function () {

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

  this.before("SAVE", "Functions", async (req) => {
    console.log(req.data);
    await checkDeepEntityColumns(req, req.target.name, req.data);
    // This should be detected automatically, because field 7 i from another environment
    // Reading all name-equal fields from main entity and inner join with inputFields should bring this issue up
    // req.data.inputFields[0].field_ID = '7';
    // This is detected by CDS automatically
    // req.data.inputFields[0].field_ID = '17';
  });

  this.before("READ", "FunctionsVH", async (req) => {
    // Tweak value help parameter to parameter1 <> ID of own function
    req.query.SELECT.where[1] = "<>";
  });

};

async function checkDeepEntityColumns(req, entityName, data) {
  console.log(req.data);
  const entity = cds.entities[entityName];
  const columns = [];
  for (const element of Object.values(entity.elements)) {
    if (
      element.type === "cds.Association" &&
      element.is2one &&
      element["@Common.ValueList.Parameters"]
    ) {
      // Only parameters going in are relevant, and if they are not artifical (starting with "parameter")
      const parameters = element["@Common.ValueList.Parameters"].filter(
        (f) =>
          f["$Type"].startsWith("Common.ValueListParameterIn") &&
          !f.ValueListProperty.startsWith("parameter")
      );
      if (parameters) {
        let sql = `SELECT * FROM ${element.target.replace(
          ".",
          "_"
        )} WHERE 1 = 1`;
        for (const parameter of parameters) {
          sql =
            sql +
            ` AND ${parameter.ValueListProperty} = '${
              data[parameter.LocalDataProperty["="]]
            }'`;
        }
        const result = await cds.run(sql);
        if (!result?.length) {
          req.error(sql, element.name, []);
        }
      }
      continue;
    }
    if (
      element.type === "cds.Composition" &&
      element.target &&
      element.is2many
    ) {
      for (const record of data[element.name]) {
        checkDeepEntityColumns(req, element.target, record);
      }
    }
  }
  return columns;
}
