{#
{% for i in range(10) %}

    select {{ i }} as number
    {% if not loop.last %}
        union all
    {% endif %}

{% endfor %}
#}
{% set my_animals = ["cat", "dog"] %} {{ my_animals }}



{%- for animal in my_animals %}

    My fav animal is {{ animal }}

{%- endfor %}