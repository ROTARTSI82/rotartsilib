import VersoManual
import VersoContent.Book.Introduction
import VersoContent.Book.NextSteps

open Verso.Genre Manual
open Verso.Genre.Manual.InlineLean

set_option pp.rawOnError true

#doc (Manual) "My Book" =>

%%%
authors := ["Author"]
%%%

This is a short book written with Verso's Manual genre.

{include 1 VersoContent.Book.Introduction}

{include 1 VersoContent.Book.NextSteps}
