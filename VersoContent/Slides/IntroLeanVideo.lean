import VersoSlides
import Verso.Doc.Concrete

open VersoSlides

set_option verso.code.warnLineLength 500

#doc (Slides) "Intro to Lean and Verso" =>

# Introduction

This video covers Lean's type system, focusing on type theory and inductive types.

- *Audience:* Familiar with programming and basic proofs.
- *Goal:* Understand how Lean code becomes lambda terms and how the Lean kernel typechecks them.

:::notes
Lean has been popular lately, often associated with AI. However, this video will focus purely on Lean's core concepts. The goal is to show that type theory—especially inductive types—is fundamentally elegant.

We'll start with basics (similar to "Theorem proving in Lean 4") and then dive deep into how Lean works under the hood. Understanding how code maps to lambda terms helps you write code that is logically correct, not just technically functional.
:::

# Basic Types and Terms

The first step is setting up Lean, typically using VSCode with the Lean4 extension.

Let's start with defining a symbol:

```lean -show
```

```lean
-- this is a comment in lean.
def hello : String := "world"
--   ^ !click
```

:::notes
The `:=` operator assigns a definition, while `:` annotates a type.
`hello` is definitionally equal to `"world"`, making it a term of type `String`.
A "term of a type" is conceptually similar to an "element of a set".

Functions work similarly, but take arguments. Take `addFive` for example.
:::


# Functions

```lean
def addFive (x : Int) : Int :=
--   ^ !click

  x + 5
```

:::notes

We can use `#check` to see the type of an expression, and we can use `#eval` to evaluate them. Like many functional programming languages, we can call a function by juxtaposing the function and its argument, so we do not have to use any parenthesis.

:::


# Currying

```lean -panel -stretch
-- !fragment
#check addFive 0
-- !fragment
#eval addFive 0
-- !fragment
#eval addFive 2
-- !fragment
#check (addFive : Int → Int)
```

:::notes

Notice that here we can explicitly annotate the expression `addFive` with the type that we expect it to have. This syntax can be a bit confusing, but we'll just have to deal with it.

We can also see that Lean is using this weird unicode arrow to denote the function type, and this use of unicode will be somewhat of a recurring theme. You can also type this symbol with the latex `\to` in the vscode editor, and it works similarly for other special characters. You can also hover over these characters for documentation about what they are and how to type them.

Anyways, notice how `addFive` has a type of `Int → Int`, meaning it is a function that takes in an integer and returns another integer. We can also have functions that take in multiple arguments, and since Lean is a functional programming language, we do this by  currying  the arguments. For example, let's define this function that takes in an integer and a string, and it returns a new string with a nice little message:

:::


# Partial Application

```lean -panel -stretch
def importantMessage (x : Int) (name : String) : String :=
--   ^ !click
  name ++ "'s favorite number is " ++ toString x
-- !fragment
#check importantMessage
-- !fragment
#eval importantMessage 5 "Joe"
```

:::notes

Then, currying lets us handle partial function applications like so: (`\mathrm(Hom)(X ⨂ Y, Z) ≅ \mathrm(Hom)(X, \mathrm(Hom)(Y, Z))`)
:::


# Lambda Expressions

```lean -panel -stretch
-- !fragment
#check importantMessage 5
-- !fragment
#check importantMessage 5 "Joe"
-- !fragment
#eval importantMessage 5 "Joe"
```

:::notes

What's happening here is that `importantMessage` literally takes in a `Int` and returns a  function  `String → String`. If we were write it out explicitly in terms of lambda expressions, this is really what's going on:

:::


# Associativity

```lean -show
```

```lean -panel -stretch
def importantMessage₂ : Int → (String → String) :=
  fun x => (fun name =>
    name ++ "'s favorite number is " ++ toString x)
```

:::notes

This works very nicely because the arrow `→` is right-associative, so implicitly there are these parenthesis here.

:::


# Left Associativity

```lean -panel -stretch
-- !fragment
#check (importantMessage₂ : Int → String → String)
#check (importantMessage₂ : Int → (String → String))
```

:::notes

Additionally, function application is left-associative, so writing in the parentheses again, this is what's really happening:

:::


# Generics

```lean -panel -stretch
-- !fragment
#eval importantMessage₂ 5 "Joe"
-- !fragment
#eval (importantMessage₂ 5) "Joe"
```

:::notes
We are literally passing `5` into `importantMessage₂` to get a function from `String → String`, and then we pass in `"Joe"` to this new function.

This is something that took some time to get used to when I was first getting into functional programming. Because you dont write any parentheses, its very easy to forget that function application is left-associative and has a very high operator precedence, so I found myself often writing the wrong thing in more complicated expressions.

Alright, so far so good. But now for something pretty cool-- how does lean handle generics and templates? In C++ we might say `std::vectorint` or `std::vectorstd::string`, and in Java we might say `ArrayListInteger` or `ArrayListString`. In Lean, we can do the same thing, and instead of being a bespoke language feature, generics are just normal functions!

:::


# Type of Types

```lean -panel -stretch
def myList : List Int := [1, 2, 3, 4, 5]
def otherList : List String := ["hello", "goodbye"]
```

:::notes

`List` is quite literally a normal function, just like `addFive`, except instead of acting on integers, it acts on `Type`s:

:::


# Type of Primitives

```lean -panel -stretch
-- !fragment
#check (List : Type → Type)
```

:::notes

It's a function that takes in some type, and returns a new type, the type of Lists of that type! Anyways, monoid in the category of endofunctions, but the main point is that  types  have a type.

:::


# Dependent Types

```lean -panel -stretch
-- !fragment
#check (String : Type)
#check (Int : Type)
#check (List Int : Type)
```

:::notes

And since types can behave just like normal objects in Lean, we can leverage the fact that Lean is  dependently typed  to write our own custom generic functions like so:

:::


# Implicit Parameters

```lean -panel -stretch
def reverseList (α : Type) (ls : List α) : List α :=
  match ls with
  | [] => []
  | x::xs => (reverseList α xs) ++ [x]
-- !fragment
#eval reverseList Int [1, 2, 3]
-- !fragment
#eval reverseList String ["hello", "goodbye"]
```

:::notes

Here, `reverseList` is a generic function that takes in a list of any type and reverses it. It is defined recursively: if the input list `ls` is empty, we return the empty list. Otherwise, `ls` must have some first element `x` together with a (possibly empty) list of remaining elements `xs`. The pattern matching here just reveals this structure. Then, we use recursion to reverse the remaining elements, and we add the first element `x` to the end.

We can see that `reverseList` is literally just a normal function that takes in two arguments: a `Type` `α` and then a list `ls` of type `List α`. Notice how the  type  of the second argument depends on the  value  of the first argument! This is what makes Lean  dependently typed , and this feature is what allows mathematics to be expressed nicely in Lean. In general, we can use the  value  of any previous argument when specifying the  type  of our arguments.

Ok, this is already very nice, but we can actually do better. Instead of taking in the type as an explicit parameter, we can just make the parameter implicit and let Lean's elaborator figure it out for us. We just replace the normal parentheses with curly braces:

:::


# Explicit Parameters

```lean -panel -stretch
def reverseList₂ {α : Type} (ls : List α) : List α :=
  match ls with
  | [] => []
  | x::xs => (reverseList₂ xs) ++ [x]
-- !fragment
#eval reverseList₂ [1, 2, 3]
-- !fragment
#eval reverseList₂ ["hello", "goodbye"]
```

:::notes

Because `α` can be inferred from the type of `ls`, oftentimes we dont actually need to tell Lean what `α` is! Again, the elaborator just handles the boring boilerplate for us. If we ever need to access the implicit parameter explicitly, we can just prefix the name with an `@` to make the implicit parameters explicit again:

:::


# Type Universes

```lean -panel -stretch
-- !fragment
#check @reverseList₂ Int
-- !fragment
#eval @reverseList₂ Int [1, 2, 3]
```

:::notes

But we don't have to stop here. If `String`, `Int`, and `List Int` all have a type, does `Type` itself have a type? Yes, it does! But we have to be careful-- if we were to have `Type` be a term of itself (`Type : Type`) we can create logical paradoxes. The famous example is Russel's paradox, where it is impossible to tell if the set of all sets that do not contain themselves contains itself:

`
\begin(align*)
S = \(X ∈ \mathbf(Set) \mid X \not\in X \) \\
S ∈ S \implies S \not\in S \implies S ∈ S \implies \dots
\end(align*)
`

The definition of `S` means that `X` is in `S` if and only if `X` does not contain itself. So if it were true that `S` is in `S`, this means that in fact `S` is not in `S`. But then, the definition of `S` again tells us that since `S` does not contain itself, `S ∈ S`, and we have a contradiction that will keep looping forever.

The type-theoretic version of this is called Girard's Paradox. In the case of Russel, the paradox arises because we quantified over the set of all sets, which has the property that it contains itself (`\mathbf(Set) ∈ \mathbf(Set)`). Similarly, if we have that `Type` is a term of `Type` (`Type : Type`), this basically makes `Type` the type of all types and results in Girard's paradox.

To get ourselves out of this pickle, we must invent a heirarchy of universes! If `Type` can't be a `Type`, why don't we just say it has the type of a "meta-type", and what if this "meta-type" has the type of a "meta-meta-type", and so on? This is exactly what lean does: `Type` has a type of `Type 1`, then `Type 1` has a type of `Type 2` and so on. These things are called type universes, and every type universe is always contained in a bigger one.

:::


# Function Types in Universes

```lean -panel -stretch
-- `Type` is the same thing as `Type 0`.
-- !fragment
#check Type
-- !fragment
#check Type 1
-- !fragment
#check Type 2
```

:::notes

This also applies to function types, like `Type → Type` (which is the type of `List`). We just consider the 'biggest' universe level that appears and add one to get a bigger universe that can safely contain it:

:::


# Universe Misconceptions

```lean -panel -stretch
-- !fragment
#check Type → Type
-- !fragment
#check Type → Type 1
-- !fragment
#check Type 2 → Type
```

:::notes

Another way of looking at this is that if we have two terms `X` and `Y` in some type universe `Type u` (`X Y : Type u`), then we can make a new term of the same type universe by considering the function type `X → Y : Type u`. In some sense, you can consider that the type of the right arrow is something like `→ : Type u → Type u → Type u`. For example, `Int` is in `Type`, and so `Int → Int` is also in `Type`. Similarly, `Type` is in `Type 1`, so `Type → Type` is also in `Type 1`.

Hold on here, because this is pretty confusing. One might be tempted to think that `List : Type 1`, but that is wrong! Remember that `List` has type `Type → Type`, and it is `Type → Type` itself that is of type `Type 1`.

:::


# Universe Polymorphism

```lean -panel -stretch
-- !fragment
#check (List : Type → Type)
#check (Type → Type : Type 1)
```

:::notes

And there is more: While we could consider `List` as a literal function from `Type` to `Type`, here we explicitly do NOT think of `Type` as a function from the naturals to `Type ∞` or something like that. Not only does `Type ∞` not exist, the numbering of 1, 2, 3 are not the same as the integers `Int` or the natural numbers `Nat` in Lean-- they are completely unrelated, and they are not objects inside of Lean's type theory at all. They exist on the level of the  metatheory , and we just happen to write `Type 1` and `Type 2` because it is a convenient notation. We just as well could have called this heirarchy `UniverseOne : UniverseTwo` and `UniverseTwo : UniverseThree` and so on.

