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

> Jacobian conjecture, unit distance problem, collatz conjecture, kernel soundness bug, OpenAI, Anthropic, Codex, Claude Code, Mythos, Mythos, Mythos, Lean4 theorem prover, Proof assistant, AI AI AI AI

Ok, ok ok. For the rest of this video, I'm gonna ban mentioning AI for the most part. AI is probably why you have heard about Lean, but I want to convince you that AI is absolutely not the most interesting thing about Lean, and it is absolutely not the mosting interesting thing about these proof assistants in general! Mostly, my secret goal will be to convince you that type theory, specificly inductive types, is some very cool abstract nonsense.

So what am I going to cover in this video? If you look at the chapters, you'll probably see the video is pretty long (yes, I realize that i'm starting my video with a "how to watch this video" chapter before even introducing what I'm talking about, but we'll get there eventually, I promise), and you're probably also wondering who this video is even for. In my head, you-- the viewer-- are someone generally familiar with a little programming and some basic proof-based math. If not, that's probably still fine as I will try to give at least some explanation for everything I mention, but that background is definitely nice to have. Anyways, you've probably never really used a proof assistant before, but maybe you're curious about what the heck all the hype is about. Maybe you want to be able to read the cryptic source code of these AI formalizations, or maybe you just want to learn something cool. That's where I was last year personally, and I will tell you that the Lean4 theorem prover has been one of the coolest things I've learned about this past year.

Anyways, in the first part of this video, I want to go over the basics of how to use Lean, covering similar material to "Theorem proving in Lean4." This book is a great resource, highly recommended, though it's probably a bit too difficult for a first introduction. However, I will NOT go super deep on specifics (like specific tactics, language features, or Mathlib APIs), so this video will not be a good tutorial about how to actually use Lean in practice. I want to cover just enough to give you a firm foundation, but I will not be doing much real math or programming this video. Instead, in the second part of this video, I want to get really deep into the weeds about how Lean actually works under the hood. I think this stuff is super super important, and I don't think existing educational "intro to Lean" materials cover it enough at all.

I want you to come away with (at least a vague) picture of how your code gets lowered down into the base type theory. Just as you might have a vague mental model for how the C code you write becomes assembly that your CPU can understand, I want to build a model of how Lean code becomes lambda terms that the Lean kernel can typecheck. I think that only with this deep understanding can you write truly morally correct, not just technically correct, code, and nobody really emphasizes this! Now, this is going to be a lot, and you will definitely have to play around with Lean yourself to get any sort of understanding of this stuff, so it might be good to come back and rewatch this video, as you might be able to really get a larger percentage on a second watch. (Plus, it would be cool if people viewbotted my video to 300% retention, that would also be nice...)

Alright! That's it for the long rambling intro-- now let's learn some lean! The first step is to setup lean, and the normal setup is just vscode with the Lean4 extension. You can figure it out, I trust you.

Anyways, I want to start with the type system, and unsurprisingly, Lean supports many of the types that you'd expect from a programming language. We can start by defining a symbol:

```leanInit ctx
```
```lean ctx
-- this is a comment in lean.
def hello : String := "world"
```

The colon equals `:=` is the assignment operator, and the colon `:` denotes a type annotation. So `hello` is a symbol that takes on the value of `"world"`, and it's type is `String`. In the lingo, we say that `hello` is _definitionally equal_ to the string `"world"`, and it is a _term_ of the _type_ `String`. Here, you can just think of "term of a type" as being the same thing as "element of a set".

Functions work in pretty much the same way, except they can take in some arguments.

```lean ctx
def addFive (x : Int) : Int :=
  x + 5
```

We can use `#check` to see the type of expressions, and we can use `#eval` to evaluate expressions. Like many functional programming languages, we call the function by just juxtaposing the function and the argument, so we do not use any parenthesis to write function calls.

```lean ctx
#check addFive 0  -- addFive 0 : Int

#eval addFive 0   -- 5
#eval addFive 2   -- 7

#check (addFive : Int → Int)
```

Here, we have just a bit of new syntax where we can explicitly annotate `addFive` with the type we expect it to have. Confusingly, this looks a lot like we're specifying a parameter to a function, but that's not what's happening! You can also type the unicode right arrow `→` by typing the latex `\to` or `\->` in the vscode editor, and the same goes for all of the special characters in lean. You can also hover over these characters for documentation about what they are and how to type them.

