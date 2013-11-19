if((params["Customer"].value == "Select All") && (params["Product"].value == "Select All")) {
this.queryText = this.queryText.replace('/*wq*/', "where tot.customer_name LIKE '%%' " + 
"AND tot.product_category LIKE '%%' " );
} else if ((params["Customer"].value == "Select All") && (params["Product"].value != "Select All")) {
this.queryText = this.queryText.replace('/*wq*/', "where tot.customer_name LIKE '%%' " + 
"AND tot.product_category = '" + params["Product"].value + "' " );
} else if ((params["Customer"].value != "Select All") && (params["Product"].value == "Select All")) {
this.queryText = this.queryText.replace('/*wq*/', "where tot.customer_name = '" + params["Customer"].value + "' " + 
"AND tot.product_category LIKE '%%' " );
} else {
this.queryText = this.queryText.replace('/*wq*/', "where tot.customer_name = '" + params["Customer"].value + "' " + 
"AND tot.product_category = '" + params["Product"].value + "' " );
}

Packages.java.lang.System.out.print("\b\b");
Packages.java.lang.System.out.print("###############");
Packages.java.lang.System.out.print("\b\b");
Packages.java.lang.System.out.println(this.queryText);