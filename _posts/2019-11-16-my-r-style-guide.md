---
title: "My R Style Guide"


date: "November 16, 2019"
layout: post
---


<section class="main-content">
<p>This is my take on an R style guide. As such, this is going to be a very long post (long enough to warrant a table of content). Still, I hope it - or at least some parts of it - are useful to some people out there. Another guide worth mentioning is the <a href="https://style.tidyverse.org/">Tidyverse Style Guide</a> by Hadley Wickham.</p>
<p><img src="{{ site.url }}{{ site.baseurl }}\images\style.png" width="20%" /></p>
<p>So without further ado, let’s dive into the guide.</p>
<div id="table-of-content" class="section level1">
<h1>Table of Content</h1>
<p>Below a rough overview of the content. The sections can be read in any order so feel free to jump to any topic you like.</p>
<ul>
<li><a href="#intro">Introduction and purpose</a></li>
<li><a href="#style">Coding style</a>
<ul>
<li><a href="#notation">Notation and naming</a></li>
<li><a href="#syntax">Syntax</a></li>
<li><a href="#organisation">Code organisation</a></li>
</ul></li>
<li><a href="#docu">Code documentation</a></li>
</ul>
</div>
<div id="intro" class="section level1">
<h1>Introduction and purpose</h1>
<p>There are universal views about readability due to the way how humans process information or text. For example, consider the following number written in two ways:</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="dv">823969346</span>
<span class="dv">823</span> <span class="dv">969</span> <span class="dv">346</span></code></pre></div>
<p>Certainly the second version, which splits the sequence into groups of numbers, is easier to process by humans, implying that spacing is important especially if abstract information is presented.</p>
<p>The style guide at hand provides a set of rules designed to achieve readable and maintainable R code. Still, of course, it represents a subjective view (of the author) on how to achieve these goals and does not raise any claims of being complete. Thus, if there are viable alternatives to the presented rules or if they are against the intuition of the user, possibly even resulting in hard-to-read code, it is better to deviate from the rules rather than blindly following them.</p>
</div>
<div id="style" class="section level1">
<h1>Coding style</h1>
<div id="notation" class="section level2">
<h2>Notation and naming</h2>
<div id="file-names" class="section level3">
<h3>File names</h3>
<p>File names end in .R and are meaningful about their content:</p>
<p><strong>Good:</strong></p>
<ul>
<li>string-algorithms.R</li>
<li>utility-functions.R</li>
</ul>
<p><strong>Bad:</strong></p>
<ul>
<li>foo.R</li>
<li>foo.Rcode</li>
<li>stuff.R</li>
</ul>
</div>
<div id="function-names" class="section level3">
<h3>Function names</h3>
<p>Preferrably function names consist of lowercase words separated by an underscore. Using dot (.) separator is avoided as this confuses with the use of generic (<a href="http://adv-r.had.co.nz/S3.html">S3</a>) functions. It also prevents name clashes with existing functions from the standard R packages. Camel-case style is also suitable especially for predicate functions returning a boolean value. Function names ideally start with <em>verbs</em> and describe what the function does.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="co"># GOOD</span>
<span class="kw">create_summary</span>()
<span class="kw">calculate_avg_clicks</span>()
<span class="kw">find_string</span>()
<span class="kw">isOdd</span>()

<span class="co"># BAD</span>
<span class="kw">crt_smmry</span>()
<span class="kw">find.string</span>()
<span class="kw">foo</span>()</code></pre></div>
</div>
<div id="variable-names" class="section level3">
<h3>Variable names</h3>
<p>Variable names consist of lowercase words separated by an underscore or dot. Camel-case style is also suitable especially for variables representing boolean values. Variable names ideally are attributed <em>nouns</em> and describe what (state) they store.</p>
<p><strong>Good:</strong></p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">summary_tab
selected_timeframe
out.table
hasConverged</code></pre></div>
<p><strong>Bad:</strong></p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">smrytab
selTF
outtab
hascnvrgd</code></pre></div>
<p>Name clashes with existing R base functions are avoided:</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="co"># Very bad:</span>
T &lt;-<span class="st"> </span><span class="ot">FALSE</span>
c &lt;-<span class="st"> </span><span class="dv">10</span>
mean &lt;-<span class="st"> </span><span class="cf">function</span>(a, b) (a <span class="op">+</span><span class="st"> </span>b) <span class="op">/</span><span class="st"> </span><span class="dv">2</span>
file.path &lt;-<span class="st"> &quot;~/Downloads&quot;</span> <span class="co"># clashes with base::file.path function</span></code></pre></div>
<p>Loop variables or function arguments can be just single letters if</p>
<ul>
<li>the naming follows standard conventions</li>
<li>their meaning is clear</li>
<li>understanding is preserved</li>
</ul>
<p>otherwise use longer variable names.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="co"># GOOD</span>
<span class="cf">for</span> (i <span class="cf">in</span> <span class="dv">1</span><span class="op">:</span><span class="dv">10</span>) <span class="kw">print</span>(i)
add &lt;-<span class="st"> </span><span class="cf">function</span>(a, b) a <span class="op">+</span><span class="st"> </span>b
rnorm &lt;-<span class="st"> </span><span class="cf">function</span>(n, <span class="dt">mean =</span> <span class="dv">0</span>, <span class="dt">sd =</span> <span class="dv">1</span>)

