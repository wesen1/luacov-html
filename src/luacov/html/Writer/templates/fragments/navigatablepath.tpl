{#
 # @author wesen
 # @copyright 2020 wesen <wesen-ac@web.de>
 # @release 0.1
 # @license MIT
 #}

<ul class="inline-list">
  {% for _, pathPart in ipairs(pathParts) do %}
    <li>
      <a href="{* pathPart.relativePath *}">{{ pathPart.name }}</a> /
    </li>
  {% end %}

  <li>{{ baseName }}</li>
</ul>
