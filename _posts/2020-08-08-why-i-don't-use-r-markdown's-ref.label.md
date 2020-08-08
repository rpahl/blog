---
title: "Why I don't use R Markdown's ref.label"


date: "August 08, 2020"
layout: post
---


<section class="main-content">
<div id="outline" class="section level2">
<h2>Outline</h2>
<p>R Markdown provides the chunk option <code>ref.label</code> to <a href="https://yihui.org/knitr/demo/reference/">reuse chunks</a>.</p>
<p>In this post, I’ll show <em>potential problems</em> with this approach and present an <em>easy and safe alternative</em>. If you don’t bother with the detailed <a href="#explanation">Explanation</a>, feel free to jump right to the <a href="#summary">Summary</a> section.</p>
</div>
<div id="explanation" class="section level2">
<h2>Explanation</h2>
<p>Consider you have defined variable <code>x</code>,</p>
<div class="sourceCode" id="cb1"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb1-1" title="1">x =<span class="st"> </span><span class="dv">1</span></a></code></pre></div>
<p>and define another chunk, where you simply add one up</p>
<pre><code>```{r addOne}
sum = x + 1
sum
```</code></pre>
<p>resulting in:</p>
<pre><code>## [1] 2</code></pre>
<p>To reuse this chunk, an empty code block is created referencing the above chunk.</p>
<pre><code>```{r, ref.label = &#39;addOne&#39;}
```</code></pre>
<p>again resulting in:</p>
<pre><code>## [1] 2</code></pre>
<p>Behind the scenes, the chunk basically was copy-pasted and then executed again. One problem is that one can easily lose track of the scope of the variables used in that chunk. For example, let’s assume you use the <code>sum</code> variable further below in your document to store some other result:</p>
<div class="sourceCode" id="cb6"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb6-1" title="1">sum =<span class="st"> </span><span class="dv">10</span></a></code></pre></div>
<p>If you now again reuse the above chunk</p>
<pre><code>```{r, ref.label = &#39;addOne&#39;}
```</code></pre>
<pre><code>## [1] 2</code></pre>
<p><code>sum</code> has been overwritten by the chunk:</p>
<div class="sourceCode" id="cb9"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb9-1" title="1"><span class="kw">print</span>(sum)  <span class="co"># expect sum == 10</span></a></code></pre></div>
<pre><code>## [1] 2</code></pre>
<p>Since the <code>ref.label</code> chunk is empty, this issue might not be easily spotted.</p>
<p>Another inconvenience arrises with <a href="https://rstudio.com/">RStudio</a>’s notebook functionality to execute individual code chunks. While the original chunk can be executed, none of the empty <code>ref.label</code> chunks can. Funnily enough, this inconvenience was what made me think about an alternative solution.</p>
</div>
<div id="alternative-solution" class="section level2">
<h2>Alternative solution</h2>
<p>Luckily, the solution is quite simple - put your entire chunk inside a function and then “reference” the function:</p>
<div class="sourceCode" id="cb11"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb11-1" title="1">add1 &lt;-<span class="st"> </span><span class="cf">function</span>(x) {</a>
<a class="sourceLine" id="cb11-2" title="2">    sum =<span class="st"> </span>x <span class="op">+</span><span class="st"> </span><span class="dv">1</span></a>
<a class="sourceLine" id="cb11-3" title="3">    sum</a>
<a class="sourceLine" id="cb11-4" title="4">}</a></code></pre></div>
<div class="sourceCode" id="cb12"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb12-1" title="1"><span class="kw">add1</span>(x)</a></code></pre></div>
<pre><code>## [1] 2</code></pre>
<p>Now both the <code>sum</code> variable is perfectly scoped and the “referenced” call can be executed in the RStudio notebook as usual. Plus, of course, this “chunk” could be easily parametrized:</p>
<div class="sourceCode" id="cb14"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb14-1" title="1">addY &lt;-<span class="st"> </span><span class="cf">function</span>(x, y) {</a>
<a class="sourceLine" id="cb14-2" title="2">    sum =<span class="st"> </span>x <span class="op">+</span><span class="st"> </span>y</a>
<a class="sourceLine" id="cb14-3" title="3">    sum</a>
<a class="sourceLine" id="cb14-4" title="4">}</a>
<a class="sourceLine" id="cb14-5" title="5"><span class="kw">addY</span>(x, <span class="dt">y =</span> <span class="dv">1</span>)</a></code></pre></div>
<pre><code>## [1] 2</code></pre>
</div>
<div id="summary" class="section level2">
<h2>Summary</h2>
<p>Downsides of using <code>ref.label</code>:</p>
<ul>
<li>potential issues with (global) variables as chunk does <em>not</em> provide local scoping</li>
<li><code>ref.label</code> chunks are empty and therefore cannot be executed in RStudio notebooks</li>
</ul>
<p>Proposed solution: encapsulate entire chunk inside a function and then execute the function wherever you would reference the chunk.</p>
</div>
</section>
