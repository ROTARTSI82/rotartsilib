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

Alright! That's it for the long rambling intro-- now let's learn some lean! The first step is to set up lean, and the normal setup is just vscode with the Lean4 extension. You can figure it out, I trust you.

Let's start with the very basics of the type system. We can begin by defining a symbol:

```leanInit ctx
```
```lean ctx
-- this is a comment in lean.
def hello : String := "world"
```

The colon equals is the assignment operator, and the colon denotes a type annotation. We can say that `hello` is _definitionally equal_ to the string `"world"`, and it is a _term_ of the _type_ `String`. Here, you can think of "term of a type" as being the same thing as "element of a set".

Functions work in pretty much the same way, except they can also take in some arguments. Take for example this `addFive` function.

```lean ctx
def addFive (x : Int) : Int :=
  x + 5
```

We can use `#check` to see the type of an expression, and we can use `#eval` to evaluate them. Like many functional programming languages, we can call a function by juxtaposing the function and its argument, so we do not have to use any parenthesis.

```lean ctx
#check addFive 0  -- addFive 0 : Int

#eval addFive 0   -- 5
#eval addFive 2   -- 7

#check (addFive : Int → Int)
```

Notice that here we can explicitly annotate the expression `addFive` with the type that we expect it to have. Confusingly, this syntax looks a lot like we're specifying a parameter to a function, but that is not what's happening!

We also see that Lean is using a weird unicode arrow to denote the function type, and this use of unicode will be a recurring theme. You can also type this symbol with the latex `\to` in the vscode editor, and it works similarly for other special characters. You can also hover over these characters for documentation about what they are and how to type them.

Anyways, notice how `addFive` has a type of `Int → Int`, meaning it is a function that takes in an integer and returns another integer. We can also have functions that take in multiple arguments, and since Lean is a functional programming language, we do this by _currying_ the arguments. For example, let's define this function that takes in an integer and a string, and it returns a new string with a nice little message:

```lean ctx
def importantMessage (x : Int) (name : String) : String :=
  name ++ "'s favorite number is " ++ toString x

#check importantMessage
-- importantMessage (x : Int) (name : String) : String

#eval importantMessage 5 "Joe"
-- "Joe's favorite number is 5"
```

Then, currying lets us handle partial function applications like so: ($`\mathrm{Hom}(X ⨂ Y, Z) ≅ \mathrm{Hom}(X, \mathrm{Hom}(Y, Z))`)
```lean ctx
#check importantMessage 5
-- importantMessage 5 : String → String

#check importantMessage 5 "Joe"
-- importantMessage 5 "Joe" : String

#eval importantMessage 5 "Joe"
-- "Joe's favorite number is 5"
```

What's happening here is that `importantMessage` literally takes in a `Int` and returns a _function_ `String → String`. If we were write it out explicitly in terms of lambda expressions, this is really what's going on:

```leanInit ctx2
```
```lean ctx2
def importantMessage : Int → (String → String) :=
  fun x => (fun name =>
    name ++ "'s favorite number is " ++ toString x)
```

This works very nicely because the arrow `→` is right-associative, so implicitly there are these parenthesis here.

```lean ctx
#check (importantMessage : Int → String → String)
#check (importantMessage : Int → (String → String))
```

Additionally, function application is left-associative, so writing in the parentheses again, this is what's really happening:

```lean ctx
#eval importantMessage 5 "Joe"
-- "Joe's favorite number is 5"

#eval (importantMessage 5) "Joe"
-- "Joe's favorite number is 5"
```
We are literally passing `5` into `importantMessage` to get a function from `String → String`, and then we pass in `"Joe"` to this new function.

This is something that took some time to get used to when I was first getting into functional programming. Because you dont write any parentheses, its very easy to forget that function application is left-associative and has a very high operator precedence, so I found myself often writing the wrong thing in more complicated expressions.

Alright, so far so good. But now for something pretty cool-- how does lean handle generics and templates? In C++ we might say `std::vector<int>` or `std::vector<std::string>`, and in Java we might say `ArrayList<Integer>` or `ArrayList<String>`. In Lean, we can do the same thing, and instead of being a bespoke language feature, generics are just normal functions!

```lean ctx
def myList : List Int := [1, 2, 3, 4, 5]
def otherList : List String := ["hello", "goodbye"]
```

`List` is quite literally a normal function, just like `addFive`, except instead of acting on integers, it acts on `Type`s:

```lean ctx
#check (List : Type → Type)
```

It's a function that takes in some type, and returns a new type, the type of Lists of that type! Anyways, monoid in the category of endofunctions, but the main point is that _types_ have a type.

```lean ctx
#check (String : Type)
#check (Int : Type)
#check (List Int : Type)
```

And since types can behave just like normal objects in Lean, we can leverage the fact that Lean is _dependently typed_ to write our own custom generic functions like so:

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

This also applies to function types, like `Type → Type` (which is the type of `List`). We just consider the 'biggest' universe level that appears and add one to get a bigger universe that can safely contain it:

```lean ctx
#check Type → Type
-- Type → Type : Type 1

#check Type → Type 1
-- Type → Type 1 : Type 2

#check Type 2 → Type
-- Type 2 → Type : Type 3
```

