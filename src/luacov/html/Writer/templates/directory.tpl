{#
 # @author wesen
 # @copyright 2020 wesen <wesen-ac@web.de>
 # @release 0.1
 # @license MIT
 #}

{% layout = templateDirectoryPath .. "/base.tpl" %}

{-content-}

  <table>

    {% if (#fileSystemEntries == 0) then %}
      <tr>
        <td class="empty-result-text">No covered files found</td>
      </tr>
    {% else %}

      <thead>
        <tr>
          <th width="55%">File</th>
          <th width="24%"></th>
          <th width="7%">Rate</th>
          <th width="7%">Hits</th>
          <th width="7%">Missed</th>
        </tr>
      </thead>


      {% for _, fileSystemEntry in ipairs(fileSystemEntries) do %}

        <tr class="coverage-status-{* fileSystemEntry.hitMissStatistics.hitPercentageStatusText *}">
          <td>
            <a href="{* fileSystemEntry.relativePath *}">{{ fileSystemEntry.name }}</a>
          </td>
          <td>
            <div class="chart">
              <div class="chartfill hit-percentage-status-{* fileSystemEntry.hitMissStatistics.hitPercentageStatusText *}" style="width:{* fileSystemEntry.hitMissStatistics.formattedHitPercentage *}%;"></div>
            </div>
          </td>
          <td class="result-number">{{ fileSystemEntry.hitMissStatistics.formattedHitPercentage }}%</td>
          <td class="result-number">{{ fileSystemEntry.hitMissStatistics.numberOfHits }}</td>
          <td class="result-number">{{ fileSystemEntry.hitMissStatistics.numberOfMisses }}</td>
        </tr>

      {% end %}

    {% end %}

  </table>

{-content-}
