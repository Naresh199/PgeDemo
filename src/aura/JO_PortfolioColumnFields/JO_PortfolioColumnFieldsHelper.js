({
	doInit : function(component, event, helper) {
        var record = component.get("v.record");
        var field = component.get("v.field");
        debugger;

        //console.log(field.type);
        var relname = field.name.split('.');
        
        if(relname.length == 1)
        	component.set("v.cellValue", record[field.name]);
        else
        {
            var parstr = record[relname[0]];
            if (parstr != undefined)
            	component.set("v.cellValue", parstr[relname[1]] == undefined ? '' : parstr[relname[1]]);
            else
            	component.set("v.cellValue", '');
        }   

        switch (field.type){
            case 'STRING':
                component.set("v.cellLabel",record.Id);
                component.set("v.isTextField", true);
                break;
            case 'PICKLIST':
                component.set("v.cellLabel",record.Id);
                component.set("v.isTextField", true);
                break;
            case 'DATE': component.set("v.isDateField", true);
                break;
            case 'EMAIL': component.set("v.isEmailField", true);
                break;
            case 'PHONE': component.set("v.isPhoneField", true);
                break;
            case 'DATETIME': component.set("v.isDateTimeField", true);
                break;
            case 'CURRENCY': component.set("v.isCurrencyField", true);
                break;
            case 'REFERENCE':
                component.set("v.isReferenceField", true);
                var relationShipName = '';
                if(field.name.indexOf('__c') == -1) {
                    relationShipName = field.name.substring(0, field.name.indexOf('Id'));
                }
                else {
                    relationShipName = field.name.substring(0, field.name.indexOf('__c')) + '__r';
                }
                if(record[relationShipName] != undefined){
                    component.set("v.cellLabel", record[relationShipName].Name);
                }
                else component.set("v.cellLabel", record[field.name.substring(0, field.name.indexOf('__r')) + '__c']);
                break;
            case 'LINK':
                var relationShipName = '';
                if(field.name.indexOf('__c') == -1)
                    relationShipName = field.name;
                else  relationShipName = field.name.substring(0, field.name.indexOf('__c')) + '__r';

                if(record[relationShipName] != undefined){
                    var fieldValue = record[relationShipName].Name != undefined ? record[relationShipName].Name : record[relationShipName];
                    component.set("v.cellLabel", fieldValue);
                    component.set("v.isLinkField", true);
                }
                else component.set("v.cellLabel", record[field.name.substring(0, field.name.indexOf('__r')) + '__c']);
                break;
            default : break;
        }
    }
})