Another way of looking at this is that if we have two terms `X` and `Y` in some type universe `Type u` (`X Y : Type u`), then we can make a new term of the same type universe by considering the function type `X → Y : Type u`. In some sense, you can consider that the type of the right arrow is something like `→ : Type u → Type u → Type u`. For example, `Int` is in `Type`, and so `Int → Int` is also in `Type`. Similarly, `Type` is in `Type 1`, so `Type → Type` is also in `Type 1`.

Hold on here, because this is pretty confusing. One might be tempted to think that `List : Type 1`, but that is wrong! Remember that `List` has type `Type → Type`, and it is `Type → Type` itself that is of type `Type 1`.

```lean ctx
#check (List : Type → Type)
#check (Type → Type : Type 1)
```

And there is more: While we could consider `List` as a literal function from `Type` to `Type`, here we explicitly do NOT think of `Type` as a function from the naturals to `Type ∞` or something like that. Not only does `Type ∞` not exist, the numbering of 1, 2, 3 are not the same as the integers `Int` or the natural numbers `Nat` in Lean-- they are completely unrelated, and they are not objects inside of Lean's type theory at all. They exist on the level of the _metatheory_, and we just happen to write `Type 1` and `Type 2` because it is a convenient notation. We just as well could have called this heirarchy `UniverseOne : UniverseTwo` and `UniverseTwo : UniverseThree` and so on.

Anyways, what's the point of all this? So far this might all seem like a load of very confusing abstract nonsense, but it is _cool_ abstract nonsense. See, I lied a little when I said that `List` was a function from `Type` to `Type`. In fact, `List` is an infinite family of functions: for every universe level `u`, there is a function `List.{u}` from `Type u` to `Type u`! This is something called _universe polymorphism_.

```lean ctx
#check List
-- List.{u} : Type u → Type u
```

Again, I want to emphasize that the universe levels 1,2,3 do not exist _within_ Lean's type theory, but in fact are part of the metatheory. This means that in the syntax of `List.{u}`, the `u` is not actually a parameter into a function, but is a variable at the level of the metatheory. We have to consider `List.{u}` as literally an infinite family of functions, NOT as a function that takes a universe level `u` and gives you a function from `Type u` to `Type u`, however tempting that might be.

A few more examples to see how the universe levels keep stepping up:

```lean ctx
#check List Type
-- List Type : Type 1

#check List (Type 1)
-- List (Type 1) : Type 2

#check List (Type 2)
-- List (Type 2) : Type 3
```

<explanation> Note that `List` takes a `Type u` returns another `Type u` and not a `Type`-- a type that lives in a smaller universe cannot contain things from a bigger universe!

On a somewhat unrelated note, another detail about universes that I want to highlight is that universe levels in Lean are not cumulative. This means that if `X : Sort u` and `Sort u : Sort v`, then it is not true that `X : Sort v`. If you read academic papers about type theory or use another proof assistant like Rocq/Coq, you will find that they often take this approach. Lean chooses to avoid this, as this makes type checking easier and allows the Lean kernel to be simpler. Part of the Lean philosphy is to make the kernel as simple as possible, as the kernel is what garauntees the correctness of your proofs.

Also, the fact that universes are not cumulative is not a problem at all: you can define a function `ULift.{u,v}` that lifts values from one universe to a higher one:
```lean ctx
#check ULift
-- ULift.{r, s} (α : Type s) : Type (max s r)
```
This means that you can write anything that you might want to write if universes were cumulative, the only caveat being that you have to explicitly convert between universe levels with this `ULift` function. At the cost of some extra boilerplate, the typechecking algorithm can be simplified! This `ULift` function is also not anything special, and it is actually just another example of something called an _inductive type_, which is a category that includes types like `String` and `Int`.

Anyways, the heirarchy of universes means that we can do fun things like make lists of types and such:

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

That's about it for universes for now, though there is one other special universe that we haven't covered yet, `Prop`, the universe of Propositions. However, it's an exception to the general rule, and we'll cover it once we start proving mathematical theorems.

Now, let's take a step back. We've just seen how type universes like `Type u` work, and we've also seen how to define, type-check, and evaluate dependently-typed functions like `reverseList`. It turns out that these are already two of the three categories of fundamental objects in Lean's type theory! That's right-- everything in Lean is either a type universe, a dependent function, or some form of an _inductive type_.

Now arguably, you might want to count quotients as a kind of fourth fundamental object, but in my opinion they are just a slight generalization of inductive types, namely they are a higher inductive type. But anyways, we'll cross that bridge when we get there.

For now, just know that inductive types are by far the biggest and most powerful category of the three, so we will get to know them slowly.

First, I want to point out that we have been using inductive types this entire time! `List`, `Int`, `String` are all examples of inductive types, and the defining feature of inductive types is that we can `match` them against patterns. Before we get to those types, let's see some simpler example of an inductive type:

