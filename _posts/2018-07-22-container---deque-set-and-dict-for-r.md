---
title: "container - deque, set and dict for R"


date: "July 22, 2018"
layout: post
---


<section class="main-content">
<p><img src="{{ site.url }}{{ site.baseurl }}\images\container.png" width="60%" /></p>
<p>Recently managed to put up my new package <a href="https://cran.r-project.org/web/packages/container/index.html">container</a> on CRAN (and finally have a compelling reason to start an R-blog …). This package provides some common container data structures deque, set and dict (resembling <a href="https://www.python.org/">Python</a>s dict type), with typical member functions to insert, delete and access container elements.</p>
<p>If you work with (especially bigger) R scripts, a specialized <code>container</code> may safe you some time and errors, for example, to avoid accidently overwriting existing list elements. Also, being based on <a href="https://CRAN.R-project.org/package=R6">R6</a>, all <code>container</code> objects provide reference semantics.</p>
<div id="example-dict-vs-list" class="section level3">
<h3>Example: dict vs list</h3>
<p>Here are a (very) few examples comparing the standard <code>list</code> with the <code>dict</code> container. For more examples see the <a href="https://cran.r-project.org/web/packages/container/vignettes/overview.html">vignette</a>.</p>
<div id="init-and-print" class="section level4">
<h4>Init and print</h4>
<div class="sourceCode" id="cb1"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb1-1" title="1"><span class="kw">library</span>(container)</a>
<a class="sourceLine" id="cb1-2" title="2"><span class="co">## </span></a>
<a class="sourceLine" id="cb1-3" title="3"><span class="co">## Attaching package: &#39;container&#39;</span></a>
<a class="sourceLine" id="cb1-4" title="4"><span class="co">## The following object is masked from &#39;package:base&#39;:</span></a>
<a class="sourceLine" id="cb1-5" title="5"><span class="co">## </span></a>
<a class="sourceLine" id="cb1-6" title="6"><span class="co">##     remove</span></a>
<a class="sourceLine" id="cb1-7" title="7">l &lt;-<span class="st"> </span><span class="kw">list</span>(<span class="dt">A1=</span><span class="dv">1</span><span class="op">:</span><span class="dv">3</span>, <span class="dt">L=</span>letters[<span class="dv">1</span><span class="op">:</span><span class="dv">3</span>])</a>
<a class="sourceLine" id="cb1-8" title="8"><span class="kw">print</span>(l)</a>
<a class="sourceLine" id="cb1-9" title="9"><span class="co">## $A1</span></a>
<a class="sourceLine" id="cb1-10" title="10"><span class="co">## [1] 1 2 3</span></a>
<a class="sourceLine" id="cb1-11" title="11"><span class="co">## </span></a>
<a class="sourceLine" id="cb1-12" title="12"><span class="co">## $L</span></a>
<a class="sourceLine" id="cb1-13" title="13"><span class="co">## [1] &quot;a&quot; &quot;b&quot; &quot;c&quot;</span></a></code></pre></div>
<p>There are many ways to initialize a dict - one of them is passing a standard <code>list</code>. The <code>print</code> method provides compact output similar to <code>base::str</code>.</p>
<div class="sourceCode" id="cb2"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb2-1" title="1">d &lt;-<span class="st"> </span>Dict<span class="op">$</span><span class="kw">new</span>(l)</a>
<a class="sourceLine" id="cb2-2" title="2"><span class="kw">print</span>(d) </a>
<a class="sourceLine" id="cb2-3" title="3"><span class="co">## &lt;Dict&gt; of 2 elements: List of 2</span></a>
<a class="sourceLine" id="cb2-4" title="4"><span class="co">##  $ A1: int [1:3] 1 2 3</span></a>
<a class="sourceLine" id="cb2-5" title="5"><span class="co">##  $ L : chr [1:3] &quot;a&quot; &quot;b&quot; &quot;c&quot;</span></a></code></pre></div>
</div>
<div id="access-elements" class="section level4">
<h4>Access elements</h4>
<p>Accessing non-existing elements often gives unexpected results and can lead to nasty and hard-to-spot errors.</p>
<div class="sourceCode" id="cb3"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb3-1" title="1">sum &lt;-<span class="st"> </span>l[[<span class="st">&quot;A1&quot;</span>]] <span class="op">+</span><span class="st"> </span>l[[<span class="st">&quot;B1&quot;</span>]]</a>
<a class="sourceLine" id="cb3-2" title="2">sum</a>
<a class="sourceLine" id="cb3-3" title="3"><span class="co">## integer(0)</span></a></code></pre></div>
<p>The dict provides intended behaviour (in this case stops with an error).</p>
<div class="sourceCode" id="cb4"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb4-1" title="1">sum &lt;-<span class="st"> </span>d<span class="op">$</span><span class="kw">get</span>(<span class="st">&quot;A1&quot;</span>) <span class="op">+</span><span class="st"> </span>d<span class="op">$</span><span class="kw">get</span>(<span class="st">&quot;B1&quot;</span>)</a>
<a class="sourceLine" id="cb4-2" title="2"><span class="co">## Error in d$get(&quot;B1&quot;): key &#39;B1&#39; not in Dict</span></a></code></pre></div>
<p>Catching such cases manually is rather cumbersome.</p>
<div class="sourceCode" id="cb5"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb5-1" title="1">robust_sum &lt;-<span class="st"> </span>l[[<span class="st">&quot;A1&quot;</span>]] <span class="op">+</span><span class="st"> </span><span class="kw">ifelse</span>(<span class="st">&quot;B1&quot;</span> <span class="op">%in%</span><span class="st"> </span><span class="kw">names</span>(l), l[[<span class="st">&quot;B1&quot;</span>]], <span class="dv">0</span>)</a>
<a class="sourceLine" id="cb5-2" title="2">robust_sum</a>
<a class="sourceLine" id="cb5-3" title="3"><span class="co">## [1] 1 2 3</span></a></code></pre></div>
<p>The <code>peek</code> method returns the value only if it exists. The resulting code is not only shorter but also easier to read due to the intended behaviour being expressed more clearly.</p>
<div class="sourceCode" id="cb6"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb6-1" title="1">robust_sum &lt;-<span class="st"> </span>d<span class="op">$</span><span class="kw">get</span>(<span class="st">&quot;A1&quot;</span>) <span class="op">+</span><span class="st"> </span>d<span class="op">$</span><span class="kw">peek</span>(<span class="st">&quot;B1&quot;</span>, <span class="dt">default=</span><span class="dv">0</span>)</a>
<a class="sourceLine" id="cb6-2" title="2">robust_sum</a>
<a class="sourceLine" id="cb6-3" title="3"><span class="co">## [1] 1 2 3</span></a></code></pre></div>
</div>
<div id="set-elements" class="section level4">
<h4>Set elements</h4>
<p>A similar problem occurs when overwriting existing elements.</p>
<div class="sourceCode" id="cb7"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb7-1" title="1">l[[<span class="st">&quot;L&quot;</span>]] &lt;-<span class="st"> </span><span class="dv">0</span>  <span class="co"># letters are gone</span></a>
<a class="sourceLine" id="cb7-2" title="2">l</a>
<a class="sourceLine" id="cb7-3" title="3"><span class="co">## $A1</span></a>
<a class="sourceLine" id="cb7-4" title="4"><span class="co">## [1] 1 2 3</span></a>
<a class="sourceLine" id="cb7-5" title="5"><span class="co">## </span></a>
<a class="sourceLine" id="cb7-6" title="6"><span class="co">## $L</span></a>
<a class="sourceLine" id="cb7-7" title="7"><span class="co">## [1] 0</span></a></code></pre></div>
<p>The <code>add</code> method prevents any accidental overwrite.</p>
<div class="sourceCode" id="cb8"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb8-1" title="1">d<span class="op">$</span><span class="kw">add</span>(<span class="st">&quot;L&quot;</span>, <span class="dv">0</span>)</a>
<a class="sourceLine" id="cb8-2" title="2"><span class="co">## Error in d$add(&quot;L&quot;, 0): key &#39;L&#39; already in Dict</span></a>
<a class="sourceLine" id="cb8-3" title="3"></a>
<a class="sourceLine" id="cb8-4" title="4"><span class="co"># If overwrite is intended, use &#39;set&#39;</span></a>
<a class="sourceLine" id="cb8-5" title="5">d<span class="op">$</span><span class="kw">set</span>(<span class="st">&quot;L&quot;</span>, <span class="dv">0</span>)</a>
<a class="sourceLine" id="cb8-6" title="6">d</a>
<a class="sourceLine" id="cb8-7" title="7"><span class="co">## &lt;Dict&gt; of 2 elements: List of 2</span></a>
<a class="sourceLine" id="cb8-8" title="8"><span class="co">##  $ A1: int [1:3] 1 2 3</span></a>
<a class="sourceLine" id="cb8-9" title="9"><span class="co">##  $ L : num 0</span></a>
<a class="sourceLine" id="cb8-10" title="10"></a>
<a class="sourceLine" id="cb8-11" title="11"><span class="co"># Setting non-existing elements also raises an error, unless adding is intended</span></a>
<a class="sourceLine" id="cb8-12" title="12">d<span class="op">$</span><span class="kw">set</span>(<span class="st">&quot;M&quot;</span>, <span class="dv">1</span>)</a>
<a class="sourceLine" id="cb8-13" title="13"><span class="co">## Error in d$set(&quot;M&quot;, 1): key &#39;M&#39; not in Dict</span></a>
<a class="sourceLine" id="cb8-14" title="14">d<span class="op">$</span><span class="kw">set</span>(<span class="st">&quot;M&quot;</span>, <span class="dv">1</span>, <span class="dt">add=</span><span class="ot">TRUE</span>)  <span class="co"># alternatively: d$add(&quot;M&quot;, 1)</span></a></code></pre></div>
<p>Removing existing/non-existing elements can be controlled in a similar way. Again, see the package <a href="https://cran.r-project.org/web/packages/container/vignettes/overview.html">vignette</a> for more examples.</p>
</div>
<div id="reference-semantics" class="section level4">
<h4>Reference semantics</h4>
<div class="sourceCode" id="cb9"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb9-1" title="1">d<span class="op">$</span><span class="kw">size</span>()</a>
<a class="sourceLine" id="cb9-2" title="2"><span class="co">## [1] 3</span></a>
<a class="sourceLine" id="cb9-3" title="3">remove_from_dict_at &lt;-<span class="st"> </span><span class="cf">function</span>(d, x) d<span class="op">$</span><span class="kw">remove</span>(x) </a>
<a class="sourceLine" id="cb9-4" title="4"><span class="kw">remove_from_dict_at</span>(d, <span class="st">&quot;L&quot;</span>)</a>
<a class="sourceLine" id="cb9-5" title="5"><span class="kw">remove_from_dict_at</span>(d, <span class="st">&quot;M&quot;</span>)</a>
<a class="sourceLine" id="cb9-6" title="6">d<span class="op">$</span><span class="kw">size</span>()</a>
<a class="sourceLine" id="cb9-7" title="7"><span class="co">## [1] 1</span></a>
<a class="sourceLine" id="cb9-8" title="8"></a>
<a class="sourceLine" id="cb9-9" title="9">backup &lt;-<span class="st"> </span>d<span class="op">$</span><span class="kw">clone</span>()</a>
<a class="sourceLine" id="cb9-10" title="10"><span class="kw">remove_from_dict_at</span>(d, <span class="st">&quot;A1&quot;</span>)</a>
<a class="sourceLine" id="cb9-11" title="11">d</a>
<a class="sourceLine" id="cb9-12" title="12"><span class="co">## &lt;Dict&gt; of 0 elements:  Named list()</span></a>
<a class="sourceLine" id="cb9-13" title="13">backup</a>
<a class="sourceLine" id="cb9-14" title="14"><span class="co">## &lt;Dict&gt; of 1 elements: List of 1</span></a>
<a class="sourceLine" id="cb9-15" title="15"><span class="co">##  $ A1: int [1:3] 1 2 3</span></a></code></pre></div>
</div>
</div>
</section>
