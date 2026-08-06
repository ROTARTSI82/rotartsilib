import VersoBlog
import Illuminate
open Verso Genre Blog Illuminate

#doc (Post) "Intro to Lean and Verso" =>

%%%
authors := ["Grant"]
date := {year := 2026, month := 8, day := 6}
%%%

This is my first post!

Ok, so, Lean has been in the zeitgeist a lot recently, hasn't it? Here, look, we've got:

Jacobian conjecture, unit distance problem, collatz conjecture, kernel soundness bug, OpenAI, Anthropic, Codex, Claude Code, Mythos, Mythos, Mythos, Lean4 theorem prover, Proof assistant, AI AI AI AI

Ok, ok ok. For the rest of this video, I'm gonna ban mentioning AI for the most part. AI is probably why you have heard about Lean, but I want to convince you that AI is absolutely not the most interesting thing about Lean, and it is absolutely not the mosting interesting thing about these proof assistants in general!

So what am I going to cover in this video? If you look at the chapters, you'll probably see the video is pretty long (yes, I realize that i'm starting my video with a "how to watch this video" chapter before even introducing what I'm talking about, but we'll get there eventually, I promise), and you're probably also wondering who this video is even for. In my head, you-- the viewer-- are someone generally familiar with a little programming and some basic proof-based math. If not, that's probably still fine as I will try to give at least some explanation for everything I mention, but that background is definitely nice to have. Anyways, you've probably never really used a proof assistant before, but maybe you're curious about what the heck all the hype is about. Maybe you want to be able to read the cryptic source code of these AI formalizations, or maybe you just want to learn something cool. That's where I was last year personally, and I will tell you that the Lean4 theorem prover has been one of the coolest things I've learned about this past year.

Anyways, in the first part of this video, I want to go over the basics of how to use Lean, covering similar material to "Theorem proving in Lean4." This book is a great resource, highly recommended, though it's probably a bit too difficult for a first introduction. However, I will NOT go super deep on specifics (like specific tactics, language features, or Mathlib APIs), so this video will not be a good tutorial about how to actually use Lean in practice. I want to cover just enough to give you a firm foundation, but I will not be doing much real math or programming this video. Instead, in the second part of this video, I want to get really deep into the weeds about how Lean actually works under the hood. I think this stuff is super super important, and I don't think existing educational "intro to Lean" materials cover it enough at all.
Especially "Natural Number Game".
Side note-- do people think this is a good way to learn Lean? Like I just feel it teaches you to brute force spam tactics with absolutely zero understanding of what you're doing, but anyways-- slandering the natural number game is not the point.
I want you to come away with (at least a vague) picture of how your code gets lowered down into the base type theory. Just as you might have a vague mental model for how the C code you write becomes assembly that your CPU can understand, I want to build a model of how Lean code becomes lambda terms that the Lean kernel can typecheck. I think that only with this deep understanding can you write truly morally correct, not just technically correct, code, and nobody really emphasizes this! Now, this is going to be a lot, and you will definitely have to play around with Lean yourself to get any sort of understanding of this stuff, so it might be good to come back and rewatch this video, as you might be able to really get a larger percentage on a second watch. (Plus, it would be cool if people viewbotted my video to 300% retention, that would also be nice...)

Alright! That's it for the long rambling intro-- now let's learn some lean!

I want to start with the type system, and unsurprisingly, Lean supports many of the types that you'd expect from a programming language.



Here are some examples showcasing *Verso*'s capabilities:

# 1. Markdown Features
Verso supports standard Markdown features, meaning you can easily write:
* *Bold text* and _italic text_
* [Links to cool resources](https://leanprover.github.io/)
* `inline code snippets`

You can also create nested lists:
1. First item
2. Second item
   * A sub-item
   * Another sub-item

# 2. LaTeX and Math
You can include mathematical notation using LaTeX! For inline math, you can write $`\alpha + \beta = \gamma`.

For block equations, you can use double dollar signs with a backtick block:
$$`\int dx = x + C`

# 3. Tables
Since Verso's blog templates do not support standard Markdown tables or the `table` directive out of the box, you can use a code block to format tabular data for now:

```
| Item   | Description   | Quantity |
|--------|---------------|----------|
| Apple  | Red fruit     | 5        |
| Banana | Yellow fruit  | 10       |
```

# 4. Lean Code and Diagrams
Finally, the most powerful feature of Verso is that Lean code blocks are actually typechecked during the build!

```leanInit introContext
```

```lean introContext
open Illuminate

def hello : String := "world"

#check hello

theorem easy : 1 + 1 = 2 := rfl
```

> Note: While the `Illuminate` code above is typechecked by Lean, Verso does not currently have a built-in directive to render `Illuminate` diagrams directly into the HTML blog output (it only works interactively in the Lean IDE via `#diagram`).

If you want diagrams in your blog right now, you can use MathJax's matrix or commutative diagram features! For example:
$$`
\begin{matrix}
A & \xrightarrow{f} & B \\
\downarrow & & \downarrow \\
C & \xrightarrow{g} & D
\end{matrix}
`

Isn't that awesome? Your code and proofs are guaranteed to be correct!