```lean ctx
inductive Weekday where
| monday
| tuesday
| wednesday
| thursday
| friday

#check Weekday          -- Weekday : Type
#check Weekday.monday   -- Weekday.monday : Weekday
#check Weekday.tuesday  -- Weekday.tuesday : Weekday
-- and so on...
```

If you are familiar with Rust, note that this looks exactly like a Rust `enum`! When we define the `Weekday` type, we have introduced all these new constants. We have our new type `Weekday : Type` of course, but we also have these _constructors_ for this type. These constructors are exactly the cases that we have to cover with a `match`:

```lean ctx
def toDayNumber (day : Weekday) : Int :=
  match day with
  | .monday => 1
  | .tuesday => 2
  | .wednesday => 3
  | .thursday => 4
  | .friday => 5

#eval toDayNumber Weekday.wednesday  -- 3
```

One thing to note about match statements in Lean is that they have to be _exhaustive_. That means we have to provide a value for every possible input, so we have to cover every single constructor of `Weekday` with a case. Under the hood when the kernel type checks, Lean will essentially translate your `match` statement into a call to `Weekday.rec`, which is a function that is automatically generated for every inductive type. This function is called the _recursor_:

```lean ctx
#check Weekday.rec
-- Weekday.rec.{u} {motive : Weekday → Sort u} (monday : motive Weekday.monday) (tuesday : motive Weekday.tuesday)
--  (wednesday : motive Weekday.wednesday) (thursday : motive Weekday.thursday) (friday : motive Weekday.friday)
--  (t : Weekday) : motive t
```

Let's digest this type signature slowy. First, note that we have a type universe variable, and this is just so our `match` expression can return a value that lives in any type universe. Here, we use `Sort` instead of `Type` to handle the case of `Prop`, the universe of propositions. The details aren't important for now, but just know that `Sort u` is literally the same thing as `Type (u+1)`, so it is just a different numbering system.

We see that the first argument is `motive`, and this is just a method for enabling different arms of our `match` to be dependently typed. In the case of our `toDayNumber` function, our `motive` will just be this constant function (`fun x => Int`), always returning `Int`.

Then, we see an argument for each of the constructors we specified for our inductive type, and these will be the values that our `match` expression will take on in each case.

Finally, we take the argument `t : Weekday`, and this is the value we match against. The entire function then returns the value that the `match` should take on! Thus, our `toDayNumber` function in theory can be written as thus:

```lean ctx
noncomputable def toDayNumberV2 (day : Weekday) : Int :=
  @Weekday.rec (fun _ => Int) 1 2 3 4 5 day
```

The fact that we have to mark this function as `noncomputable` is just a quirk of lean, as it only likes to generate executable code for `match` expressions but not raw calls into the recursor. Did I mention that you can compile your lean code into executable binaries? You can totally write real programs with Lean, but we won't be investigating that side of the language much.

Also, notice how the motive is an implicit parameter, but I'm choosing to explicitly write it out here! Lean's elaborator is able to automatically infer and construct the `motive` for your `match` statements, so normally you don't have to worry about writing the boilerplate for it even if you're using raw calls to the recursor.

However, for completeness, I want to show you an example of a slightly more complicated `motive`. If for some reason we wanted to write a function that returns values of different types depending on what day it is, we can do that!

```lean ctx
def myMotive (d : Weekday) : Type :=
  match d with
  | .monday => Int
  | .tuesday => Bool
  | .wednesday => String
  | .thursday => List Bool
  | .friday => List Int

def myFunction (d : Weekday) : myMotive d :=
  match d with
  | .monday => (5 : Int)
  | .tuesday => Bool.true
  | .wednesday => "it's wednesday"
  | .thursday => [Bool.true, Bool.false]
  | .friday => [1, 2, 3]

#eval myFunction Weekday.monday     -- 5
#eval myFunction Weekday.wednesday  -- "it's wednesday"
```

Note that we have to use the recursor to build the `myMotive` function before we can use it in our definition of `myFunction`! However, it won't be turtles all the way down, as the motive for the motive will just be a constant function:

```lean ctx
noncomputable def myMotiveV2 (d : Weekday) : Type :=
  @Weekday.rec (fun _ => Type) Int Bool String (List Bool) (List Int) d

noncomputable def myFunctionV2 (d : Weekday) : myMotiveV2 d :=
  @Weekday.rec myMotiveV2 (5 : Int) Bool.true "it's wednesday" [Bool.true, Bool.false] [1, 2, 3] d
```

With this, we have a firm handle on these simple inductive types, so now we are ready to see something slightly more complicated. First, let's pull up our old definition of our `Weekday` type, and let's write it out more verbosely by just adding a bunch of type annotations:

```lean ctx2
inductive Weekday : Type where
| monday : Weekday
| tuesday : Weekday
| wednesday : Weekday
| thursday : Weekday
| friday : Weekday
```

Now, let's investigate the `Option` type, which is a type that can either contain `some` value or be `nothing`. Lean already has this type built in, so let's call our type `Opt` like so. Although the real `Option` is polymorphic over universes, let's keep our version simple.

