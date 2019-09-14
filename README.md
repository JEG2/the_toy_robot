# The Toy Robot

This code is my rendition of the popular interviewing exercise that I learned about from Ryan Bigg's book:

https://leanpub.com/elixir-toyrobot

I would talk about these aspects of it in an interview:

* My primary solution is under 50 lines of code, not because I golfed it, but because I tried to throw the right amount of solution at a problem of this size
* I wrote a pipeline of transformations
* This is a trival state machine
* I'm doing very little work here, outside of pattern matching
* The table doesn't feel like a data concept as specified, so I chose just to track robot state
* I always prefer to handle individual instructions, then add a wrapper that performs the required handling of many instructions
* I considered generating all possible `{x, y, f}, "MOVE"` function heads, but didn't because it makes the code uglier
* I considered property testing, but the code is so small that I could basically exhaustively unit test it
* I paid careful attention to the interplay of `:async` tests and `capture_io/1`
* I have purposefully avoided the use of processes and the OTP here, because I don't want to complicate this completely synchronous exercise
