{% test value_check(model, column_name) %} 

SELECT * 
FROM {{model}}
WHERE {{column_name}} < 1e4

{% endtest %}