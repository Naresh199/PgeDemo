({
    dateName : function (vardate) {
        var monthNames = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        var dayNames = [ "Monday", "Thuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
        
        var dd = vardate.getDate();
        var dayname = dayNames[vardate.getDay()-1];
        var mm = monthNames[vardate.getMonth()];
        var yyyy = vardate.getFullYear();
        var fullDate = dayname + " " + dd + " " + mm + " " + yyyy;
        
        alert( "the current date is: " + fullDate );
    }
})