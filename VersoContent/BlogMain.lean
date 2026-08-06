import VersoBlog
import VersoContent.Blog

open Verso Genre Blog Site Syntax

def blog : Site := site VersoContent.Blog.FrontPage /
  "about" VersoContent.Blog.About
  "blog" VersoContent.Blog.Posts with
    VersoContent.Blog.Posts.FirstPost
    VersoContent.Blog.Posts.IntroLeanVideo

def main := blogMain .default blog