```lean ctx
inductive Opt (α : Type) : Type where
| some (_value : α) : Opt α
| nothing : Opt α

#check (Opt : Type → Type)

#check Opt.some
-- Opt.some {α : Type} (value : α) : Opt α

#check Opt.nothing
-- Opt.nothing {α : Type} : Opt α

#check Eq.rec
```

Notice that we are introducing two new concepts: First, we are now defining an inductive family where we define a new inductive type `Opt α` for every type `α`. Here, since everything exists within our type theory, you can think of `Opt` as quite literally a function from `Type → Type`, just like `List`.

Second, we have a constructor that is taking in a parameter! Instead of just being a constant, a `some` option also holds some data. This will be familiar if you have used Rust's enums, and in C this is similar to a `union` of `struct`s. These two constructors implicitly quantify over types to handle `Option α` for any type `α`, and in the case of `some`, we also take an additional parameter for the inner value of the option. Again, these constructors are literally just irreducible, opaque functions that return an `Opt α`, and they are the only ways to make a `Opt α`.

Ok, let's take a look at some code for how we would use `Opt`:

```lean ctx
def greet (name : Opt String) : String :=
  match name with
  | .some n => "curse you, " ++ n
  | .nothing => "nobody is attacking me!"

#eval greet Opt.nothing
-- "nobody is attacking me!"

#eval greet (Opt.some "Odysseus")
-- "curse you, Odysseus"
```

Notice how we can access the inner value of the `some` in our `match` expression! Also, as a side note, notice that we never really have to give a name to this inner value, so in fact we could have written this:
```lean ctx2
inductive Opt (α : Type) : Type where
| some : α → Opt α
| nothing : Opt α
```
This is just a different spelling of the same thing, but it is slightly more cryptic. As you can see though, the linter does want us to spell it this way, so iggb.

Anyways, let's take a look at how the recursor works:

```lean ctx2
#check Opt.rec
-- Opt.rec.{u} {α : Type} {motive : Opt α → Sort u} (some : (a : α) → motive (Opt.some a)) (nothing : motive Opt.nothing)
--  (t : Opt α) : motive t
```

This is almost the exact same as we saw with our `Weekday` type, except that `some` case has more information: the value we return for the `some` case is allowed to depend on the inner value! We give the recursor a function instead of a constant value to return. Again, we can write `greet` in terms of the raw recursor:

```lean ctx2
noncomputable def greet (name : Opt String) : String :=
  @Opt.rec String (fun _ => String) (fun n => "curse you, " ++ n) "nobody is attacking me!" name
```

Ok, so far this seems very boring, but even with just sets of `n` elements like are `Weekday` example, there is already some very unintuitive behavior! If we consider the analogy of inductive types being sets, there are two very important sets that we should pay attention to: the empty set, a set with zero elements, and the singleton set, a set with exaclty one element.

```lean ctx
inductive EmptySet where

inductive SingletonSet where
| elem : SingletonSet
```

Yes, defining an inductive type with zero constructors is totally legal! In Rust, this `EmptySet` type is called `Never` and spelled with an exclamation point (`!`). The `SingletonSet` type here is called `Unit`, and can be thought of as the type of empty tuples. In the language of category theory, these two types are special because they are the initial and terminal objects of our category. Namely, with these two types, we can define these two very special functions:

```lean ctx
def intoSingleton {α : Type} : α → SingletonSet :=
  fun _ => SingletonSet.elem

def fromEmpty {α : Type} : EmptySet → α :=
  fun x => nomatch x
```

Let's look at `SingletonSet` first. For every type `α`, we can define a function `intoSingleton` that maps `α` to `SingletonSet`. This function ignores its input and always just returns the single element of the singleton set, and this function is the only possible function you can define from `α` to `SingletonSet`.

Also worth mentioning is another important property that this `SingletonSet` has. Notice that functions `SingletonSet → α` necessarily must be constant functions, as there is only one possible input they can take and thus only one possible value they can output. In other words, these functions correspond one-to-one with terms of the type `α`.

```lean ctx
def fromSingleton {α : Type} (a : α) : SingletonSet → α :=
  fun x => match x with
    | .elem => a
```

This property is exactly encoded in the type of the `SingletonSet`'s recursor:

```lean ctx
#check SingletonSet.rec
-- SingletonSet.rec.{u} {motive : SingletonSet → Sort u} (elem : motive SingletonSet.elem) (t : SingletonSet) : motive t

noncomputable def fromSingletonV2 {α : Type} (a : α) : SingletonSet → α :=
  SingletonSet.rec a
```

Conversely we can also look at the `EmptySet`, which is dual to the `SingletonSet`. For every type `α`, you can define a unique function from `EmptySet` to `α` by pattern matching on the input `x : EmptySet`. Since `EmptySet` is a type with no constructors, our `match` statement on `x` has no cases at all, and in Lean we write this as `nomatch`. In fact, this `fromEmpty` function we have written is exactly the same as the `EmptySet` type's recursor!

```lean ctx
#check EmptySet.rec
-- EmptySet.rec.{u} (motive : EmptySet → Sort u) (t : EmptySet) : motive t

noncomputable def fromEmptyV2 {α : Type} : EmptySet → α :=
  EmptySet.rec
```