Anyways, what's the point of all this? So far this might all seem like a load of very confusing abstract nonsense, but it is  cool  abstract nonsense. See, I lied a little when I said that `List` was a function from `Type` to `Type`. In fact, `List` is an infinite family of functions: for every universe level `u`, there is a function `List.(u)` from `Type u` to `Type u`! This is something called  universe polymorphism .

:::


# Polymorphism Examples

```lean -panel -stretch
-- !fragment
#check List
```

:::notes

Again, I want to emphasize that the universe levels 1,2,3 do not exist  within  Lean's type theory, but in fact are part of the metatheory. This means that in the syntax of `List.(u)`, the `u` is not actually a parameter into a function, but is a variable at the level of the metatheory. We have to consider `List.(u)` as literally an infinite family of functions, NOT as a function that takes a universe level `u` and gives you a function from `Type u` to `Type u`, however tempting that might be.

A few more examples to see how the universe levels keep stepping up:

:::


# ULift

```lean -panel -stretch
-- !fragment
#check List Type
-- !fragment
#check List (Type 1)
-- !fragment
#check List (Type 2)
```

:::notes

explanation Note that `List` takes a `Type u` returns another `Type u` and not a `Type`-- a type that lives in a smaller universe cannot contain things from a bigger universe!

On a somewhat unrelated note, another detail about universes that I want to highlight is that universe levels in Lean are not cumulative. This means that if `X : Sort u` and `Sort u : Sort v`, then it is not true that `X : Sort v`. If you read academic papers about type theory or use another proof assistant like Rocq/Coq, you will find that they often take this approach. Lean chooses to avoid this, as this makes type checking easier and allows the Lean kernel to be simpler. Part of the Lean philosphy is to make the kernel as simple as possible, as the kernel is what garauntees the correctness of your proofs.

Also, the fact that universes are not cumulative is not a problem at all: you can define a function `ULift.(u,v)` that lifts values from one universe to a higher one:
:::


# Universe Examples

```lean -panel -stretch
-- !fragment
#check ULift
```

:::notes
This means that you can write anything that you might want to write if universes were cumulative, the only caveat being that you have to explicitly convert between universe levels with this `ULift` function. At the cost of some extra boilerplate, the typechecking algorithm can be simplified! This `ULift` function is also not anything special, and it is actually just another example of something called an  inductive type , which is a category that includes types like `String` and `Int`.

Anyways, the heirarchy of universes means that we can do fun things like make lists of types and such:

:::


# Polymorphic Functions

```lean -show
```

```lean -panel -stretch
def funTypes : List Type :=
  [Nat, String, List String]

def monads : List (Type → Type) :=
  [List, Option, fun T => Nat → T]

def funnerTypes : List (Type 1) :=
  [Type, Type → Type, List Type, List (Type → Type)]
```

:::notes

explanation

Of course, we can also make our `reverseList₂` function polymorphic over universes too:

:::


# Inductive Types

```lean -panel -stretch
def reverseList₃.{u} {α : Type u} (ls : List α) : List α :=
  match ls with
  | [] => []
  | x::xs => (reverseList₃ xs) ++ [x]
-- !fragment
#check reverseList₃ monads
```

:::notes

Unfortunately, we haven't told Lean how to print out Lists of functions on Types, so we can't see the value of the list, but trust me bro-- it worked!

That's about it for universes for now, though there is one other special universe that we haven't covered yet, `Prop`, the universe of Propositions. However, it's an exception to the general rule, and we'll cover it once we start proving mathematical theorems.

Now, let's take a step back. We've just seen how type universes like `Type u` work, and we've also seen how to define, type-check, and evaluate dependently-typed functions like `reverseList₃`. It turns out that these are already two of the three categories of fundamental objects in Lean's type theory! That's right-- everything in Lean is either a type universe, a dependent function, or some form of an  inductive type .

Now arguably, you might want to count quotients as a kind of fourth fundamental object, but in my opinion they are just a slight generalization of inductive types, namely they are a higher inductive type. But anyways, we'll cross that bridge when we get there.

For now, just know that inductive types are by far the biggest and most powerful category of the three, so we will get to know them slowly.

First, I want to point out that we have been using inductive types this entire time! `List`, `Int`, `String` are all examples of inductive types, and the defining feature of inductive types is that we can `match` them against patterns. Before we get to those types, let's see some simpler example of an inductive type:

:::


# Constructors

```lean -panel -stretch
inductive Weekday where
| monday
| tuesday
| wednesday
| thursday
| friday
-- !fragment
#check Weekday
-- !fragment
#check Weekday.monday
-- !fragment
#check Weekday.tuesday
```

:::notes

If you are familiar with Rust, note that this looks exactly like a Rust `enum`! When we define the `Weekday` type, we have introduced all these new constants. We have our new type `Weekday : Type` of course, but we also have these  constructors  for this type. These constructors are exactly the cases that we have to cover with a `match`:

:::


# Match Expressions

```lean -panel -stretch
def toDayNumber (day : Weekday) : Int :=
  match day with
  | .monday => 1
  | .tuesday => 2
  | .wednesday => 3
  | .thursday => 4
  | .friday => 5
-- !fragment
#eval toDayNumber Weekday.wednesday
```

:::notes

One thing to note about match statements in Lean is that they have to be  exhaustive . That means we have to provide a value for every possible input, so we have to cover every single constructor of `Weekday` with a case. Under the hood when the kernel type checks, Lean will essentially translate your `match` statement into a call to `Weekday.rec`, which is a function that is automatically generated for every inductive type. This function is called the  recursor :

:::


# Recursors

```lean -panel -stretch
-- !fragment
#check Weekday.rec
```

:::notes

