({
    doInit : function(component, event, helper) {
        component.set("v.editDisabled",true);
        component.set("v.showNew",true);
        helper.generateView(component, event, helper);
    },
    closeModel: function(component, event, helper) {
        component.destroy();
    },
    newview : function(component, event, helper){
        component.set("v.typeAction",'New');
        component.set("v.editMode",true); 
        component.set("v.showNew",false);
        helper.cloneview(component, event, helper) ;
    },
    saveViewConfig : function(component, event, helper){
        helper.saveNewView(component, event, helper) ;
        //helper.loadViewRec(component, event, helper);
    }, 
    loadView : function(component, event, helper){
        debugger;
        helper.loadViewRec(component, event, helper);
        component.set('v.msg','');
    },
    EditView : function(component, event, helper){
        component.set("v.editMode",true);
        component.set("v.showNew",false);
        component.set("v.typeAction",'Edit');
    },
    deleteView : function(component, event, helper){
        helper.deleteViewRec(component, event, helper) ;
    },
    handleChange : function(component, event, helper){
        debugger;
        component.set('v.defaultOptions',event.getParam("value")); 
    }
    
})