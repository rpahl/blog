---
title: "Quicker knitr kables in RStudio notebook"


date: "November 17, 2019"
layout: post
---


<section class="main-content">
<div id="the-setup" class="section level2">
<h2>The setup</h2>
<p>The <a href="https://rstudio.com/">RStudio</a> notebook is a great interactive tool to build a statistical report. Being able to see statistics and graphs right on the fly probably has saved me countless hours, especially when building complex reports.</p>
<p>However, one thing that has always bothered me was the way tables are displayed in the notebook with <a href="https://CRAN.R-project.org/package=knitr">knitr</a>’s <code>kable</code> function. For example, consider the <code>airquality</code> data set:</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="kw">head</span>(airquality)</code></pre></div>
<pre><code>##   Ozone Solar.R Wind Temp Month Day
## 1    41     190  7.4   67     5   1
## 2    36     118  8.0   72     5   2
## 3    12     149 12.6   74     5   3
## 4    18     313 11.5   62     5   4
## 5    NA      NA 14.3   56     5   5
## 6    28      NA 14.9   66     5   6</code></pre>
<p>To get a nice table in your report you type</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">knitr<span class="op">::</span><span class="kw">kable</span>(<span class="kw">head</span>(airquality), <span class="dt">caption =</span> <span class="st">&quot;New York Air Quality Measurements.&quot;</span>)</code></pre></div>
<p>which shows up nicely formatted in the final output</p>
<table>
<caption>New York Air Quality Measurements.</caption>
<thead>
<tr class="header">
<th align="right">Ozone</th>
<th align="right">Solar.R</th>
<th align="right">Wind</th>
<th align="right">Temp</th>
<th align="right">Month</th>
<th align="right">Day</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="right">41</td>
<td align="right">190</td>
<td align="right">7.4</td>
<td align="right">67</td>
<td align="right">5</td>
<td align="right">1</td>
</tr>
<tr class="even">
<td align="right">36</td>
<td align="right">118</td>
<td align="right">8.0</td>
<td align="right">72</td>
<td align="right">5</td>
<td align="right">2</td>
</tr>
<tr class="odd">
<td align="right">12</td>
<td align="right">149</td>
<td align="right">12.6</td>
<td align="right">74</td>
<td align="right">5</td>
<td align="right">3</td>
</tr>
<tr class="even">
<td align="right">18</td>
<td align="right">313</td>
<td align="right">11.5</td>
<td align="right">62</td>
<td align="right">5</td>
<td align="right">4</td>
</tr>
<tr class="odd">
<td align="right">NA</td>
<td align="right">NA</td>
<td align="right">14.3</td>
<td align="right">56</td>
<td align="right">5</td>
<td align="right">5</td>
</tr>
<tr class="even">
<td align="right">28</td>
<td align="right">NA</td>
<td align="right">14.9</td>
<td align="right">66</td>
<td align="right">5</td>
<td align="right">6</td>
</tr>
</tbody>
</table>
<p><br></p>
</div>
<div id="the-problem" class="section level2">
<h2>The problem</h2>
<p><em>But</em> in the interactive RStudio notebook session the table looks something like the following:</p>
<p><img src="{{ site.url }}{{ site.baseurl }}\images\kable.png" width="100%" /></p>
<p>So first of all, the formatting is not that great. Secondly, the table chunk consumes way too much space of the notebook and, at times, can be very cumbersome to scroll. Also for bigger tables (and depending on your hardware) it can take up to a few seconds for the table to be built.</p>
<p>So often when I was using <code>kable</code>, I felt my workflow being disrupted. In the interactive session I want a table being built quickly and in a clean format. Now, using the simple <code>print</code> function you’ll get exactly this</p>
<p><img src="{{ site.url }}{{ site.baseurl }}\images\print-table.png" width="100%" /></p>
<p>So my initial quick-and-dirty workaround during the interactive session was to comment out the <code>knitr</code> statement and use the print function.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="co">#knitr::kable(head(airquality), caption = &quot;New York Air Quality Measurements.&quot;)</span>
<span class="kw">print</span>(<span class="kw">head</span>(airquality))</code></pre></div>
<p>Then, only when creating the final report, I would comment out the <code>print</code> function and use <code>kable</code> again. Of course, there is a much more elegant and easier solution to get this without having to switch between functions.</p>
</div>
<div id="the-solution" class="section level2">
<h2>The solution</h2>
<p>We define a simple wrapper, which chooses the corresponding function depending on the context:</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">kable_if &lt;-<span class="st"> </span><span class="cf">function</span>(x, ...) <span class="cf">if</span> (<span class="kw">interactive</span>()) <span class="kw">print</span>(x, ...) <span class="cf">else</span> knitr<span class="op">::</span><span class="kw">kable</span>(x, ...)</code></pre></div>
<p>Then you simply call it as you would invoke <code>kable</code> and now you get both, the quick table in the interactive session … <img src="{{ site.url }}{{ site.baseurl }}\images\kable_if.png" width="100%" /></p>
<p>… and a formatted table in the report.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="kw">kable_if</span>(<span class="kw">head</span>(airquality), <span class="dt">caption =</span> <span class="st">&quot;New York Air Quality Measurements.&quot;</span>)</code></pre></div>
<table>
<caption>New York Air Quality Measurements.</caption>
<thead>
<tr class="header">
<th align="right">Ozone</th>
<th align="right">Solar.R</th>
<th align="right">Wind</th>
<th align="right">Temp</th>
<th align="right">Month</th>
<th align="right">Day</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="right">41</td>
<td align="right">190</td>
<td align="right">7.4</td>
<td align="right">67</td>
<td align="right">5</td>
<td align="right">1</td>
</tr>
<tr class="even">
<td align="right">36</td>
<td align="right">118</td>
<td align="right">8.0</td>
<td align="right">72</td>
<td align="right">5</td>
<td align="right">2</td>
</tr>
<tr class="odd">
<td align="right">12</td>
<td align="right">149</td>
<td align="right">12.6</td>
<td align="right">74</td>
<td align="right">5</td>
<td align="right">3</td>
</tr>
<tr class="even">
<td align="right">18</td>
<td align="right">313</td>
<td align="right">11.5</td>
<td align="right">62</td>
<td align="right">5</td>
<td align="right">4</td>
</tr>
<tr class="odd">
<td align="right">NA</td>
<td align="right">NA</td>
<td align="right">14.3</td>
<td align="right">56</td>
<td align="right">5</td>
<td align="right">5</td>
</tr>
<tr class="even">
<td align="right">28</td>
<td align="right">NA</td>
<td align="right">14.9</td>
<td align="right">66</td>
<td align="right">5</td>
<td align="right">6</td>
</tr>
</tbody>
</table>
<p>That’s it. Simply put this function definition somewhere in the top of your document and enjoy a quick workflow.</p>
</div>
</section>