Let's digest this type signature slowy. First, note that we have a type universe variable, and this is just so our `match` expression can return a value that lives in any type universe. Here, we use `Sort` instead of `Type` to handle the case of `Prop`, the universe of propositions. The details aren't important for now, but just know that `Sort u` is literally the same thing as `Type (u+1)`, so it is just a different numbering system.

We see that the first argument is `motive`, and this is just a method for enabling different arms of our `match` to be dependently typed. In the case of our `toDayNumber` function, our `motive` will just be this constant function (`fun x = Int`), always returning `Int`.

Then, we see an argument for each of the constructors we specified for our inductive type, and these will be the values that our `match` expression will take on in each case.

Finally, we take the argument `t : Weekday`, and this is the value we match against. The entire function then returns the value that the `match` should take on! Thus, our `toDayNumber` function in theory can be written as thus:

:::


# Recursors Continued

```lean -panel -stretch
noncomputable def toDayNumberV2 (day : Weekday) : Int :=
  @Weekday.rec (fun _ => Int) 1 2 3 4 5 day
```

:::notes

The fact that we have to mark this function as `noncomputable` is just a quirk of lean, as it only likes to generate executable code for `match` expressions but not raw calls into the recursor. Did I mention that you can compile your lean code into executable binaries? You can totally write real programs with Lean, but we won't be investigating that side of the language much.

Also, notice how the motive is an implicit parameter, but I'm choosing to explicitly write it out here! Lean's elaborator is able to automatically infer and construct the `motive` for your `match` statements, so normally you don't have to worry about writing the boilerplate for it even if you're using raw calls to the recursor.

However, for completeness, I want to show you an example of a slightly more complicated `motive`. If for some reason we wanted to write a function that returns values of different types depending on what day it is, we can do that!

:::


# Complex Motives

```lean -panel -stretch
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
-- !fragment
#eval myFunction Weekday.monday
-- !fragment
#eval myFunction Weekday.wednesday
```

:::notes

Note that we have to use the recursor to build the `myMotive` function before we can use it in our definition of `myFunction`! However, it won't be turtles all the way down, as the motive for the motive will just be a constant function:

:::


# Building the Motive

```lean -panel -stretch
noncomputable def myMotiveV2 (d : Weekday) : Type :=
  @Weekday.rec (fun _ => Type) Int Bool String
    (List Bool) (List Int) d

noncomputable def myFunctionV2 (d : Weekday) : myMotiveV2 d :=
  @Weekday.rec myMotiveV2 (5 : Int) Bool.true "it's wednesday"
    [Bool.true, Bool.false] [1, 2, 3] d
```

:::notes

With this, we have a firm handle on these simple inductive types, so now we are ready to see something slightly more complicated. First, let's pull up our old definition of our `Weekday` type, and let's write it out more verbosely by just adding a bunch of type annotations:

:::


# Verbosity

```lean -panel -stretch
inductive Weekday₂ : Type where
| monday : Weekday₂
| tuesday : Weekday₂
| wednesday : Weekday₂
| thursday : Weekday₂
| friday : Weekday₂
```

:::notes

Now, let's investigate the `Option` type, which is a type that can either contain `some` value or be `nothing`. Lean already has this type built in, so let's call our type `Opt` like so. Although the real `Option` is polymorphic over universes, let's keep our version simple.

:::


# Inductive Families

```lean -panel -stretch
inductive Opt (α : Type) : Type where
| some (_value : α) : Opt α
| nothing : Opt α
-- !fragment
#check (Opt : Type → Type)
#check Opt.some
-- !fragment
#check Opt.nothing
-- !fragment
#check Eq.rec
```

:::notes

Notice that we are introducing two new concepts: First, we are now defining an inductive family where we define a new inductive type `Opt α` for every type `α`. Here, since everything exists within our type theory, you can think of `Opt` as quite literally a function from `Type → Type`, just like `List`.

Second, we have a constructor that is taking in a parameter! Instead of just being a constant, a `some` option also holds some data. This will be familiar if you have used Rust's enums, and in C this is similar to a `union` of `struct`s. These two constructors implicitly quantify over types to handle `Option α` for any type `α`, and in the case of `some`, we also take an additional parameter for the inner value of the option. Again, these constructors are literally just irreducible, opaque functions that return an `Opt α`, and they are the only ways to make a `Opt α`.

Ok, let's take a look at some code for how we would use `Opt`:

:::


# Using Option

```lean -panel -stretch
def greet (name : Opt String) : String :=
  match name with
  | .some n => "curse you, " ++ n
  | .nothing => "nobody is attacking me!"
-- !fragment
#eval greet Opt.nothing
-- !fragment
#eval greet (Opt.some "Odysseus")
```

:::notes

Notice how we can access the inner value of the `some` in our `match` expression! Also, as a side note, notice that we never really have to give a name to this inner value, so in fact we could have written this:
:::


# Alternative Option Syntax

```lean -panel -stretch
inductive Opt₂ (α : Type) : Type where
| some : α → Opt₂ α
| nothing : Opt₂ α
```

:::notes
This is just a different spelling of the same thing, but it is slightly more cryptic. As you can see though, the linter does want us to spell it this way, so iggb.

Anyways, let's take a look at how the recursor works:

:::


# Option Recursor

```lean -panel -stretch
-- !fragment
#check Opt₂.rec
```

:::notes

This is almost the exact same as we saw with our `Weekday₂` type, except that `some` case has more information: the value we return for the `some` case is allowed to depend on the inner value! We give the recursor a function instead of a constant value to return. Again, we can write `greet` in terms of the raw recursor:

:::


# Option Recursor Usage

```lean -panel -stretch
noncomputable def greet₂ (name : Opt₂ String) : String :=
  @Opt₂.rec String (fun _ => String) (fun n => "curse you, " ++ n)
    "nobody is attacking me!" name
```

