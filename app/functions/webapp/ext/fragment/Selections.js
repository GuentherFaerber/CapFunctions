sap.ui.define(
  ["sap/m/MessageToast", "sap/ui/core/Fragment"],
  function (MessageToast, Fragment) {
    "use strict";

    return {
      onPress: function () {
        MessageToast.show("Custom handler invoked.");
      },
      onOpenValueHelp: function (event) {
        const view = this.editFlow.getView();

        if (!this._dialog) {
          this._dialog = Fragment.load({
            id: view.getId(),
            name: "functions.ext.fragment.FieldValueHelp",
            controller: {
              onValueHelpDialogClose: (event) => {
                const listBinding = this.editFlow
                  .getView()
                  .byId(
                    this.editFlow.getView().getId() +
                      "--fe::table::inputFields::LineItem::InputFields-innerTable"
                  );

                for (const selectedItem of event.getParameter(
                  "selectedItems"
                )) {
                  const id = selectedItem.getBindingContext().getProperty("ID");
                  const field = selectedItem
                    .getBindingContext()
                    .getProperty("field");
                  // const createPath = `${this.getBindingContext().getPath()}/inputFields`;
                  // this.getModel().bindList(createPath).create({"field_ID":"9"});
                  // const result = await this.editFlow.createDocument(createPath,{creationMode:"Inline"})
                  listBinding.getBinding("items").create({ field_ID: id });
                }
                MessageToast.show("Custom handler invoked.");
                //functions(ID='117396f8-1aaa-40f6-bb70-500e30f24960',IsActiveEntity=false)/inputFields
              },
            },
          }).then(function (dialog) {
            dialog.setModel(view.getModel());
            return dialog;
          });
        }

        this._dialog.then((dialog) => {
          dialog.open();
        });
      },
    };
  }
);
