import VersoSlides
import VersoContent.Slides.IntroLeanVideo

open VersoSlides

def main : IO UInt32 := do
  let c1 ← slidesMain
    (config := { outputDir := "_slides/IntroLeanVideo", theme := "black", slideNumber := true, transition := "slide", width := 2560 / 2, height := 1600 / 2 })
    (doc := %doc VersoContent.Slides.IntroLeanVideo)

  if c1 != 0 then return c1

  -- Add future slideshows here in the same format:
  -- let c2 ← slidesMain (config := { outputDir := "_slides/MySlideshow", ... }) (doc := %doc VersoContent.Slides.MySlideshow)
  -- if c2 != 0 then return c2

  return 0