:::notes

Ok, so far this seems very boring, but even with just sets of `n` elements like are `Weekday₂` example, there is already some very unintuitive behavior! If we consider the analogy of inductive types being sets, there are two very important sets that we should pay attention to: the empty set, a set with zero elements, and the singleton set, a set with exaclty one element.

:::


# Empty and Singleton Sets

```lean -panel -stretch
inductive EmptySet where

inductive SingletonSet where
| elem : SingletonSet
```

:::notes

Yes, defining an inductive type with zero constructors is totally legal! In Rust, this `EmptySet` type is called `Never` and spelled with an exclamation point (`!`). The `SingletonSet` type here is called `Unit`, and can be thought of as the type of empty tuples. In the language of category theory, these two types are special because they are the initial and terminal objects of our category. Namely, with these two types, we can define these two very special functions:

:::


# Initial and Terminal Objects

```lean -panel -stretch
def intoSingleton {α : Type} : α → SingletonSet :=
  fun _ => SingletonSet.elem

def fromEmpty {_α : Type} : EmptySet → _α :=
  fun x => nomatch x
```

:::notes

Let's look at `SingletonSet` first. For every type `α`, we can define a function `intoSingleton` that maps `α` to `SingletonSet`. This function ignores its input and always just returns the single element of the singleton set, and this function is the only possible function you can define from `α` to `SingletonSet`.

Also worth mentioning is another important property that this `SingletonSet` has. Notice that functions `SingletonSet → α` necessarily must be constant functions, as there is only one possible input they can take and thus only one possible value they can output. In other words, these functions correspond one-to-one with terms of the type `α`.

:::


# From Singleton

```lean -panel -stretch
def fromSingleton {α : Type} (a : α) : SingletonSet → α :=
  fun x => match x with
    | .elem => a
```

:::notes

This property is exactly encoded in the type of the `SingletonSet`'s recursor:

:::


# Singleton Recursor

```lean -panel -stretch
-- !fragment
#check SingletonSet.rec

noncomputable def fromSingletonV2 {α : Type} (a : α) : SingletonSet → α :=
  SingletonSet.rec a
```

:::notes

Conversely we can also look at the `EmptySet`, which is dual to the `SingletonSet`. For every type `α`, you can define a unique function from `EmptySet` to `α` by pattern matching on the input `x : EmptySet`. Since `EmptySet` is a type with no constructors, our `match` statement on `x` has no cases at all, and in Lean we write this as `nomatch`. In fact, this `fromEmpty` function we have written is exactly the same as the `EmptySet` type's recursor!

:::


# From Empty

```lean -panel -stretch
-- !fragment
#check EmptySet.rec

noncomputable def fromEmptyV2 {_α : Type} : EmptySet → _α :=
  EmptySet.rec
```

:::notes

This is very strange. We have created a value of type `α` out of thin air, without writing any code at all. All this weirdness comes from the fact that we are defining a function on the empty set.

Here, remember this (`x : EmptySet`) can be implicitly read as `x` is an element of the empty set, which seems like a logical impossibility but is actually perfectly valid. Remember the context: we are defining a function. In the body of the function, we are working under the assumption that someone passed to us some element `x : EmptySet`, but since this `x` got passed to us from the outside, the act of using it to define this function is still perfectly fine.

But this discussion does hint at something pretty important: it will be utterly  impossible  to actually call this function! There are no constructors for `EmptySet`, so you can never actually make a term `el : EmptySet`, so you can never actually call `fromEmpty el`. This is why Rust calls this type `Never`.

Even though this function can never be called, it is still a real function. In fact, it is the  only  possible function that you can define from `EmptySet` to `α` for any type `α`.

Formally, a function `f : X → Y` can be thought of as simply a set of (input, output) pairs (`f ⊆ X × Y`). For example, consider these functions and the sets that they correspond to:

`toString : Int → String`
`\(..., (-2, "-2"), (-1, "-1"), (0, "0"), (1, "1"), ...\)`
...

The first part of every pair in the set is from `X` and the second part is from `Y`. It must be a well defined total function, so every element `x ∈ X` must appear in exactly one pair in `f`.

Now consider the case that `X` is the empty set. Then, we would need `f : ∅ → Y` to be a set of pairs, where the first of each pair is from the empty set and the second is from `Y` (`f ⊆ ∅ × Y`). Since the empty set is empty, there is only one such possible set of pairs: the empty set (`f ⊆ ∅ × Y = ∅ \implies f = ∅`). `f` is an empty relation, and it is unique-- the only way to define a function from `∅` to `Y`.

As you can see, in this view we have completely avoided the need to choose an element of `Y` in order to define our function, and one can think of the `nomatch` in Lean as doing the same thing. We are taking advantage of the properties of the empty sets to vacously construct our function: In math, it would be perfectly valid to say that "for all numbers X in the empty set, X is prime and X is equal to 4". In Lean, it is perfectly valid for our function `fromEmpty` to say "for all terms of type `EmptySet`, I can give you a term of type `α`".

In fact, this analogy is the basis for mathematics in Lean! We can think of the `SingletonSet` as encoding 'True' and the `EmptySet` as encoding 'False'. Types correspond to propositions, and terms of the type correspond to proofs of the proposition: 'True' always has a trivial proof, but 'False' has no possible proof. This is called the Curry-Howard correspondence, where every proposition corresponds to some type. If a proposition is provable, then we should be able to construct a term of its corresponding type, and we say that the type is  inhabited . Otherwise, if the proposition is false, there should be no possible proof and thus no term of that type, and the type is the  uninhabited  empty type.

Now, it is finally time to revist the `Prop` universe that we skipped over earlier. Every mathematical proposition lives in this type universe, and it lives at the bottom of the type universe heirarchy. `Prop` can also be written as `Sort 0` or just `Sort`.