This is very strange. We have created a value of type `α` out of thin air, without writing any code at all. All this weirdness comes from the fact that we are defining a function on the empty set.

Here, remember this (`x : EmptySet`) can be implicitly read as `x` is an element of the empty set, which seems like a logical impossibility but is actually perfectly valid. Remember the context: we are defining a function. In the body of the function, we are working under the assumption that someone passed to us some element `x : EmptySet`, but since this `x` got passed to us from the outside, the act of using it to define this function is still perfectly fine.

But this discussion does hint at something pretty important: it will be utterly _impossible_ to actually call this function! There are no constructors for `EmptySet`, so you can never actually make a term `el : EmptySet`, so you can never actually call `fromEmpty el`. This is why Rust calls this type `Never`.

Even though this function can never be called, it is still a real function. In fact, it is the _only_ possible function that you can define from `EmptySet` to `α` for any type `α`.

Formally, a function $`f : X → Y` can be thought of as simply a set of (input, output) pairs ($`f ⊆ X × Y`). For example, consider these functions and the sets that they correspond to:

`toString : Int → String`
$$`\{..., (-2, "-2"), (-1, "-1"), (0, "0"), (1, "1"), ...\}`
...

The first part of every pair in the set is from `X` and the second part is from `Y`. It must be a well defined total function, so every element `x ∈ X` must appear in exactly one pair in `f`.

Now consider the case that `X` is the empty set. Then, we would need $`f : ∅ → Y` to be a set of pairs, where the first of each pair is from the empty set and the second is from `Y` ($`f ⊆ ∅ × Y`). Since the empty set is empty, there is only one such possible set of pairs: the empty set ($`f ⊆ ∅ × Y = ∅ \implies f = ∅`). `f` is an empty relation, and it is unique-- the only way to define a function from `∅` to `Y`.

As you can see, in this view we have completely avoided the need to choose an element of `Y` in order to define our function, and one can think of the `nomatch` in Lean as doing the same thing. We are taking advantage of the properties of the empty sets to vacously construct our function: In math, it would be perfectly valid to say that "for all numbers X in the empty set, X is prime and X is equal to 4". In Lean, it is perfectly valid for our function `fromEmpty` to say "for all terms of type `EmptySet`, I can give you a term of type `α`".

In fact, this analogy is the basis for mathematics in Lean! We can think of the `SingletonSet` as encoding 'True' and the `EmptySet` as encoding 'False'. Types correspond to propositions, and terms of the type correspond to proofs of the proposition: 'True' always has a trivial proof, but 'False' has no possible proof. This is called the Curry-Howard correspondence, where every proposition corresponds to some type. If a proposition is provable, then we should be able to construct a term of its corresponding type, and we say that the type is _inhabited_. Otherwise, if the proposition is false, there should be no possible proof and thus no term of that type, and the type is the _uninhabited_ empty type.

Now, it is finally time to revist the `Prop` universe that we skipped over earlier. Every mathematical proposition lives in this type universe, and it lives at the bottom of the type universe heirarchy. `Prop` can also be written as `Sort 0` or just `Sort`.

```lean ctx
#check Prop    -- Prop : Type
#check Sort 0  -- Prop : Type
```

As I have mentioned, `Prop` does not follow the normal rules for type universes. This is because lean has a feature called _proof irrelevance_ that causes some weirdness, but I will talk more about that later. For now, just know that Lean considers two proofs of the same proposition as literally the same object, even if these two proofs were constructed in completely different ways. This has the effect of essentially forcing every type in the `Prop` universe to be either be empty like `EmptySet` or contain exactly one term like `SingletonSet`. This makes proofs easier to reason about, as ultimately we really only need to track if a proposition has a proof, not _how_ it was proved.

Again, it requires some finesse to avoid having this lead to logical paradoxes, but we'll cover those issues as they arise. First, let's see how to express some basic logical statements as types.

```lean ctx
inductive MyTrue : Prop where
| mk : MyTrue

inductive MyFalse : Prop where

inductive MyAnd (P : Prop) (Q : Prop) : Prop where
| intro (_proofOfP : P) (_proofOfQ : Q) : MyAnd P Q

inductive MyOr (P : Prop) (Q : Prop) : Prop where
| inl (_proofOfP : P) : MyOr P Q
| inr (_proofOfQ : Q) : MyOr P Q
```

We see that `MyTrue` and `MyFalse` is the same thing as our `SingletonSet` and `EmptySet` that we just saw. Then, we see that we can define our logical connectives, `And` and `Or`: our `And` type has one constructor.

```
MyAnd.intro : P → Q → MyAnd P Q
```

It takes in both a proof of P and a proof of Q, and it constructs a proof of `P ∧ Q`. This makes sense-- to prove `P ∧ Q`, you must separately prove both `P` and `Q`.

Similarly, our `Or` type has two constructors, `inl` for 'in from the left' and `inr` for 'in from the right'.

```
MyOr.inl : P → MyOr P Q
MyOr.inr : Q → MyOr P Q
```