Anyways, notice how `addFive` has a type of `Int → Int`, meaning it is a function that takes in an integer and returns another integer. We can also have functions that take in multiple arguments, and since Lean is a functional programming language, we do this by _currying_ the arguments. Let's define this function that takes in an integer and a string, and it returns a string containing a nice message:

```lean ctx
def importantMessage (x : Int) (name : String) : String :=
  name ++ "'s favorite number is " ++ toString x

#check importantMessage
-- importantMessage (x : Int) (name : String) : String

#eval importantMessage 5 "Joe"
-- "Joe's favorite number is 5"
```

Because of _currying_ ($`\mathrm{Hom}(X ⨂ Y, Z) ≅ \mathrm{Hom}(X, \mathrm{Hom}(Y, Z))`), we can partially apply this function like so:

```lean ctx
#check importantMessage 5
-- importantMessage 5 : String → String

#check importantMessage 5 "Joe"
-- importantMessage 5 "Joe" : String

#eval importantMessage 5 "Joe"
-- "Joe's favorite number is 5"
```

What's happening here is that `importantMessage` literally takes in a `Int` and returns a _function_ `String → String`. If we write it out in terms of lambda expressions, what's really going on is this:

```leanInit ctx2
```
```lean ctx2
def importantMessage : Int → (String → String) :=
  fun x => (fun name =>
    name ++ "'s favorite number is " ++ toString x)
```

This works very nicely because the arrow `→` is right-associative, so implicitly there are these parenthesis:

```lean ctx
#check (importantMessage : Int → String → String)
#check (importantMessage : Int → (String → String))
```

Additionally, function application is left-associative, so writing in the parentheses, this is what's really happening:

```lean ctx
#eval importantMessage 5 "Joe"
-- "Joe's favorite number is 5"

#eval (importantMessage 5) "Joe"
-- "Joe's favorite number is 5"
```
We are literally passing `5` into `importantMessage` to get a function from `String → String`, and then we pass in `"Joe"` to this new function.

This is something that took some time to get used to when I was first getting into functional programming. Because you dont write any parentheses, its very easy to forget that function application is left-associative and has a very high operator precedence, so I found myself often writing the wrong thing in more complicated expressions.

Alright, so far so good. But now, its time for the really cool part-- how does lean handle generics and templates? In C++ we might say `std::vector<int>` or `std::vector<std::string>`, and in Java we might say `ArrayList<Integer>` or `ArrayList<String>`. In Lean, we say `List Int` and `List String`:

```lean ctx
def myList : List Int := [1, 2, 3, 4, 5]
def otherList : List String := ["hello", "goodbye"]
```

Instead of being a bespoke language feature, generics are just functions! `List` is quite literally a normal function just like `addFive`, except instead of acting on integers, it acts on `Type`s:

```lean ctx
#check (List : Type → Type)
```

`List` is quite literally a function that takes in any type and returns a new type, the type of Lists of that type! In fact, it is a monoid in the category of endofunctors, but thats neither here nor there... The main point here is that _types_ have a type:

```lean ctx
#check (String : Type)
#check (Int : Type)
#check (List Int : Type)
```

And since types can behave just like normal objects in Lean, we can write our own custom generic functions like so:

```lean ctx
def reverseList (α : Type) (ls : List α) : List α :=
  match ls with
  | [] => []
  | x::xs => (reverseList α xs) ++ [x]

#eval reverseList Int [1, 2, 3]
-- [3, 2, 1]

#eval reverseList String ["hello", "goodbye"]
-- ["goodbye", "hello"]
```

Here, `reverseList` is a generic function that takes in a list of any type and reverses it. It is defined recursively: if the input list `ls` is empty, we return the empty list. Otherwise, `ls` must have some first element `x` together with a (possibly empty) list of remaining elements `xs`. The pattern matching here just reveals this structure. Then, we use recursion to reverse the remaining elements, and we add the first element `x` to the end.