<span class="co"># BAD</span>
<span class="cf">for</span> (unnecessary_long_variable_name <span class="cf">in</span> <span class="dv">1</span><span class="op">:</span><span class="dv">10</span>) <span class="kw">print</span>(unnecessary_long_variable_name)
add &lt;-<span class="st"> </span><span class="cf">function</span>(a1, x7) a1 <span class="op">+</span><span class="st"> </span>x7
rnorm &lt;-<span class="st"> </span><span class="cf">function</span>(m, <span class="dt">n =</span> <span class="dv">0</span>, <span class="dt">o =</span> <span class="dv">1</span>)</code></pre></div>
</div>
<div id="function-definitions" class="section level3">
<h3>Function definitions</h3>
<p>Function definitions first list arguments without default values, followed by those with default values. In both function definitions and function calls, multiple arguments per line are allowed; line breaks are only allowed between assignments.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="co"># GOOD</span>
rnorm &lt;-<span class="st"> </span><span class="cf">function</span>(n, <span class="dt">mean=</span><span class="dv">0</span>, <span class="dt">sd=</span><span class="dv">1</span>)
pnorm &lt;-<span class="st"> </span><span class="cf">function</span>(q, <span class="dt">mean=</span><span class="dv">0</span>, <span class="dt">sd=</span><span class="dv">1</span>, 
                  <span class="dt">lower.tail=</span><span class="ot">TRUE</span>, <span class="dt">log.p=</span><span class="ot">FALSE</span>)

<span class="co"># BAD</span>
mean &lt;-<span class="st"> </span><span class="cf">function</span>(<span class="dt">mean=</span><span class="dv">0</span>, <span class="dt">sd=</span><span class="dv">1</span>, n)           <span class="co"># n should be listed first</span>
pnorm &lt;-<span class="st"> </span><span class="cf">function</span>(q, <span class="dt">mean=</span><span class="dv">0</span>, <span class="dt">sd=</span><span class="dv">1</span>, <span class="dt">lower.tail=</span>
                  <span class="ot">TRUE</span>, <span class="dt">log.p=</span><span class="ot">FALSE</span>)</code></pre></div>
</div>
<div id="function-calls" class="section level3">
<h3>Function calls</h3>
<p>When calling a function, the meaning of the function call and arguments should be clear from the call, that is, usually function arguments beyond the first are explicitly named or at least invoked with a meaningful variable name, for example, identical to the name of the function argument:</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="co"># GOOD</span>
<span class="kw">rnorm</span>(<span class="dv">100</span>, <span class="dt">mean=</span><span class="dv">1</span>, <span class="dt">sd=</span><span class="dv">2</span>)
<span class="kw">identical</span>(<span class="dv">1</span>, <span class="fl">1.0</span>)   <span class="co"># no need for explicit naming as meaning of call is clear</span>

mean &lt;-<span class="st"> </span><span class="dv">1</span>
sd &lt;-<span class="st"> </span><span class="dv">2</span>
std.dev &lt;-<span class="st"> </span>sd
<span class="kw">rnorm</span>(<span class="dv">100</span>, mean, sd)
<span class="kw">rnorm</span>(<span class="dv">100</span>, mean, std.dev)