To prove `P ∨ Q`, you can either prove `P` or prove `Q`. Thus, a proof of `P ∨ Q` is either just a proof of `P` or a proof of `Q`. This means that the type `P ∨ Q` is inhabited if either `P` is inhabited or `Q` is inhabited.

If you're familiar with algebraic datatypes, you will recognize that `And` is just the algebraic product type, and `Or` is just the algebraic sum type! `And` is simply a `struct` or a tuple, and `Or` is simply a Rust `enum` or a C `union`. In the language of sets, `And` is the cartesian product, and `Or` is the disjoint union or 'direct sum'. And this analogy with sets works very well: if you take the cartesian product of any set with an empty set, you always get an empty set back. And if you take the disjoint union of any nonempty set with any set whatsoever, you will get another nonempty set.

Ok then, next up is 'implies'! Remember that 'P implies Q' just means that 'if P is true, then Q is also true'. Let's begin by reviewing the truth table for 'implies':

```
| P | Q | P → Q |
| - * - * ----- |
| F | F | T     |
| F | T | T     |
| T | F | F     |
| T | T | T     |
```

This truth table asks the question 'if P and Q take on these specific values, would it be true that P implies Q?'. For example, take the concrete example where 'P' is 'John is drinking alcohol' and 'Q' is 'John is over 21'.

First off, if P is false, then 'P implies Q' would be vacously true, since the condition for it to mean anything has not been met. Our rule that 'if P then Q' does not come into effect if P is not true in the first place! If John is not drinking alcohol, we don't care how old he is!

On the other hand, if P is true and Q is also true, the our rule that "if P then Q" is obviously working. This corresponds to _modus ponens_, and it is intuitively the normal way one would apply the rule. If John is drinking alcohol and over 21, everything checks out.

Finally, the only row where `P → Q` is false is the case where P is true, but Q is not true. This case is a direct counterexample to our rule that "if P, then Q", and it is related to _modus tollens_, or the contrapositive of the statement. If John is drinking alcohol but is not over 21, there's some underage drinking happening! Thus, if John is not over 21, he should not be drinking alcohol.

With this truth table in mind, here's how you would encode this as a type: the logical statement 'P implies Q' corresponds to type of functions from P → Q!

```lean ctx
axiom JohnIsDrinkingAlcohol : Prop
axiom JohnIsOver21 : Prop

-- `theorem` is just the same as `def` but for
-- functions that return a type in `Prop`.
theorem no_underage_drinking (h : JohnIsDrinkingAlcohol) : JohnIsOver21 := sorry

#check @no_underage_drinking
-- no_underage_drinking : JohnIsDrinkingAlcohol → JohnIsOver21
```

To prove that `P` implies `Q`, one needs to provide a function that takes in a proof of `P` and returns a proof of `Q`. Our function `no_underage_drinking` takes in a proof `h` that `JohnIsDrinkingAlcohol` and uses it to construct a proof that `JohnIsOver21`, thereby proving the theorem that "if john is drinking alcohol, then john is over 21".

Before we go over how this correctly implements the truth table for 'implies', let's go over the new Lean concepts that we introduced here: `theorem`, `axiom`, and `sorry`.

`theorem` is basically the same thing as `def`, except you are forced to ultimately return a proof of some `Prop`, meaning you are not allowed to return a value whose type lives in any other universe. Note that the type of `no_underage_drinking` itself is a `Prop`, namely `JohnIsDrinkingAlcohol → JohnIsOver21 : Prop` since `JohnIsDrinkingAlcohol : Prop` and `JohnIsOver21 : Prop`. This is the same behavior that we would expect from any type universe, for example `Int : Type` and `String : Type`, so the function type `Int → String : Type`.

Next, `axiom` simply introduces a new term of any type into the current context. Because proofs of a proposition are simply terms of the corresponding type, assuming a proposition as an axiom is the same as magically having some term of that type. Counterintuitively, `axiom` can also be used to create terms of types that are not propositions, like we are doing here. In that case, we just have an opaque, irreducible term of that type.

Finally, `sorry` is just a way to tell lean that we don't have a proof of this theorem yet, but just to assume it is true and continue anyways. Under the hood, `sorry` is just calling a built-in Lean axiom called `sorryAx` that lets you magically construct a term of literally any type `α`, even if `α` is an empty type like `EmptySet`.

```lean ctx
#check sorryAx
-- sorryAx.{u} (α : Sort u) (synthetic : Bool) : α
```

The bool parameter there is just some internal bookkeeping used by Lean. Of course, it would not be valid to use `sorryAx` in real proofs, and Lean will naturally track if you have used `sorryAx` at any point in constructing your theorem: we see here that Lean knows about all the axioms that went into constructing `no_underage_drinking`.

```lean ctx
#print axioms no_underage_drinking
-- 'no_underage_drinking' depends on axioms: [JohnIsDrinkingAlcohol, JohnIsOver21, sorryAx]
```

Anyways, let's get back to the truth table for 'implies'. Notice that the first two rows actually correspond to the `fromEmpty` function we saw before: we are always able to construct a function that takes in a proof of a false proposition and returns a proof of any proposition whatsoever. This means that for any proposition Q, we always have a proof that 'False implies Q'!