We can see that `reverseList` is literally just a normal function that takes in two arguments: a `Type` `α` and then a list `ls` of type `List α`. Notice how the _type_ of the second argument depends on the _value_ of the first argument! This is what makes Lean _dependently typed_, and this feature is what allows mathematics to be expressed nicely in Lean. In general, we can use the _value_ of any previous argument when specifying the _type_ of our arguments.

Ok, this is already very nice, but we can actually do better. Instead of taking in the type as an explicit parameter, we can just make the parameter implicit and let Lean's elaborator figure it out for us. We just replace the normal parentheses with curly braces:

```lean ctx2
def reverseList {α : Type} (ls : List α) : List α :=
  match ls with
  | [] => []
  | x::xs => (reverseList xs) ++ [x]

#eval reverseList [1, 2, 3]
-- [3, 2, 1]

#eval reverseList ["hello", "goodbye"]
-- ["goodbye", "hello"]
```

Because `α` can be inferred from the type of `ls`, oftentimes we dont actually need to tell Lean what `α` is! Again, the elaborator just handles the boring boilerplate for us. If we ever need to access the implicit parameter explicitly, we can just prefix the name with an `@` to make the implicit parameters explicit again:

```lean ctx2
#check @reverseList Int
-- reverseList : List Int → List Int

#eval @reverseList Int [1, 2, 3]
-- [3, 2, 1]
```

But we don't have to stop here. If `String`, `Int`, and `List Int` all have a type, does `Type` itself have a type? Yes, it does! But we have to be careful-- if we were to have `Type` be a term of itself (`Type : Type`) we can create logical paradoxes. The famous example is Russel's paradox, where it is impossible to tell if the set of all sets that do not contain themselves contains itself:

$$`
\begin{align*}
S = \{X ∈ \mathbf{Set} \mid X \not\in X \} \\
S ∈ S \implies S \not\in S \implies S ∈ S \implies \dots
\end{align*}
`

The definition of $`S` means that $`X` is in $`S` if and only if $`X` does not contain itself. So if it were true that $`S` is in $`S`, this means that in fact $`S` is not in $`S`. But then, the definition of $`S` again tells us that since $`S` does not contain itself, $`S ∈ S`, and we have a contradiction that will keep looping forever.

The type-theoretic version of this is called Girard's Paradox. In the case of Russel, the paradox arises because we quantified over the set of all sets, which has the property that it contains itself ($`\mathbf{Set} ∈ \mathbf{Set}`). Similarly, if we have that `Type` is a term of `Type` (`Type : Type`), this basically makes `Type` the type of all types and results in Girard's paradox.

To get ourselves out of this pickle, we must invent a heirarchy of universes! If `Type` can't be a `Type`, why don't we just say it has the type of a "meta-type", and what if this "meta-type" has the type of a "meta-meta-type", and so on? This is exactly what lean does: `Type` has a type of `Type 1`, then `Type 1` has a type of `Type 2` and so on. These things are called type universes, and every type universe is always contained in a bigger one.

```lean ctx
-- `Type` is the same thing as `Type 0`.
#check Type    -- Type : Type 1
#check Type 1  -- Type 1 : Type 2
#check Type 2  -- Type 2 : Type 3
```

This also applies to the types of functions on types, like `Type → Type` (which is the type of `List`). We just consider the 'biggest' universe level that appears and add one to get a bigger universe that can safely contain it:

```lean ctx
#check Type → Type
-- Type → Type : Type 1

#check Type → Type 1
-- Type → Type 1 : Type 2

#check Type 2 → Type
-- Type 2 → Type : Type 3
```

Another way of looking at this is that if we have two terms `X` and `Y` in some type universe `Type u` (`X Y : Type u`), then we can make a new term of the same type universe by considering the function type `X → Y : Type u`. For example, `Int` is in `Type`, and so `Int → Int` is also in `Type`. Similarly, `Type` is in `Type 1`, so `Type → Type` is also in `Type 1`.

Hold on here, because this is pretty confusing. One might be tempted to think that `List : Type 1`, but that is wrong! Remember that `List` has type `Type → Type`, and it is `Type → Type` itself that is of type `Type 1`.

```lean ctx
#check (List : Type → Type)
#check (Type → Type : Type 1)
```

