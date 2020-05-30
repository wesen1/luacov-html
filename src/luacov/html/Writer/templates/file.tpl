{#
 # @author wesen
 # @copyright 2020 wesen <wesen-ac@web.de>
 # @release 0.1
 # @license MIT
 #}

{% layout = templateDirectoryPath .. "/base.tpl" %}

{-content-}

  <section class="file-coverage">

    <ul class="line-numbers undecorated">
      {% for _, lineCoverage in ipairs(lineCoverages) do %}
        <li>{{ lineCoverage.lineNumber }}</li>
      {% end %}
    </ul>

    <ul class="line-coverages undecorated">
      {% for _, lineCoverage in ipairs(lineCoverages) do %}
        <li class="line-{* lineCoverage.coverageType *}">{{ lineCoverage.numberOfHitsText }}</li>
      {% end %}
    </ul>

    <ul class="code undecorated">
      {% for _, lineCoverage in ipairs(lineCoverages) do %}
        <li class="line-{* lineCoverage.coverageType *}">{{ lineCoverage.line }}</li>
      {% end %}
    </ul>

  </section>

{-content-}