```lean ctx
theorem fromFalse (Q : Prop) : MyFalse → Q :=
  fun x => nomatch x

-- or, alternatively:
theorem fromFalseV2 (Q : Prop) : MyFalse → Q :=
  MyFalse.rec
```

Notice the similarity between `fromFalse` and `sorryAx`. Essentially, having a valid proof of `False` is the same thing as having `sorryAx`!

In this context, the weird behavior of the empty set's recursor corresponds to the _principle of explosion_ in logic, where once you have a proof of a false statement, you can prove anything at all. _ex falso quodlibet_.

<REWRITE>
Anyways, let's look at the next row of the truth table. For two true propositions `P` and `Q`, one is able to construct a function that maps the proof of `P` to the proof of `Q`, thereby proving that `P` implies `Q`. Remember that `P` and `Q` would essentially be the `SingletonSet` type, meaning they have one term because of proof irrelevance.

On the other hand, it would be impossible to construct a function that maps a proof of a true proposition to a false proposition: this function must construct a term of an empty type, which is impossible if you do not already have a term of an empty type. Thus, it will be impossible to prove that `True` implies `False`.

Additionally, this construction also allows us to encode the negation of a proposition as a type. Look at the truth table, and focus on the rows where `Q` is false. In this case, 'P implies Q' is exactly 'not P'! So, we simply encode `¬P` as the function type `P → False`, and to prove `¬P` we simply prove that assuming `P` leads to a contradiction.

Now that about covers it for 'implies', which are regular old function types. But what about _dependent_ function types? It turns out, you end up with 'for all', and here is where the `Prop` universe's weirdness begins to show a little bit.

<REWRITE THIS PART TO BE CLEARER, PROBABY MOVE UP THE EXAMPLE>
```lean ctx
def ForAll {X : Type} (P : X → Prop) : Prop :=
  (x : X) → P x
```

Essentially, to prove that 'for all x, P(x) is true', you just write a function that takes in any arbitrary 'x' and returns a proof of 'P(x)'. Here, you are taking advantage of lean being dependently typed, as the type of the return value depends on the value of the input to the function! Recall back to our example of using motives with the `Weekday` inductive type. <show code here>. In this new example, 'P' would be our motive. For now, I'm going to keep things abstract, but we will look at an example later, after we have covered all the basic constructions we need to start doing real math.

But first, let me point out that these 'for all' propositions are breaking the rules a little bit! This function type (`(x : X) → P x`) lives in `Prop`, but `X` lives in `Type`. How is that possible? Remember what I said about normal type universes? <quote here>

Normally, we would expect the universe level of `α → β` to be the maximum of the universe levels that `α` and `β` belong to!

For example, consider the function `Nat → Type`. This could be the type of a function like `ArrayN` for instance, a function that takes in a number `n` and gives you the type of arrays of a fixed length `n`. Then, since `Nat : Type` and `Type : Type 1`, we have that `Nat → Type : Type 1`, the maximum of the two. But the `Prop` universe is not following this rule!

We have `(x : X) → P x : Prop`, but `X : Type` and `P x : Prop`, and `Type` is a bigger universe than `Prop` as `Prop : Type`. Normally, this would mean that `(x : X) → P x : Type`, but the `Prop` universe is special. If your function ultimately returns a value whose type is in the `Prop` universe, that function type is also in the `Prop` universe. This means that the function types corresponding to 'for all' statements remain in the `Prop` universe, as desired. This is exactly why the `imax` function on universe levels is defined in such a weird way, where if the second parameter is `0` you return `0`. Remember that `Sort 0` is `Prop`, so this definition allows you to write the following code cleanly:

```lean ctx
universe u v

variable (X : Sort u) (Y : Sort v)

#check X → Y  -- X → Y : Sort (imax u v)
```

If you are curious for more details, you can look into the chapter on universe levels in 'Theorem Proving in Lean4'. But take a look at this example and notice how this mechanism enables the 'for all' proposition's propensity to propogate its `Prop`ness upwards:

```lean ctx
section

variable (IsSpecial : String → Int → Prop)
variable (s : String)

#check (n : Int) → IsSpecial s n
-- ∀ (n : Int), IsSpecial s n : Prop

#check (s : String) → (n : Int) → IsSpecial s n
-- ∀ (s : String) (n : Int), IsSpecial s n : Prop
end
```

Remember that `→` is right-associative, so first lets look at the function on the right hand side. We see that given some string `s`, this function type `(n : Int) → IsSpecial s n` is a proposition that 'for all integers n, s and n are special'. Even though the type of the first argument lives in `Type`, the type of the return value lives in `Prop`, so this function type lives in `Prop`. Then, our overall type can be interpreted as a function type that takes in a `String` and returns a value of this function type, which as we have just established, lives in `Prop`. This, overall we have a function `String`, which is a `Type`, to `Int → P s n`, which is a `Prop`, so the overall type is also still a `Prop`. We have propogated the `Prop`ness of `IsSpecial s n` all the way up to the entire function type! This is the type of a function that takes in a string `s` and an integer `n` and ultimately returns a proof that `s` and `n` are special, and this function itself is a proof that 'for all s and n, s and n are special'.

