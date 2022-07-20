sap.ui.define(
  [
    "sap/ui/core/mvc/ControllerExtension",
    "sap/ui/core/Fragment",
    "sap/ui/model/json/JSONModel",
    "sap/m/MessageBox",
    "sap/ui/core/message/Message",
    "sap/ui/core/MessageType",
    // ,'sap/ui/core/mvc/OverrideExecution'
  ],
  function (
    ControllerExtension,
    Fragment,
    JSONModel,
    MessageBox,
    Message,
    MessageType
    // ,OverrideExecution
  ) {
    "use strict";
    return ControllerExtension.extend("functions.ext.CustomController", {
      override: {
        // 	/**
        // 	 * Called when a controller is instantiated and its View controls (if available) are already created.
        // 	 * Can be used to modify the View before it is displayed, to bind event handlers and do other one-time initialization.
        // 	 * @memberOf customer.managecustomerjit.UpdatePartGroup
        // 	 */
        onInit: function () {
          // this.base.byId(this.getView().getId() + "--componentgroup::responsiveTable");
        },
      },
    });
  }
);
