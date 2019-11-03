---
title: "Readable code with base R (part 1)"


date: "July 30, 2018"
layout: post
---


<section class="main-content">
<p><img src="{{ site.url }}{{ site.baseurl }}\images\easy-read.png" width="60%" /></p>
<p>Producing readable R code is of great importance, especially if there is a chance that you will share your code with people other than your future self. The now widely used <a href="https://CRAN.R-project.org/package=magrittr">magrittr</a> pipe operator and <a href="https://CRAN.R-project.org/package=dplyr">dplyr</a> tools are great frameworks for this purpose.</p>
<p><em>However</em>, if you want to keep your dependencies on other packages at minimum, you may want to fall back to <em>base R</em>. In this series of blog posts, I will present some (maybe underused) <em>base R</em> tools for producing very readable R code.</p>
<p>In this post, we cover <code>startsWith</code>, <code>endsWith</code>, and <code>Filter</code>.</p>
<div id="startswith-and-endswith-for-string-matching" class="section level3">
<h3><code>startsWith</code> and <code>endsWith</code> for string-matching</h3>
<p>There are special base functions for pre- or postfix matching.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="co"># Basic usage:</span>
w &lt;-<span class="st"> &quot;Hello World!&quot;</span>
<span class="kw">startsWith</span>(w, <span class="st">&quot;Hell&quot;</span>)</code></pre></div>
<pre><code>## [1] TRUE</code></pre>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="kw">startsWith</span>(w, <span class="st">&quot;Helo&quot;</span>)</code></pre></div>
<pre><code>## [1] FALSE</code></pre>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="kw">endsWith</span>(w, <span class="st">&quot;!&quot;</span>)</code></pre></div>
<pre><code>## [1] TRUE</code></pre>
<p>Of course, it also works with vectors. Can’t remember the exact name of a base function? Try this… ;)</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">base_funcs &lt;-<span class="st"> </span><span class="kw">ls</span>(<span class="st">&quot;package:base&quot;</span>)

base_funcs[<span class="kw">startsWith</span>(base_funcs, <span class="st">&quot;row&quot;</span>)]</code></pre></div>
<pre><code>##  [1] &quot;row&quot;                    &quot;row.names&quot;             
##  [3] &quot;row.names.data.frame&quot;   &quot;row.names.default&quot;     
##  [5] &quot;row.names&lt;-&quot;            &quot;row.names&lt;-.data.frame&quot;
##  [7] &quot;row.names&lt;-.default&quot;    &quot;rowMeans&quot;              
##  [9] &quot;rownames&quot;               &quot;rownames&lt;-&quot;            
## [11] &quot;rowsum&quot;                 &quot;rowsum.data.frame&quot;     
## [13] &quot;rowsum.default&quot;         &quot;rowSums&quot;</code></pre>
<p>The ‘readable’ property really shines when combined with control-flow.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">tell_file_type &lt;-<span class="st"> </span><span class="cf">function</span>(fn) {
    <span class="co"># Check different file endings</span>
    <span class="cf">if</span> (<span class="kw">endsWith</span>(fn, <span class="st">&quot;txt&quot;</span>)) {
        <span class="kw">print</span>(<span class="st">&quot;A text file.&quot;</span>)
    }
    <span class="cf">if</span> (<span class="kw">any</span>(<span class="kw">endsWith</span>(fn, <span class="kw">c</span>(<span class="st">&quot;xlsx&quot;</span>, <span class="st">&quot;xls&quot;</span>)))) {
        <span class="kw">print</span>(<span class="st">&quot;An Excel file.&quot;</span>)
    }
}
<span class="kw">tell_file_type</span>(<span class="st">&quot;A.txt&quot;</span>)</code></pre></div>
<pre><code>## [1] &quot;A text file.&quot;</code></pre>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="kw">tell_file_type</span>(<span class="st">&quot;B.xls&quot;</span>)</code></pre></div>
<pre><code>## [1] &quot;An Excel file.&quot;</code></pre>
<p>The resulting code reads very well.</p>
</div>
<div id="filter" class="section level3">
<h3><code>Filter</code></h3>
<p>Using another nice base function, <code>Filter</code>, the above code can be further improved.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">get_file_type &lt;-<span class="st"> </span><span class="cf">function</span>(fn) {
  file_endings &lt;-<span class="st"> </span><span class="kw">c</span>(<span class="dt">text=</span><span class="st">&quot;txt&quot;</span>, <span class="dt">Excel=</span><span class="st">&quot;xls&quot;</span>, <span class="dt">Excel=</span><span class="st">&quot;xlsx&quot;</span>)  
  <span class="kw">Filter</span>(file_endings, <span class="dt">f =</span> <span class="cf">function</span>(x) <span class="kw">endsWith</span>(fn, x))
}

<span class="kw">get_file_type</span>(<span class="st">&quot;C.xlsx&quot;</span>)</code></pre></div>
<pre><code>##  Excel 
## &quot;xlsx&quot;</code></pre>
<p>Again, very readable to my eyes. It should be noted that for this particular problem using <code>tools::file_ext</code> is even more appropriate, but I think the point has been made.</p>
<p>Last but not least, since <code>Filter</code> works on lists, you can use it on a <code>data.frame</code> as well.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">dat &lt;-<span class="st"> </span><span class="kw">data.frame</span>(<span class="dt">A=</span><span class="dv">1</span><span class="op">:</span><span class="dv">3</span>, <span class="dt">B=</span><span class="dv">5</span><span class="op">:</span><span class="dv">3</span>, <span class="dt">L=</span>letters[<span class="dv">1</span><span class="op">:</span><span class="dv">3</span>])
dat</code></pre></div>
<pre><code>##   A B L
## 1 1 5 a
## 2 2 4 b
## 3 3 3 c</code></pre>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="kw">Filter</span>(dat, <span class="dt">f =</span> is.numeric)</code></pre></div>
<pre><code>##   A B
## 1 1 5
## 2 2 4
## 3 3 3</code></pre>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="kw">Filter</span>(dat, <span class="dt">f =</span> <span class="kw">Negate</span>(is.numeric))  <span class="co"># or Filter(dat, f = function(x) !is.numeric(x))</span></code></pre></div>
<pre><code>##   L
## 1 a
## 2 b
## 3 c</code></pre>
<p>That’s it for now - see you in part 2.</p>
</div>
</section>
