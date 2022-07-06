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

  this.before("READ", "FunctionsVH", async (req) => {
    // Tweak value help parameter to parameter1 <> ID of own function
    req.query.SELECT.where[1] = "<>";
  });

  this.before("SAVE", "Functions", async (req) => {
    await checkDeepEntityColumns(req, req.target.name, req.data);
  });
};

async function checkDeepEntityColumns(req, entityName, data) {
  const entity = cds.entities[entityName];
  for (const element of Object.values(entity.elements)) {
    if (
      element.type === "cds.Association" &&
      element.is2one &&
      element["@Common.ValueList.Parameters"]
    ) {
      // Only parametersIn* are relevant, and if they are not artifical (not starting with "parameter*")
      const parameters = element["@Common.ValueList.Parameters"].filter(
        (f) =>
          f["$Type"].startsWith("Common.ValueListParameterIn") &&
          !f.ValueListProperty.startsWith("parameter")
      );
      if (parameters) {
        let sql = `SELECT * FROM ${element.target.replace(".", "_")} WHERE 1 = 1`;
        for (const parameter of parameters) {
          sql =
            sql +
            ` AND ${parameter.ValueListProperty} = '${
              data[parameter.LocalDataProperty["="]]
            }'`;
        }
        const result = await cds.run(sql);
        if (!result?.length) {
          // raise error if value is not in restricted value help view
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
}