:::


# Empty Recursor

```lean -panel -stretch
-- !fragment
#check Prop
-- !fragment
#check Sort 0
```

:::notes

As I have mentioned, `Prop` does not follow the normal rules for type universes. This is because lean has a feature called  proof irrelevance  that causes some weirdness, but I will talk more about that later. For now, just know that Lean considers two proofs of the same proposition as literally the same object, even if these two proofs were constructed in completely different ways. This has the effect of essentially forcing every type in the `Prop` universe to be either be empty like `EmptySet` or contain exactly one term like `SingletonSet`. This makes proofs easier to reason about, as ultimately we really only need to track if a proposition has a proof, not  how  it was proved.

Again, it requires some finesse to avoid having this lead to logical paradoxes, but we'll cover those issues as they arise. First, let's see how to express some basic logical statements as types.

:::


# Prop Universe

```lean -panel -stretch
inductive MyTrue : Prop where
| mk : MyTrue

inductive MyFalse : Prop where

inductive MyAnd (P : Prop) (Q : Prop) : Prop where
| intro (_proofOfP : P) (_proofOfQ : Q) : MyAnd P Q

inductive MyOr (P : Prop) (Q : Prop) : Prop where
| inl (_proofOfP : P) : MyOr P Q
| inr (_proofOfQ : Q) : MyOr P Q
```

:::notes

We see that `MyTrue` and `MyFalse` is the same thing as our `SingletonSet` and `EmptySet` that we just saw. Then, we see that we can define our logical connectives, `And` and `Or`: our `And` type has one constructor.

:::


# Logical Connectives

```
MyAnd.intro : P → Q → MyAnd P Q
```

:::notes

It takes in both a proof of P and a proof of Q, and it constructs a proof of `P ∧ Q`. This makes sense-- to prove `P ∧ Q`, you must separately prove both `P` and `Q`.

Similarly, our `Or` type has two constructors, `inl` for 'in from the left' and `inr` for 'in from the right'.

:::


# And Constructor

```
MyOr.inl : P → MyOr P Q
MyOr.inr : Q → MyOr P Q
```

:::notes

To prove `P ∨ Q`, you can either prove `P` or prove `Q`. Thus, a proof of `P ∨ Q` is either just a proof of `P` or a proof of `Q`. This means that the type `P ∨ Q` is inhabited if either `P` is inhabited or `Q` is inhabited.

If you're familiar with algebraic datatypes, you will recognize that `And` is just the algebraic product type, and `Or` is just the algebraic sum type! `And` is simply a `struct` or a tuple, and `Or` is simply a Rust `enum` or a C `union`. In the language of sets, `And` is the cartesian product, and `Or` is the disjoint union or 'direct sum'. And this analogy with sets works very well: if you take the cartesian product of any set with an empty set, you always get an empty set back. And if you take the disjoint union of any nonempty set with any set whatsoever, you will get another nonempty set.

Ok then, next up is 'implies'! Remember that 'P implies Q' just means that 'if P is true, then Q is also true'. Let's begin by reviewing the truth table for 'implies':

:::


# Or Constructors

```
| P | Q | P → Q |
| - * - * ----- |
| F | F | T     |
| F | T | T     |
| T | F | F     |
| T | T | T     |
```

:::notes

This truth table asks the question 'if P and Q take on these specific values, would it be true that P implies Q?'. For example, take the concrete example where 'P' is 'John is drinking alcohol' and 'Q' is 'John is over 21'.

First off, if P is false, then 'P implies Q' would be vacously true, since the condition for it to mean anything has not been met. Our rule that 'if P then Q' does not come into effect if P is not true in the first place! If John is not drinking alcohol, we don't care how old he is!

On the other hand, if P is true and Q is also true, the our rule that "if P then Q" is obviously working. This corresponds to  modus ponens , and it is intuitively the normal way one would apply the rule. If John is drinking alcohol and over 21, everything checks out.

Finally, the only row where `P → Q` is false is the case where P is true, but Q is not true. This case is a direct counterexample to our rule that "if P, then Q", and it is related to  modus tollens , or the contrapositive of the statement. If John is drinking alcohol but is not over 21, there's some underage drinking happening! Thus, if John is not over 21, he should not be drinking alcohol.

With this truth table in mind, here's how you would encode this as a type: the logical statement 'P implies Q' corresponds to type of functions from P → Q!

:::


# Implication Truth Table

```lean -panel -stretch
axiom JohnIsDrinkingAlcohol : Prop
axiom JohnIsOver21 : Prop

-- `theorem` is just the same as `def` but for
-- functions that return a type in `Prop`.
theorem no_underage_drinking (_h : JohnIsDrinkingAlcohol) : JohnIsOver21 := sorry
-- !fragment
#check @no_underage_drinking
```

:::notes

To prove that `P` implies `Q`, one needs to provide a function that takes in a proof of `P` and returns a proof of `Q`. Our function `no underage drinking` takes in a proof `h` that `JohnIsDrinkingAlcohol` and uses it to construct a proof that `JohnIsOver21`, thereby proving the theorem that "if john is drinking alcohol, then john is over 21".

Before we go over how this correctly implements the truth table for 'implies', let's go over the new Lean concepts that we introduced here: `theorem`, `axiom`, and `sorry`.

`theorem` is basically the same thing as `def`, except you are forced to ultimately return a proof of some `Prop`, meaning you are not allowed to return a value whose type lives in any other universe. Note that the type of `no underage drinking` itself is a `Prop`, namely `JohnIsDrinkingAlcohol → JohnIsOver21 : Prop` since `JohnIsDrinkingAlcohol : Prop` and `JohnIsOver21 : Prop`. This is the same behavior that we would expect from any type universe, for example `Int : Type` and `String : Type`, so the function type `Int → String : Type`.