And there is more that is potentially very confusion! While we could consider `List` as a literal function from `Type` to `Type`, here we explicitly do NOT think of `Type` as a function from the naturals to `Type ∞` or something like that. Not only does `Type ∞` not exist, the numbering of 1, 2, 3 are not the same as the integers `Int` or the natural numbers `Nat` in Lean-- they are completely unrelated, and they are not objects inside of Lean's type theory at all. They exist on the level of the _metatheory_, and we just happen to write `Type 1` and `Type 2` because it is a convenient notation. We just as well could have called this heirarchy `UniverseOne : UniverseTwo` and `UniverseTwo : UniverseThree` and so on.

Anyways, what's the point of all this? So far this might all seem like a load of very confusing abstract nonsense, but it is _cool_ abstract nonsense. See, I lied a little when I said that `List` was a function from `Type` to `Type`. In fact, `List` is an infinite family of functions: for every universe level `u`, there is a function `List.{u}` from `Type u` to `Type u`! This is something called _universe polymorphism_.

```lean ctx
#check List
-- List.{u} : Type u → Type u
```

Again, I want to emphasize that the universe levels 1,2,3 do not exist _within_ Lean's type theory, but in fact are part of the metatheory. This means that in the syntax of `List.{u}`, the `u` is not actually a parameter into a function, but is a variable at the level of the metatheory. We have to consider `List.{u}` as literally an infinite family of functions, NOT as a function that takes a universe level `u` and gives you a function from `Type u` to `Type u`, however tempting that might be.

A few more examples to see how the universe levels keep stepping up:

```lean ctx
#check List.{1} Type
-- List Type : Type 1

#check List.{2} (Type 1)
-- List (Type 1) : Type 2

#check List.{3} (Type 2)
-- List (Type 2) : Type 3
```

<explanation>

Anyways, this means we can do fun things like make lists of types and such:

```leanInit ctx
```
```lean ctx
def funTypes : List Type :=
  [Nat, String, List String]

def monads : List (Type → Type) :=
  [List, Option, fun T => Nat → T]

def funnerTypes : List (Type 1) :=
  [Type, Type → Type, List Type, List (Type → Type)]
```

<explanation>

Of course, we can also make our `reverseList` function polymorphic over universes too:

```lean ctx
def reverseList.{u} {α : Type u} (ls : List α) : List α :=
  match ls with
  | [] => []
  | x::xs => (reverseList xs) ++ [x]

#check reverseList monads
-- reverseList monads : List (Type → Type)
```

Unfortunately, we haven't told Lean how to print out Lists of functions on Types, so we can't see the value of the list, but trust me bro-- it worked!

Anyways, that's about it for universes for now. There is one other special universe that we haven't covered yet, `Prop`, the universe of Propositions, but it's an exception to the general rule and we'll cover it once we start proving mathematical theorems.

Now, let's take a step back. We've just seen how type universes like `Type u` work, and we've also seen how to define, type-check, and evaluate dependently-typed functions like `reverseList`. It turns out that these are already two of the three categories of fundamental objects in Lean's type theory! That's right-- everything in Lean is either a type universe, a dependent function, or some form of an _inductive type_.

Now arguably, you might want to count quotients as a kind of fourth fundamental object, but in my opinion they are just a slight generalization of inductive types, namely they are a higher inductive type. But anyways, we'll cross that bridge when we get there.

For now, just know that inductive types are by far the biggest and most powerful category of the three, so we will get to know them slowly.
















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



For now, just one more thing: Lean's universes are _not_ cumulative. If you read academic papers about type theory (i know, i know), you will often find that they will define universes such that `X : Type u` will imply that `X : Type (u + 1)`. Other proof assistants like Rocq also do this, but Lean enforces that everything is a term of exactly one type. This makes type checking easier and makes the Lean kernel simpler, and part of the Lean philosphy is to make the kernel as simple as possible, as the kernel is what garauntees the correctness of your proofs.

Also, the fact that universes are not cumulative is not a problem at all: you can define a function `ULift.{u,v}` that lifts values from one universe to a higher one:
```lean ctx
#check ULift
-- ULift.{r, s} (α : Type s) : Type (max s r)
```
This means that you can write anything that you might want to write if universes were cumulative, the only caveat being that you have to explicitly convert between universe levels with this `ULift` function. At the cost of some extra boilerplate, the typechecking algorithm can be simplified!
