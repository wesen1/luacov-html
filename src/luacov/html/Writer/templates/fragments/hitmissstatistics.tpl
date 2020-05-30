{#
 # @author wesen
 # @copyright 2020 wesen <wesen-ac@web.de>
 # @release 0.1
 # @license MIT
 #}

<ul class="inline-list">
  <li>
    <span class="strong">{{ hitMissStatistics.formattedHitPercentage }}%</span>
    <span class="quiet">Rate</span>
  </li>
  <li>
    <span class="strong">{{ hitMissStatistics.numberOfHits }}</span>
    <span class="quiet">Hits</span>
  </li>
  <li>
    <span class="strong">{{ hitMissStatistics.numberOfMisses }}</span>
    <span class="quiet">Missed</span>
  </li>
</ul>

<div class="hit-percentage-status hit-percentage-status-{* hitMissStatistics.hitPercentageStatusText *}"></div>