<span class="co"># BAD</span>
<span class="kw">rnorm</span>(<span class="dv">100</span>, <span class="dv">1</span>, <span class="dv">2</span>)</code></pre></div>
</div>
</div>
<div id="syntax" class="section level2">
<h2>Syntax</h2>
<div id="assignment" class="section level3">
<h3>Assignment</h3>
<p>For any assignment, the arrow <code>&lt;-</code> is preferable over the equal sign <code>=</code>.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">x &lt;-<span class="st"> </span><span class="dv">5</span>  <span class="co"># GOOD</span>
x  =<span class="st"> </span><span class="dv">5</span>  <span class="co"># OK</span></code></pre></div>
<p>Semicolons are <strong>never</strong> used.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="co"># BAD</span>
x &lt;-<span class="st"> </span><span class="dv">5</span>; y &lt;-<span class="st"> </span><span class="dv">10</span>; z &lt;-<span class="st"> </span><span class="dv">3</span>  <span class="co"># break into three lines instead</span></code></pre></div>
</div>
<div id="spacing-around" class="section level3">
<h3>Spacing around …</h3>
<div id="commas" class="section level4">
<h4>… commas</h4>
<p>Place a space after a comma but never before (as in regular English)</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="co"># GOOD</span>
v &lt;-<span class="st"> </span><span class="kw">c</span>(<span class="dv">1</span>, <span class="dv">2</span>, <span class="dv">3</span>)
m[<span class="dv">1</span>, <span class="dv">2</span>]

<span class="co"># BAD</span>
v &lt;-<span class="st"> </span><span class="kw">c</span>(<span class="dv">1</span>,<span class="dv">2</span>,<span class="dv">3</span>)
m[<span class="dv">1</span> ,<span class="dv">2</span>]</code></pre></div>
</div>
<div id="operators" class="section level4">
<h4>… operators</h4>
<p>Spaces around infix operators (<code>=</code>, <code>+</code>, <code>-</code>, <code>&lt;-</code>, etc.) should be done in a way that supports readability, for example, by placing spaces between semantically connected groups. If in doubt, rather use more spaces, except with colons <code>:</code>, which usually should <strong>not</strong> be surrounded by spaces.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="co"># GOOD</span>
<span class="co"># Spacing according to semantically connected groups</span>
x &lt;-<span class="st"> </span><span class="dv">1</span><span class="op">:</span><span class="dv">10</span>
base<span class="op">::</span>get
average &lt;-<span class="st"> </span><span class="kw">mean</span>(feet<span class="op">/</span><span class="dv">12</span> <span class="op">+</span><span class="st"> </span>inches, <span class="dt">na.rm=</span><span class="ot">TRUE</span>)

<span class="co"># Using more spaces - also ok</span>
average &lt;-<span class="st"> </span><span class="kw">mean</span>(feet <span class="op">/</span><span class="st"> </span><span class="dv">12</span> <span class="op">+</span><span class="st"> </span>inches, <span class="dt">na.rm =</span> <span class="ot">TRUE</span>)</code></pre></div>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="co"># BAD</span>
x &lt;-<span class="st"> </span><span class="dv">1</span> <span class="op">:</span><span class="st"> </span><span class="dv">10</span>
base <span class="op">::</span><span class="st"> </span>get
average&lt;-<span class="kw">mean</span>(feet<span class="op">/</span><span class="dv">12</span><span class="op">+</span>inches,<span class="dt">na.rm=</span><span class="ot">TRUE</span>)</code></pre></div>
</div>
<div id="parentheses" class="section level4">
<h4>… parentheses</h4>
<p>A space is placed before left parentheses, except in a function call, and after right parentheses. Arithmetic expressions form a special case, in which spaces can be omitted.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="co"># GOOD</span>
<span class="cf">if</span> (debug) <span class="kw">print</span>(x)
<span class="kw">plot</span>(x, y)

<span class="co"># Special case arithmetic expression:</span>
<span class="dv">2</span> <span class="op">+</span><span class="st"> </span>(a<span class="op">+</span>b)<span class="op">/</span>(c<span class="op">+</span>d) <span class="op">+</span><span class="st"> </span>z<span class="op">/</span>(<span class="dv">1</span><span class="op">+</span>a)

<span class="co"># BAD</span>
<span class="cf">if</span>(debug)<span class="kw">print</span> (x)
<span class="kw">plot</span> (x, y)</code></pre></div>
<p>No spaces are placed around code in parentheses or square brackets, unless there is a comma:</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="co"># GOOD</span>
<span class="cf">if</span> (debug) <span class="kw">print</span>(x)
diamonds[<span class="dv">3</span>, ]
diamonds[, <span class="dv">4</span>]

