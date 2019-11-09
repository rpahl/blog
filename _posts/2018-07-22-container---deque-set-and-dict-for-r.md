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
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="kw">library</span>(container)</code></pre></div>
<pre><code>## 
## Attaching package: &#39;container&#39;</code></pre>
<pre><code>## The following object is masked from &#39;package:base&#39;:
## 
##     remove</code></pre>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">l &lt;-<span class="st"> </span><span class="kw">list</span>(<span class="dt">A1=</span><span class="dv">1</span><span class="op">:</span><span class="dv">3</span>, <span class="dt">L=</span>letters[<span class="dv">1</span><span class="op">:</span><span class="dv">3</span>])
<span class="kw">print</span>(l)</code></pre></div>
<pre><code>## $A1
## [1] 1 2 3
## 
## $L
## [1] &quot;a&quot; &quot;b&quot; &quot;c&quot;</code></pre>
<p>There are many ways to initialize a dict - one of them is passing a standard <code>list</code>. The <code>print</code> method provides compact output similar to <code>base::str</code>.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">d &lt;-<span class="st"> </span>Dict<span class="op">$</span><span class="kw">new</span>(l)
<span class="kw">print</span>(d) </code></pre></div>
<pre><code>## &lt;Dict&gt; of 2 elements: List of 2
##  $ A1: int [1:3] 1 2 3
##  $ L : chr [1:3] &quot;a&quot; &quot;b&quot; &quot;c&quot;</code></pre>
</div>
<div id="access-elements" class="section level4">
<h4>Access elements</h4>
<p>Accessing non-existing elements often gives unexpected results and can lead to nasty and hard-to-spot errors.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">sum &lt;-<span class="st"> </span>l[[<span class="st">&quot;A1&quot;</span>]] <span class="op">+</span><span class="st"> </span>l[[<span class="st">&quot;B1&quot;</span>]]
sum</code></pre></div>
<pre><code>## integer(0)</code></pre>
<p>The dict provides intended behaviour (in this case stops with an error).</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">sum &lt;-<span class="st"> </span>d<span class="op">$</span><span class="kw">get</span>(<span class="st">&quot;A1&quot;</span>) <span class="op">+</span><span class="st"> </span>d<span class="op">$</span><span class="kw">get</span>(<span class="st">&quot;B1&quot;</span>)</code></pre></div>
<pre><code>## Error in d$get(&quot;B1&quot;): key &#39;B1&#39; not in Dict</code></pre>
<p>Catching such cases manually is rather cumbersome.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">robust_sum &lt;-<span class="st"> </span>l[[<span class="st">&quot;A1&quot;</span>]] <span class="op">+</span><span class="st"> </span><span class="kw">ifelse</span>(<span class="st">&quot;B1&quot;</span> <span class="op">%in%</span><span class="st"> </span><span class="kw">names</span>(l), l[[<span class="st">&quot;B1&quot;</span>]], <span class="dv">0</span>)
robust_sum</code></pre></div>
<pre><code>## [1] 1 2 3</code></pre>
<p>The <code>peek</code> method returns the value only if it exists. The resulting code is not only shorter but also easier to read due to the intended behaviour being expressed more clearly.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">robust_sum &lt;-<span class="st"> </span>d<span class="op">$</span><span class="kw">get</span>(<span class="st">&quot;A1&quot;</span>) <span class="op">+</span><span class="st"> </span>d<span class="op">$</span><span class="kw">peek</span>(<span class="st">&quot;B1&quot;</span>, <span class="dt">default=</span><span class="dv">0</span>)
robust_sum</code></pre></div>
<pre><code>## [1] 1 2 3</code></pre>
</div>
<div id="set-elements" class="section level4">
<h4>Set elements</h4>
<p>A similar problem occurs when overwriting existing elements.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">l[[<span class="st">&quot;L&quot;</span>]] &lt;-<span class="st"> </span><span class="dv">0</span>  <span class="co"># letters are gone</span>
l</code></pre></div>
<pre><code>## $A1
## [1] 1 2 3
## 
## $L
## [1] 0</code></pre>
<p>The <code>add</code> method prevents any accidental overwrite.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">d<span class="op">$</span><span class="kw">add</span>(<span class="st">&quot;L&quot;</span>, <span class="dv">0</span>)</code></pre></div>
<pre><code>## Error in d$add(&quot;L&quot;, 0): key &#39;L&#39; already in Dict</code></pre>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="co"># If overwrite is intended, use &#39;set&#39;</span>
d<span class="op">$</span><span class="kw">set</span>(<span class="st">&quot;L&quot;</span>, <span class="dv">0</span>)
d</code></pre></div>
<pre><code>## &lt;Dict&gt; of 2 elements: List of 2
##  $ A1: int [1:3] 1 2 3
##  $ L : num 0</code></pre>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="co"># Setting non-existing elements also raises an error, unless adding is intended</span>
d<span class="op">$</span><span class="kw">set</span>(<span class="st">&quot;M&quot;</span>, <span class="dv">1</span>)</code></pre></div>
<pre><code>## Error in d$set(&quot;M&quot;, 1): key &#39;M&#39; not in Dict</code></pre>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">d<span class="op">$</span><span class="kw">set</span>(<span class="st">&quot;M&quot;</span>, <span class="dv">1</span>, <span class="dt">add=</span><span class="ot">TRUE</span>)  <span class="co"># alternatively: d$add(&quot;M&quot;, 1)</span></code></pre></div>
<p>Removing existing/non-existing elements can be controlled in a similar way. Again, see the package <a href="https://cran.r-project.org/web/packages/container/vignettes/overview.html">vignette</a> for more examples.</p>
</div>
<div id="reference-semantics" class="section level4">
<h4>Reference semantics</h4>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">d<span class="op">$</span><span class="kw">size</span>()</code></pre></div>
<pre><code>## [1] 3</code></pre>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">remove_from_dict_at &lt;-<span class="st"> </span><span class="cf">function</span>(d, x) d<span class="op">$</span><span class="kw">remove</span>(x) 
<span class="kw">remove_from_dict_at</span>(d, <span class="st">&quot;L&quot;</span>)
<span class="kw">remove_from_dict_at</span>(d, <span class="st">&quot;M&quot;</span>)
d<span class="op">$</span><span class="kw">size</span>()</code></pre></div>
<pre><code>## [1] 1</code></pre>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">backup &lt;-<span class="st"> </span>d<span class="op">$</span><span class="kw">clone</span>()
<span class="kw">remove_from_dict_at</span>(d, <span class="st">&quot;A1&quot;</span>)
d</code></pre></div>
<pre><code>## &lt;Dict&gt; of 0 elements:  Named list()</code></pre>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">backup</code></pre></div>
<pre><code>## &lt;Dict&gt; of 1 elements: List of 1
##  $ A1: int [1:3] 1 2 3</code></pre>
</div>
</div>
</section>