Next, `axiom` simply introduces a new term of any type into the current context. Because proofs of a proposition are simply terms of the corresponding type, assuming a proposition as an axiom is the same as magically having some term of that type. Counterintuitively, `axiom` can also be used to create terms of types that are not propositions, like we are doing here. In that case, we just have an opaque, irreducible term of that type.

Finally, `sorry` is just a way to tell lean that we don't have a proof of this theorem yet, but just to assume it is true and continue anyways. Under the hood, `sorry` is just calling a built-in Lean axiom called `sorryAx` that lets you magically construct a term of literally any type `α`, even if `α` is an empty type like `EmptySet`.

:::


# Implication as Function

```lean -panel -stretch
-- !fragment
#check sorryAx
```

:::notes

The bool parameter there is just some internal bookkeeping used by Lean. Of course, it would not be valid to use `sorryAx` in real proofs, and Lean will naturally track if you have used `sorryAx` at any point in constructing your theorem: we see here that Lean knows about all the axioms that went into constructing `no underage drinking`.

:::


# Sorry Axiom

```lean -panel -stretch
#print axioms no_underage_drinking
```

:::notes

Anyways, let's get back to the truth table for 'implies'. Notice that the first two rows actually correspond to the `fromEmpty` function we saw before: we are always able to construct a function that takes in a proof of a false proposition and returns a proof of any proposition whatsoever. This means that for any proposition Q, we always have a proof that 'False implies Q'!

:::


# Axioms Command

```lean -panel -stretch
theorem fromFalse (Q : Prop) : MyFalse → Q :=
  fun x => nomatch x

-- or, alternatively:
theorem fromFalseV2 (Q : Prop) : MyFalse → Q :=
  MyFalse.rec
```

:::notes

Notice the similarity between `fromFalse` and `sorryAx`. Essentially, having a valid proof of `False` is the same thing as having `sorryAx`!

In this context, the weird behavior of the empty set's recursor corresponds to the  principle of explosion  in logic, where once you have a proof of a false statement, you can prove anything at all.  ex falso quodlibet .

REWRITE
Anyways, let's look at the next row of the truth table. For two true propositions `P` and `Q`, one is able to construct a function that maps the proof of `P` to the proof of `Q`, thereby proving that `P` implies `Q`. Remember that `P` and `Q` would essentially be the `SingletonSet` type, meaning they have one term because of proof irrelevance.

On the other hand, it would be impossible to construct a function that maps a proof of a true proposition to a false proposition: this function must construct a term of an empty type, which is impossible if you do not already have a term of an empty type. Thus, it will be impossible to prove that `True` implies `False`.

Additionally, this construction also allows us to encode the negation of a proposition as a type. Look at the truth table, and focus on the rows where `Q` is false. In this case, 'P implies Q' is exactly 'not P'! So, we simply encode `¬P` as the function type `P → False`, and to prove `¬P` we simply prove that assuming `P` leads to a contradiction.

Now that about covers it for 'implies', which are regular old function types. But what about  dependent  function types? It turns out, you end up with 'for all', and here is where the `Prop` universe's weirdness begins to show a little bit.

REWRITE THIS PART TO BE CLEARER, PROBABY MOVE UP THE EXAMPLE
:::


# Ex Falso Quodlibet

```lean -panel -stretch
def ForAll {X : Type} (P : X → Prop) : Prop :=
  (x : X) → P x
```

:::notes

Essentially, to prove that 'for all x, P(x) is true', you just write a function that takes in any arbitrary 'x' and returns a proof of 'P(x)'. Here, you are taking advantage of lean being dependently typed, as the type of the return value depends on the value of the input to the function! Recall back to our example of using motives with the `Weekday₂` inductive type. show code here. In this new example, 'P' would be our motive. For now, I'm going to keep things abstract, but we will look at an example later, after we have covered all the basic constructions we need to start doing real math.

But first, let me point out that these 'for all' propositions are breaking the rules a little bit! This function type (`(x : X) → P x`) lives in `Prop`, but `X` lives in `Type`. How is that possible? Remember what I said about normal type universes? quote here

Normally, we would expect the universe level of `α → β` to be the maximum of the universe levels that `α` and `β` belong to!

For example, consider the function `Nat → Type`. This could be the type of a function like `ArrayN` for instance, a function that takes in a number `n` and gives you the type of arrays of a fixed length `n`. Then, since `Nat : Type` and `Type : Type 1`, we have that `Nat → Type : Type 1`, the maximum of the two. But the `Prop` universe is not following this rule!

We have `(x : X) → P x : Prop`, but `X : Type` and `P x : Prop`, and `Type` is a bigger universe than `Prop` as `Prop : Type`. Normally, this would mean that `(x : X) → P x : Type`, but the `Prop` universe is special. If your function ultimately returns a value whose type is in the `Prop` universe, that function type is also in the `Prop` universe. This means that the function types corresponding to 'for all' statements remain in the `Prop` universe, as desired. This is exactly why the `imax` function on universe levels is defined in such a weird way, where if the second parameter is `0` you return `0`. Remember that `Sort 0` is `Prop`, so this definition allows you to write the following code cleanly:

:::


# For All

```lean -panel -stretch
universe u v

variable (X : Sort u) (Y : Sort v)
-- !fragment
#check X → Y
```

:::notes

If you are curious for more details, you can look into the chapter on universe levels in 'Theorem Proving in Lean4'. But take a look at this example and notice how this mechanism enables the 'for all' proposition's propensity to propogate its `Prop`ness upwards:

:::


# Function Universes

```lean -panel -stretch
section

variable (IsSpecial : String → Int → Prop)
variable (s : String)
-- !fragment
#check (n : Int) → IsSpecial s n
-- !fragment
#check (s : String) → (n : Int) → IsSpecial s n
end
```