<span class="co"># BAD</span>
<span class="cf">if</span> ( debug ) <span class="kw">print</span>( x )
diamonds[ ,<span class="dv">4</span>]</code></pre></div>
</div>
<div id="curly-braces" class="section level4">
<h4>… curly braces</h4>
<p>An opening curly brace is followed by a new line. A closing curly brace goes on its own line.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="co"># GOOD</span>
<span class="cf">for</span> (x <span class="cf">in</span> letters[<span class="dv">1</span><span class="op">:</span><span class="dv">10</span>]) {
    <span class="kw">print</span>(x)
}

add &lt;-<span class="st"> </span><span class="cf">function</span>(x, y) {
    x <span class="op">+</span><span class="st"> </span>y
}

add &lt;-<span class="st"> </span><span class="cf">function</span>(x, y)
{
    x <span class="op">+</span><span class="st"> </span>y
}

<span class="co"># BAD</span>
add &lt;-<span class="st"> </span><span class="cf">function</span>(x, y) {x <span class="op">+</span><span class="st"> </span>y}</code></pre></div>
</div>
</div>
<div id="indentation" class="section level3">
<h3>Indentation</h3>
<p>Code is indented with <em>ideally four</em>, but <em>at least two</em> spaces. Usually using four spaces provides better readability than two spaces especially the longer the indented code-block gets.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="co"># Four-space indent:</span>
<span class="cf">for</span> (i <span class="cf">in</span> <span class="kw">seq_len</span>(<span class="dv">10</span>)) {
    <span class="cf">if</span> (i <span class="op">%%</span><span class="st"> </span><span class="dv">2</span> <span class="op">==</span><span class="st"> </span><span class="dv">0</span>) {
        <span class="kw">print</span>(<span class="st">&quot;even&quot;</span>)
    } <span class="cf">else</span> {
        <span class="kw">print</span>(<span class="st">&quot;odd&quot;</span>)
    }
}

<span class="co"># The same code-block using two-space indent:</span>
<span class="cf">for</span> (i <span class="cf">in</span> <span class="kw">seq_len</span>(<span class="dv">10</span>)) {
  <span class="cf">if</span> (i <span class="op">%%</span><span class="st"> </span><span class="dv">2</span> <span class="op">==</span><span class="st"> </span><span class="dv">0</span>) {
    <span class="kw">print</span>(<span class="st">&quot;even&quot;</span>)
  } <span class="cf">else</span> {
    <span class="kw">print</span>(<span class="st">&quot;odd&quot;</span>)
  }
}</code></pre></div>
<p>Extended indendation: when a line break occurs inside parentheses, align the wrapped line with the first character inside the parenthesis:</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">fibonacci &lt;-<span class="st"> </span><span class="kw">c</span>(<span class="dv">1</span>, <span class="dv">1</span>, <span class="dv">2</span>, <span class="dv">3</span>, <span class="dv">5</span>,
               <span class="dv">8</span>, <span class="dv">13</span>, <span class="dv">21</span>, <span class="dv">34</span>)</code></pre></div>
</div>
</div>
<div id="organization" class="section level2">
<h2>Code organization</h2>
<p>As with a good syntax style, the main goal of good code organization is to provide good readability and understanding of the code, especially for external readers/reviewers. While the following guidelines generally have proven to be effective for this purpose, they harm things if applied the wrong way or in isolation. For example, if the user wants to restricts himself to 50 lines of code for each block (see below), but, instead of proper code-reorganization, achieves this by just deleting all comments in the code block, things probably have gotten worse. Thus, <em>any (re-)organization of code first and foremost must serve the improvement of the readability and understanding of the code</em>, ideally implemented by the guidelines given in this section.</p>
<div id="line-length" class="section level3">
<h3>Line length</h3>
<p>Ideally, the code does <strong>not</strong> exceed <em>80 characters per line</em>. This fits comfortably on a printed page with a reasonably sized font and therefore can be easily processed by a human, which tend to read line by line. Longer comments are simply broken into several lines:</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="co"># Here is an example of a longer comment, which is just broken into two lines</span>
<span class="co"># in order to serve the 80 character rule.</span></code></pre></div>
<p>Long variable names can cause problems regarding the 80 characters limit. In such cases, one simple yet effective solution is to use interim results, which are saved in a new meaningful variable name. This at the same time often improves the readability of the code. For example:</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="co"># Longer statement</span>
total.cost &lt;-<span class="st"> </span>hotel.cost <span class="op">+</span><span class="st"> </span>cost.taxi <span class="op">+</span><span class="st"> </span>cost.lunch <span class="op">+</span><span class="st"> </span>cost.airplane <span class="op">+</span>
<span class="st">    </span>cost.breakfast <span class="op">+</span><span class="st"> </span>cost.dinner <span class="op">+</span><span class="st"> </span>cost.car_rental