Ok, admittedly that was a pretty confusing example, but the overall point is just that even if your function takes multiple arguments, your function type will still be a `Prop` corresponding to a 'for all' if you ultimately return a type that lives in `Prop` at the end.





So, hopefully you are getting the hang of these simple inductive types, but there is still so much more to cover!
All of the data types we have seen so far have not been recursive, and recursion is really the core of what inductive types are for! I think we are finally ready to tackle the `List` type, and this time I will make it polymorphic over universes. This will code will be exactly the same as how the real `List` type is implemented in Lean:

```lean ctx
inductive MyList (α : Type u) : Type u where
| empty : MyList α
| cons : α → MyList α → MyList α

#check MyList.cons
-- MyList.cons.{u} {α : Type u} : α → MyList α → MyList α

-- this is the list [1, 2, 3]
def oneTwoThree : MyList Int :=
  MyList.cons 1 (MyList.cons 2 (MyList.cons 3 MyList.empty))
```

If you have taken an intro to computer science class, you will recognize what we have written here as a linked list! Every list is either the empty list (`MyList.empty`), or it contains some first element along with a (possibly empty) list of the remaining elements. Just like with regular lists, we can use `match`'s pattern matching to define recursive functions-- for example, we can write a function that appends an element to the end of the list:

```lean ctx
def appendAtEnd {α : Type u} (ls : MyList α) (a : α) : MyList α :=
  match ls with
  | .empty => MyList.cons a MyList.empty
  | .cons x xs => MyList.cons x (appendAtEnd xs a)

#eval appendAtEnd oneTwoThree 4
-- MyList.cons 1 (MyList.cons 2 (MyList.cons 3 (MyList.cons 4 (MyList.empty))))
```

Here, if we want to append `a` to the end of an empty list, we can just return a new list with a single element. Otherwise, we can recurse down into the list: mentally we take out the first element `x` and then use a recursive call to append `a` to the list of reamining elements `xs`.

Note that this code is extremely similar to what we were able to write with Lean's built in lists in `reverseList`. It is almost one-to-one, accounting for the fact that the functions are doing two slightly different things. One of the only differences is that the built in `List` has nicer notation, where we can write the `.empty` constructor as simply `[]`, and we can write `x::xs` instead of `.cons x xs`. We can also write `[1, 2, 3]` instead of repeatedly calling the constructor `MyList.cons`. All of this, however, are just custom notation and macros, and it just expands out to the same thing. That's right, you can define custom infix notations and macros in Lean itself, and if you ctrl/command click in VsCode, you can actually just read the Lean code that implements these syntaxes! Even things like `match` expressions and the `+` operator are defined in Lean itself.

```
-- `+` gets translated to a call to the `hAdd` function.
-- this actually uses typeclasses, which is a feature we haven't covered yet.
@[inherit_doc] infixl:65 " + "   => HAdd.hAdd

-- macro for the [1, 2, 3] list syntax
macro_rules
  | `([ $elems,* ]) => do
    -- NOTE: we do not have `TSepArray.getElems` yet at this point
    let rec expandListLit (i : Nat) (skip : Bool) (result : TSyntax `term) : MacroM Syntax := do
      match i, skip with
      | 0,   _     => pure result
      | i+1, true  => expandListLit i false result
      | i+1, false => expandListLit i true  (← ``(List.cons $(⟨elems.elemsAndSeps.get!Internal i⟩) $result))
    let size := elems.elemsAndSeps.size
    if size < 64 then
      expandListLit size (size % 2 == 0) (← ``(List.nil))
    else
      `(%[ $elems,* | List.nil ])
```

These features are obviously very cool and very useful, but just as obviously it's beyond the scope of this video.

Anyways, back to inductive types. Let's see how the List type's recursor works:

```lean ctx
#check MyList.rec
-- MyList.rec.{u_1, u} {α : Type u} {motive : MyList α → Sort u_1} (empty : motive MyList.empty)
--  (cons : (a : α) → (a_1 : MyList α) → motive a_1 → motive (MyList.cons a a_1)) (t : MyList α) : motive t
```

TODO TODO TODO

structural recursion

variables
```lean ctx
variable {α : Type u}
```
actually this is not necessary, but they are useful if you want an argument that is not a just type.

```lean ctx
noncomputable def appendAtEndV2 (ls : MyList α) (a : α) : MyList α :=
  @MyList.rec α (fun _ => MyList α) (MyList.cons a MyList.empty)
    (fun x _xs append_of_xs => MyList.cons x append_of_xs) ls

#check appendAtEndV2
-- appendAtEndV2.{u} {α : Type u} (ls : MyList α) (a : α) : MyList α
```

proof of termination: `WellFounded.fix`
- induction implies complete induction
- everything gets rephrased into a structural recursion

partial functions. kinda like the opposite of noncomputable.


```lean ctx
inductive NatNum : Type where
| zero : NatNum
| succ : NatNum → NatNum
```

TODO TODO


```lean ctx2
inductive Equals {α : Type} (a : α) : α → Type where
| refl : Equals a a

#print Equals.rec
```