:::notes

Remember that `→` is right-associative, so first lets look at the function on the right hand side. We see that given some string `s`, this function type `(n : Int) → IsSpecial s n` is a proposition that 'for all integers n, s and n are special'. Even though the type of the first argument lives in `Type`, the type of the return value lives in `Prop`, so this function type lives in `Prop`. Then, our overall type can be interpreted as a function type that takes in a `String` and returns a value of this function type, which as we have just established, lives in `Prop`. This, overall we have a function `String`, which is a `Type`, to `Int → P s n`, which is a `Prop`, so the overall type is also still a `Prop`. We have propogated the `Prop`ness of `IsSpecial s n` all the way up to the entire function type! This is the type of a function that takes in a string `s` and an integer `n` and ultimately returns a proof that `s` and `n` are special, and this function itself is a proof that 'for all s and n, s and n are special'.

Ok, admittedly that was a pretty confusing example, but the overall point is just that even if your function takes multiple arguments, your function type will still be a `Prop` corresponding to a 'for all' if you ultimately return a type that lives in `Prop` at the end.





So, hopefully you are getting the hang of these simple inductive types, but there is still so much more to cover!
All of the data types we have seen so far have not been recursive, and recursion is really the core of what inductive types are for! I think we are finally ready to tackle the `List` type, and this time I will make it polymorphic over universes. This will code will be exactly the same as how the real `List` type is implemented in Lean:

:::


# Propagating Propness

```lean -panel -stretch
inductive MyList (α : Type u) : Type u where
| empty : MyList α
| cons : α → MyList α → MyList α
-- !fragment
#check MyList.cons

-- this is the list [1, 2, 3]
def oneTwoThree : MyList Int :=
  MyList.cons 1 (MyList.cons 2 (MyList.cons 3 MyList.empty))
```

:::notes

If you have taken an intro to computer science class, you will recognize what we have written here as a linked list! Every list is either the empty list (`MyList.empty`), or it contains some first element along with a (possibly empty) list of the remaining elements. Just like with regular lists, we can use `match`'s pattern matching to define recursive functions-- for example, we can write a function that appends an element to the end of the list:

:::


# Linked Lists

```lean -panel -stretch
def appendAtEnd {α : Type u} (ls : MyList α) (a : α) : MyList α :=
  match ls with
  | .empty => MyList.cons a MyList.empty
  | .cons x xs => MyList.cons x (appendAtEnd xs a)
-- !fragment
#eval appendAtEnd oneTwoThree 4
```

:::notes

Here, if we want to append `a` to the end of an empty list, we can just return a new list with a single element. Otherwise, we can recurse down into the list: mentally we take out the first element `x` and then use a recursive call to append `a` to the list of reamining elements `xs`.

Note that this code is extremely similar to what we were able to write with Lean's built in lists in `reverseList₃`. It is almost one-to-one, accounting for the fact that the functions are doing two slightly different things. One of the only differences is that the built in `List` has nicer notation, where we can write the `.empty` constructor as simply `()`, and we can write `x::xs` instead of `.cons x xs`. We can also write `(1, 2, 3)` instead of repeatedly calling the constructor `MyList.cons`. All of this, however, are just custom notation and macros, and it just expands out to the same thing. That's right, you can define custom infix notations and macros in Lean itself, and if you ctrl/command click in VsCode, you can actually just read the Lean code that implements these syntaxes! Even things like `match` expressions and the `+` operator are defined in Lean itself.

:::


# List Append

```
-- `+` gets translated to a call to the `hAdd` function.
-- this actually uses typeclasses, which is a feature we haven't covered yet.
@[inherit_doc] infixl:65 " + "   => HAdd.hAdd

-- macro for the [1, 2, 3] list syntax
macro_rules
  | `([ $elems,* ]) => do
    -- NOTE: we do not have `TSepArray.getElems` yet at this point
    let rec expandListLit (i : Nat) (skip : Bool)
        (result : TSyntax `term) : MacroM Syntax := do
      match i, skip with
      | 0,   _     => pure result
      | i+1, true  => expandListLit i false result
      | i+1, false => expandListLit i true
          (← ``(List.cons $(⟨elems.elemsAndSeps.get!Internal i⟩) $result))
    let size := elems.elemsAndSeps.size
    if size < 64 then
      expandListLit size (size % 2 == 0) (← ``(List.nil))
    else
      `(%[ $elems,* | List.nil ])
```

:::notes

These features are obviously very cool and very useful, but just as obviously it's beyond the scope of this video.

Anyways, back to inductive types. Let's see how the List type's recursor works:

:::


# Custom Notation

```lean -panel -stretch
-- !fragment
#check MyList.rec
```

:::notes

TODO TODO TODO

structural recursion

variables
:::

```lean -panel -stretch
variable {α : Type u}
```

:::notes
actually this is not necessary, but they are useful if you want an argument that is not a just type.

:::


# List Recursor

```lean -panel -stretch
noncomputable def appendAtEndV2 {α : Type u} (ls : MyList α) (a : α) : MyList α :=
  @MyList.rec α (fun _ => MyList α) (MyList.cons a MyList.empty)
    (fun x _xs append_of_xs => MyList.cons x append_of_xs) ls
-- !fragment
#check appendAtEndV2
```

:::notes

proof of termination: `WellFounded.fix`
- induction implies complete induction
- everything gets rephrased into a structural recursion

partial functions. kinda like the opposite of noncomputable.


:::


# Append V2

```lean -panel -stretch
inductive NatNum : Type where
| zero : NatNum
| succ : NatNum → NatNum
```

:::notes

TODO TODO


:::

```lean -panel -stretch
inductive Equals {α : Type} (a : α) : α → Type where
| refl : Equals a a

#print Equals.rec
```