<span class="co"># Solution with interim result</span>
travel.cost &lt;-<span class="st"> </span>cost.taxi <span class="op">+</span><span class="st"> </span>cost.airplane <span class="op">+</span><span class="st"> </span>cost.car_rental
food.cost &lt;-<span class="st"> </span>cost.breakfast <span class="op">+</span><span class="st"> </span>cost.lunch <span class="op">+</span><span class="st"> </span>cost.dinner
total.cost &lt;-<span class="st"> </span>travel.cost <span class="op">+</span><span class="st"> </span>food.cost <span class="op">+</span><span class="st"> </span>hotel.cost</code></pre></div>
<p>Similarly, four-space indenting in combination with multiple nested code-blocks can cause problems to maintain the 80 character limit and may require to relax this rule in such cases. At the same time, however, multiple nested code-blocks should be avoided in the first place, because with more nesting the code usually gets harder to understand.</p>
</div>
<div id="block-length" class="section level3">
<h3>Block length</h3>
<p>Each functionally connected block of code (usually a function block) should <strong>not</strong> exceed a single screen (about 50 lines of code). This allows the code to be read and understood without having to line-scroll. Exceeding this limit usually is a good indication that some of the code should be encapsulated (refactorized) into a separate unit or function. Doing so, not only improves the readability of the code but also flexibilizes (and thereby simplifies) further code development. In particular, single blocks that are separated by comments, often can be refactorized into functions, named similar to the comment, for example:</p>
<p><strong>Long single-block version:</strong></p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="co"># Sub-block 1: simulate data for some model</span>
x &lt;-<span class="st"> </span><span class="dv">1</span><span class="op">:</span><span class="dv">100</span>
y &lt;-<span class="st"> </span><span class="kw">rnorm</span>(<span class="kw">length</span>(x))
.
.
.
longer code block generating some data
.
.
.
data &lt;-<span class="st"> </span>...

<span class="co"># Sub-block 2: plot the resulting data points</span>
ylims &lt;-<span class="st"> </span><span class="kw">c</span>(<span class="dv">0</span>, <span class="dv">30</span>)
p &lt;-<span class="st"> </span><span class="kw">ggplot</span>(data) <span class="op">+</span>
.
.
.
longer code block defining plot object
.
.
.

