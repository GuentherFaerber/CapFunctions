module.exports = function () {
  this.before("READ", "FunctionsVH", async (req) => {
    console.log(req.data);
    req.query.SELECT.where[1] = "<>";
  });
  this.before("READ", "InputFunctionsVH", async (req) => {
    console.log(req.data);
    req.query.SELECT.where[1] = "<>";
  });
  this.before("NEW", "InputFunctions", async (req) => {
    const mainEntity = await SELECT.one.from("Functions").where({
      ID: req.data.ID,
    });
    req.data.environment_ID = mainEntity.environment_ID;
    req.data.inputFunction_ID = mainEntity.inputFunction_ID;
  });
};