<span class="co"># Sub-block 3: format results and export to Excel file</span>
outFile &lt;-<span class="st"> &quot;output.xlsx&quot;</span>
.
.
export to Excel file
.
.</code></pre></div>
<p>The singe-block version may exceed a single page and requires a lot of comments just to separate each step visually, but even with this visual separation, it will be unnecessary difficult for a second person to understand the code, because allthough the code might be entirely sequential, he possibly will end up jumping back and forth within the block to get an understanding of it. In addition, if parts of the block are changed at a later time point, the code can easily get out of sync with the comments.</p>
<p><strong>Refactorized version:</strong></p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="co"># Simulate data, plot it and export it to Excel file</span>
data.sim &lt;-<span class="st"> </span><span class="kw">simulate_data</span>(<span class="dt">x =</span> <span class="dv">1</span><span class="op">:</span><span class="dv">100</span>, <span class="dt">y =</span> <span class="kw">rnorm</span>(<span class="kw">length</span>(x)), ...)
<span class="kw">plot_simulated_data</span>(data.sim, <span class="dt">ylims =</span> <span class="kw">c</span>(<span class="dv">0</span>, <span class="dv">30</span>), ...)
<span class="kw">write_results_into_table</span>(data.sim, <span class="dt">outFile=</span><span class="st">&quot;output.xlsx&quot;</span>)</code></pre></div>
<p>In the refactorized version each sub-block was put into a separate function (not shown), which is now called in place. In contrast to the single-block version, each of these functions can be re-used, tested and have their own documentation. Since each of such functions encapsulate their own environment, the second (refactorized) design is also less vulnerable to side-effects between blocks. A second person can now read and understand function by function without having to worry about the rest of the block.</p>
<p>Last but not least, the block comments in the single-block versions could be transformed into function names so that the documentation is now part of the code and as such no longer can get out of sync with it.</p>
</div>
<div id="packages-and-namespaces" class="section level3">
<h3>Packages and namespaces</h3>
<p>Whenever the <code>::</code> operator is used, the namespace of the corresponding package is loaded but not attached to the search path.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">tools<span class="op">::</span><span class="kw">file_ext</span>(<span class="st">&quot;test.txt&quot;</span>)     <span class="co"># loads the namespace of the &#39;tools&#39; package,</span></code></pre></div>
<pre><code>## [1] &quot;txt&quot;</code></pre>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="kw">search</span>()                        <span class="co"># but does not attach it to the search path</span></code></pre></div>
<pre><code>## [1] &quot;.GlobalEnv&quot;        &quot;package:stats&quot;     &quot;package:graphics&quot; 
## [4] &quot;package:grDevices&quot; &quot;package:utils&quot;     &quot;package:datasets&quot; 
## [7] &quot;package:methods&quot;   &quot;Autoloads&quot;         &quot;package:base&quot;</code></pre>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="kw">file_ext</span>(<span class="st">&quot;test.txt&quot;</span>)            <span class="co"># and thus produces an error if called without namespace prefix</span></code></pre></div>
<pre><code>## Error in file_ext(&quot;test.txt&quot;): could not find function &quot;file_ext&quot;</code></pre>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="co"># base::mean and stats::rnorm work, because base and stats namespaces are</span>
<span class="co"># loaded and attached by default:</span>
<span class="kw">mean</span>(<span class="kw">rnorm</span>(<span class="dv">10</span>))</code></pre></div>
<pre><code>## [1] -0.04888008</code></pre>
<p>In contrast, the <code>library</code> and <code>require</code> commands both load the package’s namespace but also attach its namespace to the search path, which allows to refer to functions of the package without using the <code>::</code> operator.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="kw">library</span>(tools)                  <span class="co"># loads namespace and attaches it to search path</span>
<span class="kw">search</span>()</code></pre></div>
<pre><code>##  [1] &quot;.GlobalEnv&quot;        &quot;package:tools&quot;     &quot;package:stats&quot;    
##  [4] &quot;package:graphics&quot;  &quot;package:grDevices&quot; &quot;package:utils&quot;    
##  [7] &quot;package:datasets&quot;  &quot;package:methods&quot;   &quot;Autoloads&quot;        
## [10] &quot;package:base&quot;</code></pre>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="kw">file_ext</span>(<span class="st">&quot;test.txt&quot;</span>)            <span class="co"># now works</span></code></pre></div>
<pre><code>## [1] &quot;txt&quot;</code></pre>
<p>Since a call to a function shall not alter the search path, <code>library</code> or <code>require</code> statements are not allowed in functions used in R packages. In contrast, <code>library</code> statements are suitable for local (data analysis) R scripts especially if a specific function is used frequently. An alternative is to locally re-map the frequently used function:</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">file_ext &lt;-<span class="st"> </span>tools<span class="op">::</span>file_ext
<span class="kw">file_ext</span>(<span class="st">&quot;test.txt&quot;</span>)</code></pre></div>
<pre><code>## [1] &quot;txt&quot;</code></pre>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="kw">file_ext</span>(<span class="st">&quot;test.docx&quot;</span>)</code></pre></div>
<pre><code>## [1] &quot;docx&quot;</code></pre>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="kw">file_ext</span>(<span class="st">&quot;test.xlsx&quot;</span>)</code></pre></div>
<pre><code>## [1] &quot;xlsx&quot;</code></pre>
</div>
</div>
</div>
<div id="docu" class="section level1">
<h1>Code documentation</h1>
<div id="function-headers" class="section level2">
<h2>Function headers</h2>
<p>A function header is placed above any function, unless it is defined inside another function.</p>
<p>It is recommended to use the <a href="https://cran.r-project.org/web/packages/roxygen2">roxygen</a> format, because it</p>
<ul>
<li>promotes a standardized documentation</li>
<li>allows for automatic creation of a user-documentation from the header</li>
<li>allows for automatic creation of all namespace definitions of an R-package</li>
</ul>
<p>A function header at least contains the following elements (the corresponding roxygen keyword is listed at the start):</p>
<ul>
<li><span class="citation">@title</span>: short sentence of what the function does</li>
<li><span class="citation">@description</span>: extended description of the function (optionally the <span class="citation">@details</span> keyword can be used to describe further details)</li>
<li><span class="citation">@param</span> (or <span class="citation">@field</span> with RefClasses): For each input parameter, a summary of the type of the parameter (e.g., string, numeric vector) and, if not obvious from the name, what the parameter does.</li>
<li><span class="citation">@return</span>: describes the output from the function, if it returns something.</li>
<li><span class="citation">@examples</span>: if applicable, examples of function calls are provided. Providing executable R code, which shows how to use the function in practice, is a very important part of the documentation, because people usually look at the examples first. While generally example code should work without errors, for the purpose of illustration, it is often useful to also include code that causes an error. If done, the corresponding place in the code should be marked accordingly (use  with roxygen).</li>
</ul>
<p>Example of a roxygen-header:</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="co">#&#39; @title String suffix matching</span>
<span class="co">#&#39;</span>
<span class="co">#&#39; @description</span>
<span class="co">#&#39; Determines whether \code{end} is a suffix of string \code{s} (borrowed from</span>
<span class="co">#&#39; Python, where it would read \code{s.endswith(end)})</span>
<span class="co">#&#39;</span>
<span class="co">#&#39; @param s (character) the input character string</span>
<span class="co">#&#39; @param end (character) string to be checked whether it is a suffix of the</span>
<span class="co">#&#39; input string \code{s}.</span>
<span class="co">#&#39; @return \code{TRUE} if \code{end} is a suffix of \code{s} else \code{FALSE}</span>
<span class="co">#&#39;</span>
<span class="co">#&#39; @examples</span>
<span class="co">#&#39; string_ends_with(&quot;Hello World!&quot;, &quot;World!&quot;)   # TRUE</span>
<span class="co">#&#39; string_ends_with(&quot; Hello World!&quot;, &quot;world!&quot;)  # FALSE (case sensitive)</span>
string_ends_with &lt;-<span class="st"> </span><span class="cf">function</span>(s, end)
{
    <span class="co"># Implementation ...</span>
}</code></pre></div>
</div>
<div id="inline-code-comments" class="section level2">
<h2>Inline code comments</h2>
<p>Inline comments should explain the programmer’s intent at a higher level of abstraction than the code, that is, they should provide additional information, which are not obvious from reading the code alone. As such, good comments don’t repeat, summarize or explain the code, unless the code is so complicated that it warrants an explanation, in which case, however, it is often worth to revise the code to make it more readable instead.</p>
<p>Examples of suitable, informative comments:</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="co"># Compare strings pairwise and determine first position of differing characters</span>
splitted_s &lt;-<span class="st"> </span><span class="kw">strsplit</span>(s, <span class="dt">split =</span> <span class="st">&quot;&quot;</span>)[[<span class="dv">1</span>]]
splitted_url &lt;-<span class="st"> </span><span class="kw">strsplit</span>(url, <span class="dt">split =</span> <span class="st">&quot;&quot;</span>)[[<span class="dv">1</span>]][<span class="dv">1</span><span class="op">:</span><span class="kw">nchar</span>(s)]
different &lt;-<span class="st"> </span>splitted_s <span class="op">!=</span><span class="st"> </span>splitted_url
first_different_position &lt;-<span class="st"> </span><span class="kw">which</span>(different)[<span class="dv">1</span>]

<span class="co"># Provide index via names as we need them later</span>
<span class="kw">names</span>(v) &lt;-<span class="st"> </span><span class="kw">seq_along</span>(v)</code></pre></div>
<p>Bad redundant comments:</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">v &lt;-<span class="st"> </span><span class="dv">1</span><span class="op">:</span><span class="dv">10</span>  <span class="co"># initialize vector</span>

<span class="co"># Loop through all numbers in the vector and increment by one</span>
<span class="cf">for</span> (i <span class="cf">in</span> <span class="dv">1</span><span class="op">:</span><span class="kw">length</span>(v)) {
    v[i] &lt;-<span class="st"> </span>v[i] <span class="op">+</span><span class="st"> </span><span class="dv">1</span>  <span class="co"># increment number</span>
}</code></pre></div>
<p>That’s it already! :)</p>
</div>
</div>
</section>
